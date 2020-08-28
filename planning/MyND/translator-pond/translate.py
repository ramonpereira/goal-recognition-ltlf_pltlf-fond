#! /usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys

def python_version_supported():
    major, minor = sys.version_info[:2]
    return (major == 2 and minor >= 7) or (major, minor) >= (3, 2)

if not python_version_supported():
    sys.exit("Error: Translator only supports Python >= 2.7 and Python >= 3.2.")


import argparse
from collections import defaultdict
from copy import deepcopy
from itertools import product

import axiom_rules
import fact_groups
import instantiate
import normalize
import pddl
import sas_tasks
import simplify
import timers
import tools

# FOND
def partition(seq, key):
    partition = {}
    for elem in seq:
        partition.setdefault(key(elem),[]).append(elem)
    return partition.values()

# TODO: The translator may generate trivial derived variables which are always
# true, for example if there is a derived predicate in the input that only 
# depends on (non-derived) variables which are detected as always true.
# Such a situation was encountered in the PSR-STRIPS-DerivedPredicates domain.
# Such "always-true" variables should best be compiled away, but it is
# not clear what the best place to do this should be. Similar
# simplifications might be possible elsewhere, for example if a
# derived variable is synonymous with another variable (derived or
# non-derived).

USE_PARTIAL_ENCODING = True
DETECT_UNREACHABLE = True
DUMP_TASK = False

## Setting the following variable to True can cause a severe
## performance penalty due to weaker relevance analysis (see issue7).
ADD_IMPLIED_PRECONDITIONS = False

DEBUG = False

simplified_effect_condition_counter = 0
added_implied_precondition_counter = 0


def strips_to_sas_dictionary(groups, assert_partial):
    dictionary = {}
    for var_no, group in enumerate(groups):
        for val_no, atom in enumerate(group):
            dictionary.setdefault(atom, []).append((var_no, val_no))
    if assert_partial:
        assert all(len(sas_pairs) == 1
                   for sas_pairs in dictionary.values())
    return [len(group) + 1 for group in groups], dictionary


def translate_strips_conditions_aux(conditions, dictionary, ranges):
    condition = {}
    for fact in conditions:
        if fact.negated:
            # we handle negative conditions later, because then we
            # can recognize when the negative condition is already
            # ensured by a positive condition
            continue
        for var, val in dictionary.get(fact, ()):
            # The default () here is a bit of a hack. For goals (but
            # only for goals!), we can get static facts here. They
            # cannot be statically false (that would have been
            # detected earlier), and hence they are statically true
            # and don't need to be translated.
            # TODO: This would not be necessary if we dealt with goals
            # in the same way we deal with operator preconditions etc.,
            # where static facts disappear during grounding. So change
            # this when the goal code is refactored (also below). (**)
            if (condition.get(var) is not None and
                    val not in condition.get(var)):
                # Conflicting conditions on this variable: Operator invalid.
                return None
            condition[var] = set([val])

    def number_of_values(var_vals_pair):
        var, vals = var_vals_pair
        return len(vals)

    for fact in conditions:
        if fact.negated:
           ## Note  Here we use a different solution than in Sec. 10.6.4
           ##       of the thesis. Compare the last sentences of the third
           ##       paragraph of the section.
           ##       We could do what is written there. As a test case,
           ##       consider Airport ADL tasks with only one airport, where
           ##       (occupied ?x) variables are encoded in a single variable,
           ##       and conditions like (not (occupied ?x)) do occur in
           ##       preconditions.
           ##       However, here we avoid introducing new derived predicates
           ##       by treat the negative precondition as a disjunctive
           ##       precondition and expanding it by "multiplying out" the
           ##       possibilities.  This can lead to an exponential blow-up so
           ##       it would be nice to choose the behaviour as an option.
            done = False
            new_condition = {}
            atom = pddl.Atom(fact.predicate, fact.args)  # force positive
            for var, val in dictionary.get(atom, ()):
                # see comment (**) above
                poss_vals = set(range(ranges[var]))
                poss_vals.remove(val)

                if condition.get(var) is None:
                    assert new_condition.get(var) is None
                    new_condition[var] = poss_vals
                else:
                    # constrain existing condition on var
                    prev_possible_vals = condition.get(var)
                    done = True
                    prev_possible_vals.intersection_update(poss_vals)
                    if len(prev_possible_vals) == 0:
                        # Conflicting conditions on this variable:
                        # Operator invalid.
                        return None

            if not done and len(new_condition) != 0:
                # we did not enforce the negative condition by constraining
                # an existing condition on one of the variables representing
                # this atom. So we need to introduce a new condition:
                # We can select any from new_condition and currently prefer the
                # smallest one.
                candidates = sorted(new_condition.items(), key=number_of_values)
                var, vals = candidates[0]
                condition[var] = vals

        def multiply_out(condition):  # destroys the input
            sorted_conds = sorted(condition.items(), key=number_of_values)
            flat_conds = [{}]
            for var, vals in sorted_conds:
                if len(vals) == 1:
                    for cond in flat_conds:
                        cond[var] = vals.pop()  # destroys the input here
                else:
                    new_conds = []
                    for cond in flat_conds:
                        for val in vals:
                            new_cond = deepcopy(cond)
                            new_cond[var] = val
                            new_conds.append(new_cond)
                    flat_conds = new_conds
            return flat_conds

    return multiply_out(condition)


