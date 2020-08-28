#! /usr/bin/env python

from __future__ import print_function

from collections import defaultdict

import build_model
import pddl_to_prolog
import pddl
import timers

def get_fluent_facts(task, model):
    fluent_predicates = set()
    for action in task.actions:
        for nondet_choice in action.effects:
            for effect in nondet_choice:
                fluent_predicates.add(effect.literal.predicate)
    for axiom in task.axioms:
        fluent_predicates.add(axiom.name)
    return set([fact for fact in model
                if fact.predicate in fluent_predicates])

def get_objects_by_type(typed_objects, types):
    result = defaultdict(list)
    supertypes = {}
    for type in types:
        supertypes[type.name] = type.supertype_names
    for obj in typed_objects:
        result[obj.type].append(obj.name)
        for type in supertypes[obj.type]:
            result[type].append(obj.name)
    return result

# POND: mod_task
def instantiate(mod_task, model):
    relaxed_reachable = False
    fluent_facts = get_fluent_facts(mod_task, model)
    init_facts = set(mod_task.init)
    unknown_facts = set(mod_task.init_unknown)
    type_to_objects = get_objects_by_type(mod_task.objects, mod_task.types)

    instantiated_actions = []
    instantiated_observation_actions = []
    instantiated_axioms = []
    reachable_action_parameters = defaultdict(list)
    for atom in model:
        if isinstance(atom.predicate, pddl.Action):
            action = atom.predicate
            parameters = action.parameters
            inst_parameters = atom.args[:len(parameters)]
            # Note: It's important that we use the action object
            # itself as the key in reachable_action_parameters (rather
            # than action.name) since we can have multiple different
            # actions with the same name after normalization, and we
            # want to distinguish their instantiations.
            reachable_action_parameters[action].append(inst_parameters)
            variable_mapping = dict([(par.name, arg)
                                     for par, arg in zip(parameters, atom.args)])
            inst_action = action.instantiate(variable_mapping, init_facts,
                                             fluent_facts, unknown_facts, type_to_objects)
            if inst_action and action.observation is None:
                instantiated_actions.extend(inst_action)
            elif inst_action and action.observation is not None:
                instantiated_observation_actions.extend(inst_action)
        elif isinstance(atom.predicate, pddl.Axiom):
            axiom = atom.predicate
            variable_mapping = dict([(par.name, arg)
                                     for par, arg in zip(axiom.parameters, atom.args)])
            inst_axiom = axiom.instantiate(variable_mapping, init_facts, fluent_facts, unknown_facts)
            if inst_axiom:
                instantiated_axioms.append(inst_axiom)
        elif atom.predicate == "@goal-reachable":
            relaxed_reachable = True

    return (relaxed_reachable, fluent_facts | unknown_facts, instantiated_actions, instantiated_observation_actions,
           sorted(instantiated_axioms), reachable_action_parameters)

def explore(mod_task):
    prog = pddl_to_prolog.translate(mod_task)
    model = build_model.compute_model(prog)
    with timers.timing("Completing instantiation"):
        return instantiate(mod_task, model)

if __name__ == "__main__":
    task = pddl.open()
    relaxed_reachable, atoms, actions, axioms, _ = explore(task)
    print("goal relaxed reachable: %s" % relaxed_reachable)
    print("%d atoms:" % len(atoms))
    for atom in atoms:
        print(" ", atom)
    print()
    print("%d actions:" % len(actions))
    for action in actions:
        action.dump()
        print()
    print()
    print("%d axioms:" % len(axioms))
    for axiom in axioms:
        axiom.dump()
        print()
