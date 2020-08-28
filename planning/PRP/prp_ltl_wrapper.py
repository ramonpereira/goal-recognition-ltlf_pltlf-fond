"""
 Author: Ramon Fraga Pereira

 The aim of this wrapper is to call PRP planner to plan and generate some data structures from the extracted policy.
 For example, a directed graph representing the policy,
 and all valid paths (plans) to achieve the goal state (G) from the initial state (s0).
"""

import os
import argparse
import translator.translate_policy as translator
import translator.translate_policy_ltl as translator_ltl
import validator
import fond4ltlfpltlf.core


def plan(domain_path, problem_path, verbose=True, ltl=False, formula='', graph=False, plans=False):
    """
        Planning for conjunctive goals and temporally extended goals (LTLf or PLTL).
    """
    """ Removing temporary files. """
    os.system('rm -rf graph.dot *.out *.fsap plan_numbers_and_cost sas_plan elapsed.time output *.sas')

    original_domain = domain_path
    original_problem = problem_path
    VERBOSE = verbose
    LTL = ltl
    GRAPH = graph
    PLANS = plans

    domain = original_domain
    problem = original_problem

    if LTL:
        in_domain = open(domain).read()
        in_problem = open(problem).read()

        ltl_formula = ''
        if formula != '':
            ltl_formula = formula
        else:
            ltl_formula = open(problem.replace('.pddl', '.formula')).read()

        print('\n$> LTLf/PLTL Formula: ')
        print(ltl_formula)

        domain_prime, problem_prime = fond4ltlfpltlf.core.execute(in_domain, in_problem, ltl_formula)
        domain_prime_path, problem_prime_path = generate_domain_problem_files_ltl(domain_prime, problem_prime, domain, problem)

        domain = domain_prime_path
        problem = problem_prime_path

    if VERBOSE:
        """ Print the planner output. """
        prp_planner_command = '../planning/PRP/./prp ' + domain + ' ' + problem + ' --dump-policy 2'
        os.system(prp_planner_command)
    else:
        """ Omit the planner output. """
        prp_planner_command = '../planning/PRP/./prp ' + domain + ' ' + problem + ' --dump-policy 2 >/dev/null 2>&1'
        os.system(prp_planner_command)

    # # """ Translate the policy from SAS+ to instantiated standard facts. """
    translator.translate('policy.out', 'policy-translated.out')

    if LTL:
        os.system('cp policy-translated.out policy-with-trans.out')
        translator_ltl.process_policy('policy-translated.out')
        """ TO-DO: Improve this part. """
        os.system('mv new-policy.out policy-translated.out')

        conjuctive_goal = _get_goal()
        _create_problem_with_goal(original_problem, conjuctive_goal)
        original_problem = 'problem.pddl'

    """ Validade the policy (from the initial state to the goal state) and generate the data structure. """
    G = None
    if GRAPH:
        print('\n$> Loading policy and generating the graph ...')
        G = validator.validate_and_generate_graph(original_domain, original_problem, 'policy-translated.out', 'prp')
        validator.generate_dot_graph(G)
        
        print('\n$> Generating graph...')
        dot_command = "dot -Tpdf graph.dot -o graph.pdf"
        os.system(dot_command)
        print('\n$> Done !')

    if PLANS:
        extract_plans_from_graph(G)

    print()

def extract_plans_from_graph(G, verbose=True):
    if verbose:
        print('\n$> Extracting all possible plans from the graph (policy) ... \n')

    # all_shortest_plans = validator.extract_all_shortest_plans(G)

    all_plans, set_actions = validator.extract_all_plans(G)
    if verbose:
        index = 0
        for plan in all_plans:
            print('\t- Plan [' + str(index) + ']:' + str(plan))
            index += 1

    actions_distance_to_goal = dict()
    for plan in all_plans:
        for a in set_actions:
            if a in plan:
                if a in actions_distance_to_goal.keys():
                    distances = actions_distance_to_goal[a]
                    distances.append(len(plan)-1 - plan.index(a))
                    actions_distance_to_goal[a] = distances
                else:
                    actions_distance_to_goal[a] = [len(plan)-1 - plan.index(a)]

    actions_avg_distance_to_goal = dict()
    for k in actions_distance_to_goal.keys():
        distances = actions_distance_to_goal[k]
        sum_distances = sum(distances)
        actions_avg_distance_to_goal[k] = float(sum_distances/len(distances))

    if verbose:
        print('\n\t- Average distance of the actions in the policy to the goal state: ')
        print('\t' + str(actions_avg_distance_to_goal))

    return all_plans, actions_avg_distance_to_goal