def translate_strips_conditions(conditions, dictionary, ranges,
                                mutex_dict, mutex_ranges):
    if not conditions:
        return [{}]  # Quick exit for common case.

    # Check if the condition violates any mutexes.
    if translate_strips_conditions_aux(conditions, mutex_dict,
                                       mutex_ranges) is None:
        return None

    return translate_strips_conditions_aux(conditions, dictionary, ranges)


def translate_strips_operator(operator_list, dictionary, ranges, mutex_dict,
                              mutex_ranges, implied_facts):
    result = [] # FOND
    for operator in operator_list: # FOND TODO: compute conditions only once!
        conditions = translate_strips_conditions(operator.precondition, dictionary,
                                                 ranges, mutex_dict, mutex_ranges)
        if conditions is None:
            return []
        sas_operators = []
        for condition in conditions:
            op = translate_strips_operator_aux(operator, dictionary, ranges,
                                               mutex_dict, mutex_ranges,
                                               implied_facts, condition)
            if op is not None:
                sas_operators.append(op)
        result.extend(sas_operators) # FOND
    
    return result


def negate_and_translate_condition(condition, dictionary, ranges, mutex_dict,
                                   mutex_ranges):
    # condition is a list of lists of literals (DNF)
    # the result is the negation of the condition in DNF in
    # finite-domain representation (a list of dictionaries that map
    # variables to values)
    negation = []
    if [] in condition:  # condition always satisfied
        return None  # negation unsatisfiable
    for combination in product(*condition):
        cond = [l.negate() for l in combination]
        cond = translate_strips_conditions(cond, dictionary, ranges,
                                           mutex_dict, mutex_ranges)
        if cond is not None:
            negation.extend(cond)
    return negation if negation else None


