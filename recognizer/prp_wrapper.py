"""
 Author: Ramon Fraga Pereira
 
 The aim of this wrapper is to call PRP planner and generate some data structures from the extracted policy.
 For example, a directed graph representing the policy, 
 and all valid paths (plans) to achieve the goal state (G) from the initial state (s0).
"""

import os, sys
import argparse
import translator.translate_policy as translator
import validator

def remove_trans_actions(policy_translated):
    lines = open(policy_translated, 'r').readlines()
    found_trans = []
    for i, line in enumerate(lines):
        if 'trans' in line:
            found_trans.append(i)

    print found_trans

def main(args):
    domain = args.domain_path
    problem = args.problem_path

    """ Print the planner output. """
    # prp_planner_command = '../planning/PRP/./prp ' + domain + ' ' + problem + ' --dump-policy 2'
    # os.system(prp_planner_command)
    
    """ Omit the planner output. """
    prp_planner_command = '../planning/PRP/./prp ' + domain + ' ' + problem + ' --dump-policy 2 >/dev/null 2>&1'
    os.system(prp_planner_command)

    """ Translate the policy from SAS+ to instantiated standard facts. """
    translator.translate('policy.out', 'policy-translated.out')
    remove_trans_actions('policy-translated.out')

    """ Validade the policy (from the initial state to the goal state) and generate the data structure. """
    validator.validate_and_generate_graph(domain, problem, 'policy-translated.out', 'prp')

if __name__ == '__main__':
    """
    Usage: python prp_wrapper.py -d <DOMAIN> -p <PROBLEM>

    <DOMAIN> and <PROBLEM> are the original FOND domain and problem files.

    Example Usage: python prp_wrapper.py -d domain.pddl -p p01.pddl
    """ 
    parser = argparse.ArgumentParser(description="Wrapper to use PRP Planner.")
    
    parser.add_argument('-d', dest='domain_path', default='example/domain.pddl')
    parser.add_argument('-p', dest='problem_path', default='example/p01.pddl')

    args = parser.parse_args()
    main(args)