def generate_domain_problem_files_ltl(domain_prime, problem_prime, domain, problem):
    pb = problem.split('/')
    pb_number = pb[len(pb)-1]
    pb_number = pb_number.split('.')[0]
    domain_prime_path = domain.replace('.pddl', '_' + pb_number + '_prime.pddl')

    prime_domain_file_writer = open(domain_prime_path, "w")
    prime_domain_file_writer.write(str(domain_prime))
    prime_domain_file_writer.close()

    problem_prime_path = problem.replace('.pddl', '_prime.pddl')
    prime_problem_file_writer = open(problem_prime_path, "w")
    prime_problem_file_writer.write(str(problem_prime))
    prime_problem_file_writer.close()

    return domain_prime_path, problem_prime_path

def _get_goal():
    policy_file = open('policy-translated.out', "r")
    lines = policy_file.readlines()
    prevLine = ''
    goal = ''
    for line in lines:
        if('goal' in line):
            goal = prevLine.replace('If holds: ', '')
            goal = goal.replace('(', ' ')
            goal = goal.replace(',', ' ')
            goal = goal.replace(')/', ') (')
            goal = '(' + goal
            break
        prevLine = line

    return goal

def _create_problem_with_goal(original_problem, goal):
    content = ''
    with open(original_problem) as initial_state:
        content = initial_state.read()

    content = content.replace('(goal_state)', goal)

    with open('problem.pddl', 'w') as problem:
        problem.write(content)

def _str2bool(v):
    if isinstance(v, bool):
       return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

def main(args):
    domain_path = args.domain_path
    problem_path = args.problem_path
    verbose = args.verbose
    ltl = args.ltl
    formula = args.formula
    graph = args.graph
    plans = args.plans

    plan(domain_path, problem_path, verbose, ltl, formula, graph, plans)

if __name__ == '__main__':
    """
    Usage: python prp_wrapper.py -d <DOMAIN> -p <PROBLEM>

    <DOMAIN> and <PROBLEM> are the original FOND domain and problem files.

    Example Usage: python prp_ltl_wrapper.py -d domain.pddl -p p01.pddl

    The argument -ltl allows PRP planner to plan for temporally extended goals either formalized in LTLf or PLTL.
    - For planning for temporally extended goals, there are two options:
        (1) In the same directory with the <PROBLEM> (e.g., pb01.pddl) you have to create
        a file containing the temporally exetended goal you want to be achieved.
        This file must have the same name as the <PROBLEM> file, for instance pb01.formula,
        in case the name of the <PROBLEM> file is pb01.pddl.
        (2) Using the parameter -formula.
        For example: -formula '(vehicleat_l15)'
    """
    parser = argparse.ArgumentParser(description="Wrapper to use PRP Planner.")

    parser.add_argument('-d', dest='domain_path', default='example/domain.pddl')
    parser.add_argument('-p', dest='problem_path', default='example/p01.pddl')
    parser.add_argument('-verbose', dest='verbose', type=_str2bool, const=True, nargs='?', default=True)
    parser.add_argument('-ltl', dest='ltl', type=_str2bool, const=True, nargs='?', default=False)
    parser.add_argument('-formula', dest='formula', default='')
    parser.add_argument('-graph', dest='graph', type=_str2bool, const=True, nargs='?', default=False)
    parser.add_argument('-plans', dest='plans', type=_str2bool, const=True, nargs='?', default=False)

    args = parser.parse_args()
    main(args)