def translate_strips_operator_aux(operator, dictionary, ranges, mutex_dict,
                                  mutex_ranges, implied_facts, condition):

    # collect all add effects
    effects_by_variable = defaultdict(lambda: defaultdict(list))
    # effects_by_variables: var -> val -> list(FDR conditions)
    add_conds_by_variable = defaultdict(list)
    for conditions, fact in operator.add_effects:
        eff_condition_list = translate_strips_conditions(conditions, dictionary,
                                                         ranges, mutex_dict,
                                                         mutex_ranges)
        if eff_condition_list is None:  # Impossible condition for this effect.
            continue
        for var, val in dictionary[fact]:
            effects_by_variable[var][val].extend(eff_condition_list)
            add_conds_by_variable[var].append(conditions)

    # collect all del effects
    del_effects_by_variable = defaultdict(lambda: defaultdict(list))
    for conditions, fact in operator.del_effects:
        eff_condition_list = translate_strips_conditions(conditions, dictionary,
                                                         ranges, mutex_dict,
                                                         mutex_ranges)
        if eff_condition_list is None:  # Impossible condition for this effect.
            continue
        for var, val in dictionary[fact]:
            del_effects_by_variable[var][val].extend(eff_condition_list)

    # add effect var=none_of_those for all del effects with the additional
    # condition that the deleted value has been true and no add effect triggers
    for var in del_effects_by_variable:
        no_add_effect_condition = negate_and_translate_condition(
            add_conds_by_variable[var], dictionary, ranges, mutex_dict,
            mutex_ranges)
        if no_add_effect_condition is None:  # there is always an add effect
            continue
        none_of_those = ranges[var] - 1
        for val, conds in del_effects_by_variable[var].items():
            for cond in conds:
                # add guard
                if var in cond and cond[var] != val:
                    continue  # condition inconsistent with deleted atom
                cond[var] = val
                # add condition that no add effect triggers
                for no_add_cond in no_add_effect_condition:
                    new_cond = dict(cond)
                    # This is a rather expensive step. We try every no_add_cond
                    # with every condition of the delete effect and discard the
                    # overal combination if it is unsatisfiable. Since
                    # no_add_effect_condition is precomputed it can contain many
                    # no_add_conds in which a certain literal occurs. So if cond
                    # plus the literal is already unsatisfiable, we still try
                    # all these combinations. A possible optimization would be
                    # to re-compute no_add_effect_condition for every delete
                    # effect and to unfold the product(*condition) in
                    # negate_and_translate_condition to allow an early break.
                    for cvar, cval in no_add_cond.items():
                        if cvar in new_cond and new_cond[cvar] != cval:
                            # the del effect condition plus the deleted atom
                            # imply that some add effect on the variable
                            # triggers
                            break
                        new_cond[cvar] = cval
                    else:
                        effects_by_variable[var][none_of_those].append(new_cond)
    # handle observations
    observation = [dictionary.get(obs, ())[0] for obs in operator.observation]

    return build_sas_operator(operator.name, condition, effects_by_variable,
                              operator.cost, ranges, implied_facts, observation)


def build_sas_operator(name, condition, effects_by_variable, cost, ranges,
                       implied_facts, observation):
    if ADD_IMPLIED_PRECONDITIONS:
        implied_precondition = set()
        for fact in condition.items():
            implied_precondition.update(implied_facts[fact])

    pre_post = []
    for var in effects_by_variable:
        orig_pre = condition.get(var, -1)
        for post, eff_conditions in effects_by_variable[var].items():
            pre = orig_pre
            # if the effect does not change the variable value, we ignore it
            if pre == post:
                continue
            # otherwise the condition on var is not a prevail condition but a
            # precondition, so we remove it from the prevail condition
            condition.pop(var, -1)
            eff_condition_lists = [sorted(eff_cond.items())
                                   for eff_cond in eff_conditions]
            if ranges[var] == 2:
                # Apply simplifications for binary variables.
                if prune_stupid_effect_conditions(var, post,
                                                  eff_condition_lists):
                    global simplified_effect_condition_counter
                    simplified_effect_condition_counter += 1
                if (ADD_IMPLIED_PRECONDITIONS and pre == -1 and
                        (var, 1 - post) in implied_precondition):
                    global added_implied_precondition_counter
                    added_implied_precondition_counter += 1
                    pre = 1 - post
            for eff_condition in eff_condition_lists:
                # we do not need to represent a precondition as effect condition
                if (var, pre) in eff_condition:
                    eff_condition.remove((var, pre))
                pre_post.append((var, pre, post, eff_condition))

    # FOND: Noops as nondeterminstic effects are allowed!
    #if not pre_post:  # operator is noop
        #return None
    prevail = list(condition.items())
    return sas_tasks.SASOperator(name, prevail, pre_post, cost, observation)   

def prune_stupid_effect_conditions(var, val, conditions):
    ## (IF <conditions> THEN <var> := <val>) is a conditional effect.
    ## <var> is guaranteed to be a binary variable.
    ## <conditions> is in DNF representation (list of lists).
    ##
    ## We simplify <conditions> by applying two rules:
    ## 1. Conditions of the form "var = dualval" where var is the
    ##    effect variable and dualval != val can be omitted.
    ##    (If var != dualval, then var == val because it is binary,
    ##    which means that in such situations the effect is a no-op.)
    ## 2. If conditions contains any empty list, it is equivalent
    ##    to True and we can remove all other disjuncts.
    ##
    ## returns True when anything was changed
    if conditions == [[]]:
        return False  # Quick exit for common case.
    assert val in [0, 1]
    dual_fact = (var, 1 - val)
    simplified = False
    for condition in conditions:
        # Apply rule 1.
        while dual_fact in condition:
            # print "*** Removing dual condition"
            simplified = True
            condition.remove(dual_fact)
        # Apply rule 2.
        if not condition:
            conditions[:] = [[]]
            simplified = True
            break
    return simplified


def translate_strips_axiom(axiom, dictionary, ranges, mutex_dict, mutex_ranges):
    conditions = translate_strips_conditions(axiom.condition, dictionary,
                                             ranges, mutex_dict, mutex_ranges)
    if conditions is None:
        return []
    if axiom.effect.negated:
        [(var, _)] = dictionary[axiom.effect.positive()]
        effect = (var, ranges[var] - 1)
    else:
        [effect] = dictionary[axiom.effect]
    axioms = []
    for condition in conditions:
        axioms.append(sas_tasks.SASAxiom(condition.items(), effect))
    return axioms

def translate_strips_operators(actions, strips_to_sas, ranges, mutex_dict,
                            mutex_ranges, implied_facts):
    # FOND Step 1: Group actions by name. Different actions with the same name
    #         are in fact just different non-deterministic versions of the
    #         same action with equal parameters and conditions.
    actions_by_name = partition(actions, (lambda a: a.name))
    result = []
    for action_list in actions_by_name:
        sas_ops = translate_strips_operator(action_list, strips_to_sas, ranges,
                                            mutex_dict, mutex_ranges,
                                            implied_facts)
        if len(sas_ops) > 0:
            # FOND Step 2: Translate groups of actions with the same name 
            # and precondition together.
            operatorname = sas_ops[0].name
            assert all(op.name == operatorname for op in sas_ops)
            operatorcost = sas_ops[0].cost
            assert all(op.cost == operatorcost for op in sas_ops)
            observation = sas_ops[0].observation
            assert all(op.observation == observation for op in sas_ops)
            #preconditions = sas_ops[0].get_preconditions()
            ops_by_name = partition(sas_ops, (lambda a: repr(a.get_preconditions())))
            for op_list in ops_by_name:
                prevail = set()
                pre_post = []
                for op in op_list:
                    prevail |= set(op.prevail)
                    pre_post.append(sorted(op.pre_post))
                result.append(sas_tasks.SASOperator(operatorname, prevail, pre_post, operatorcost, observation))
        
    return result



def translate_strips_axioms(axioms, strips_to_sas, ranges, mutex_dict,
                            mutex_ranges):
    result = []
    for axiom in axioms:
        sas_axioms = translate_strips_axiom(axiom, strips_to_sas, ranges,
                                            mutex_dict, mutex_ranges)
        result.extend(sas_axioms)
    return result


def dump_task(init, goals, actions, axioms, axiom_layer_dict):
    old_stdout = sys.stdout
    with open("output.dump", "w") as dump_file:
        sys.stdout = dump_file
        print("Initial state")
        for atom in init:
            print(atom)
        print()
        print("Goals")
        for goal in goals:
            print(goal)
        for action in actions:
            print()
            print("Action")
            action.dump()
        for axiom in axioms:
            print()
            print("Axiom")
            axiom.dump()
        print()
        print("Axiom layers")
        for atom, layer in axiom_layer_dict.items():
            print("%s: layer %d" % (atom, layer))
    sys.stdout = old_stdout


def translate_task(strips_to_sas, ranges, translation_key,
                   mutex_dict, mutex_ranges, mutex_key,
                   init, init_unknown, init_oneof, init_formula, goals,
                   actions, observation_actions, axioms, metric, implied_facts):
    with timers.timing("Processing axioms", block=True):
        axioms, axiom_init, axiom_layer_dict = axiom_rules.handle_axioms(
            actions, axioms, goals)
    init = init + axiom_init
    #axioms.sort(key=lambda axiom: axiom.name)
    #for axiom in axioms:
    #  axiom.dump()

    if DUMP_TASK:
        # Remove init facts that don't occur in strips_to_sas: they're constant.
        nonconstant_init = filter(strips_to_sas.get, init)
        dump_task(nonconstant_init, goals, actions, axioms, axiom_layer_dict)

    # Closed World Assumption
    false_facts = list(range(len(ranges)))
    for fact in init_unknown:
        pairs = strips_to_sas.get(fact, [])
        for pair in pairs:
            false_facts.remove(pair[0])
    facts = []
    for fact in init:
        assert fact not in init_unknown
        pairs = strips_to_sas.get(fact, [])
        for pair in pairs:
            false_facts.remove(pair[0])
        if pairs:
            facts = facts + pairs
    for var in false_facts:
        for fact in init_unknown:
            assert not var == strips_to_sas.get(fact, [])[0][0]
        facts.append((var, ranges[var] - 1))
    facts_oneof = []   
    for oneof in init_oneof:
        assert len(oneof) >= 2
        for fact in oneof:
            assert fact in init_unknown
        l = []
        for one in oneof:
            l = l + strips_to_sas.get(one, [])
        facts_oneof.append(l)

    # move to conditions.py?
    def translate_formula(formula, result, strips_to_sas, ranges, mutex_dict, mutex_ranges):
        if isinstance(formula, pddl.conditions.Atom):
            assert formula in init_unknown
            result.append(strips_to_sas.get(formula, []))
        elif isinstance(formula, pddl.conditions.NegatedAtom):
            dict_list = translate_strips_conditions([formula], strips_to_sas, ranges, mutex_dict, mutex_ranges)
            assert len(dict_list) == 1
            result.append(dict_list[0].items())
        elif isinstance(formula, pddl.conditions.Disjunction):
            result.append("or(")
            for part in formula.parts:
                translate_formula(part, result, strips_to_sas, ranges, mutex_dict, mutex_ranges)
            result.append(")")
        elif isinstance(formula, pddl.conditions.Conjunction):
            result.append("and(")
            for part in formula.parts:
                translate_formula(part, result, strips_to_sas, ranges, mutex_dict, mutex_ranges)
            result.append(")")
        else:
            assert False, print(formula)
    formulae = []
    for formula in init_formula:
        result = []
        translate_formula(formula, result, strips_to_sas, ranges, mutex_dict, mutex_ranges)
        formulae.append(result)
    init = sas_tasks.SASInit(facts, facts_oneof, formulae)

    goal_dict_list = translate_strips_conditions(goals, strips_to_sas, ranges,
                                                 mutex_dict, mutex_ranges)
    if goal_dict_list is None:
        # "None" is a signal that the goal is unreachable because it
        # violates a mutex.
        return unsolvable_sas_task("Goal violates a mutex")

    assert len(goal_dict_list) == 1, "Negative goal not supported"
    ## we could substitute the negative goal literal in
    ## normalize.substitute_complicated_goal, using an axiom. We currently
    ## don't do this, because we don't run into this assertion, if the
    ## negative goal is part of finite domain variable with only two
    ## values, which is most of the time the case, and hence refrain from
    ## introducing axioms (that are not supported by all heuristics)
    goal_pairs = list(goal_dict_list[0].items())
    goal = sas_tasks.SASGoal(goal_pairs)

    operators = translate_strips_operators(actions, strips_to_sas, ranges,
                                           mutex_dict, mutex_ranges,
                                           implied_facts)
    observation_operators = translate_strips_operators(observation_actions, 
                                                       strips_to_sas, ranges, 
                                                       mutex_dict, mutex_ranges,
                                                       implied_facts)
    axioms = translate_strips_axioms(axioms, strips_to_sas, ranges, mutex_dict,
                                     mutex_ranges)

    axiom_layers = [-1] * len(ranges)
    for atom, layer in axiom_layer_dict.items():
        assert layer >= 0
        [(var, val)] = strips_to_sas[atom]
        axiom_layers[var] = layer
    variables = sas_tasks.SASVariables(ranges, axiom_layers, translation_key)
    mutexes = [sas_tasks.SASMutexGroup(group) for group in mutex_key]
    return sas_tasks.SASTask(variables, mutexes, init, goal,
                             operators + observation_operators, 
                             axioms, metric)

def unsolvable_sas_task(msg):
    print("%s! Generating unsolvable task..." % msg)
    variables = sas_tasks.SASVariables(
        [2], [-1], [["Atom dummy(val1)", "Atom dummy(val2)"]])
    # We create no mutexes: the only possible mutex is between
    # dummy(val1) and dummy(val2), but the preprocessor would filter
    # it out anyway since it is trivial (only involves one
    # finite-domain variable).
    mutexes = []
    init = sas_tasks.SASInit([0])
    goal = sas_tasks.SASGoal([(0, 1)])
    operators = []
    axioms = []
    metric = True
    return sas_tasks.SASTask(variables, mutexes, init, goal,
                             operators, axioms, metric)


def pddl_to_sas(task):
    # for partial observability assume that unknown facts
    # are true initially (to use it in the reachability analysis)
    mod_task = deepcopy(task)
    mod_task.init = mod_task.init + mod_task.init_unknown
    
    with timers.timing("Instantiating", block=True):
        (relaxed_reachable, atoms, actions, observation_actions, axioms,
         reachable_action_params) = instantiate.explore(mod_task)
    
    if not relaxed_reachable:
        # POND we return no unsolvable task
        return


    # HACK! Goals should be treated differently.
    if isinstance(task.goal, pddl.Conjunction):
        goal_list = task.goal.parts
    else:
        goal_list = [task.goal]
    for item in goal_list:
        assert isinstance(item, pddl.Literal)

    with timers.timing("Computing fact groups", block=True):
        groups, mutex_groups, translation_key = fact_groups.compute_groups(
            mod_task, atoms, reachable_action_params,
            partial_encoding=USE_PARTIAL_ENCODING)

    with timers.timing("Building STRIPS to SAS dictionary"):
        ranges, strips_to_sas = strips_to_sas_dictionary(
            groups, assert_partial=USE_PARTIAL_ENCODING)

    with timers.timing("Building dictionary for full mutex groups"):
        mutex_ranges, mutex_dict = strips_to_sas_dictionary(
            mutex_groups, assert_partial=False)

    if ADD_IMPLIED_PRECONDITIONS:
        with timers.timing("Building implied facts dictionary..."):
            implied_facts = build_implied_facts(strips_to_sas, groups,
                                                mutex_groups)
    else:
        implied_facts = {}

    with timers.timing("Building mutex information", block=True):
        mutex_key = build_mutex_key(strips_to_sas, mutex_groups)

    with timers.timing("Translating task", block=True):
        sas_task = translate_task(
            strips_to_sas, ranges, translation_key,
            mutex_dict, mutex_ranges, mutex_key,
            task.init, task.init_unknown, task.init_oneof,
            task.init_formula, goal_list, actions, observation_actions,
            axioms, task.use_min_cost_metric, implied_facts)

    print("%d effect conditions simplified" %
          simplified_effect_condition_counter)
    print("%d implied preconditions added" %
          added_implied_precondition_counter)

    if DETECT_UNREACHABLE:
        with timers.timing("Detecting unreachable propositions", block=True):
            try:
                simplify.filter_unreachable_propositions(sas_task)
            except simplify.Impossible:
                return unsolvable_sas_task("Simplified to trivially false goal")

    return sas_task


def build_mutex_key(strips_to_sas, groups):
    group_keys = []
    for group in groups:
        group_key = []
        for fact in group:
            if strips_to_sas.get(fact):
                for var, val in strips_to_sas[fact]:
                    group_key.append((var, val))
            else:
                print("not in strips_to_sas, left out:", fact)
        group_keys.append(group_key)
    return group_keys


def build_implied_facts(strips_to_sas, groups, mutex_groups):
    ## Compute a dictionary mapping facts (FDR pairs) to lists of FDR
    ## pairs implied by that fact. In other words, in all states
    ## containing p, all pairs in implied_facts[p] must also be true.
    ##
    ## There are two simple cases where a pair p implies a pair q != p
    ## in our FDR encodings:
    ## 1. p and q encode the same fact
    ## 2. p encodes a STRIPS proposition X, q encodes a STRIPS literal
    ##    "not Y", and X and Y are mutex.
    ##
    ## The first case cannot arise when we use partial encodings, and
    ## when we use full encodings, I don't think it would give us any
    ## additional information to exploit in the operator translation,
    ## so we only use the second case.
    ##
    ## Note that for a pair q to encode a fact "not Y", Y must form a
    ## fact group of size 1. We call such propositions Y "lonely".

    ## In the first step, we compute a dictionary mapping each lonely
    ## proposition to its variable number.
    lonely_propositions = {}
    for var_no, group in enumerate(groups):
        if len(group) == 1:
            lonely_prop = group[0]
            assert strips_to_sas[lonely_prop] == [(var_no, 0)]
            lonely_propositions[lonely_prop] = var_no

    ## Then we compute implied facts as follows: for each mutex group,
    ## check if prop is lonely (then and only then "not prop" has a
    ## representation as an FDR pair). In that case, all other facts
    ## in this mutex group imply "not prop".
    implied_facts = defaultdict(list)
    for mutex_group in mutex_groups:
        for prop in mutex_group:
            prop_var = lonely_propositions.get(prop)
            if prop_var is not None:
                prop_is_false = (prop_var, 1)
                for other_prop in mutex_group:
                    if other_prop is not prop:
                        for other_fact in strips_to_sas[other_prop]:
                            implied_facts[other_fact].append(prop_is_false)

    return implied_facts


def dump_statistics(sas_task):
    if sas_task is None:
        print("No output file because task is unsolvable.")
    else:
        print("Translator variables: %d" % len(sas_task.variables.ranges))
        print(("Translator derived variables: %d" %
               len([layer for layer in sas_task.variables.axiom_layers
                    if layer >= 0])))
        print("Translator facts: %d" % sum(sas_task.variables.ranges))
        print("Translator goal facts: %d" % len(sas_task.goal.pairs))
        print("Translator mutex groups: %d" % len(sas_task.mutexes))
        print(("Translator total mutex groups size: %d" %
               sum(mutex.get_encoding_size() for mutex in sas_task.mutexes)))
        print("Translator operators: %d" % len(sas_task.operators))
        print("Translator axioms: %d" % len(sas_task.axioms))
        print("Translator task size: %d" % sas_task.get_encoding_size())
        try:
            peak_memory = tools.get_peak_memory_in_kb()
        except Warning as warning:
            print(warning)
        else:
            print("Translator peak memory: %d KB" % peak_memory)


def parse_args():
    argparser = argparse.ArgumentParser()
    argparser.add_argument(
        "domain", nargs="?", help="path to domain pddl file")
    argparser.add_argument(
        "task", help="path to task pddl file")
    argparser.add_argument(
        "--relaxed", dest="generate_relaxed_task", action="store_true",
        help="output relaxed task (no delete effects)")
    return argparser.parse_args()


def main():
    args = parse_args()

    timer = timers.Timer()
    with timers.timing("Parsing", True):
        task = pddl.open(task_filename=args.task, domain_filename=args.domain)

    with timers.timing("Normalizing task"):
        normalize.normalize(task)

    if args.generate_relaxed_task:
        # Remove delete effects.
        for action in task.actions:
            for index, effect in reversed(list(enumerate(action.effects))):
                if effect.literal.negated:
                    del action.effects[index]

    sas_task = pddl_to_sas(task)
    dump_statistics(sas_task)

    if not sas_task is None:
        with timers.timing("Writing output"):
            with open("output.sas", "w") as output_file:
                sas_task.output(output_file)
        print("Done! %s" % timer)

if __name__ == "__main__":
    main()
