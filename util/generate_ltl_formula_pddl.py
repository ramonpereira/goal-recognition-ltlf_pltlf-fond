"""
 Author: Ramon Fraga Pereira
"""

import os
import argparse

def read_generate_LTL_formula(args):
    problem = args.pddl_problem
    pddl_problem_lines = open(problem, 'r')
    ltl_formula = ''
    for line in pddl_problem_lines:
        if 'goal' in line:
            # (:goal (and (emptyhand) (on b1 b2) (on b2 b5) (ontable b3) (ontable b4) (ontable b5) (clear b1) (clear b3) (clear b4)))
            line = line.replace('(:goal (', '')
            line = line.replace('and (', '')
            line = line.replace(') (', ' & ')
            line = line.replace(')', '')
            line = line.replace(' ', '_')
            line = line.replace('_&_', ' & ')
            line = line.replace('__', '')
            line = line.replace('\n', '')
            ltl_formula = line
            ltl_formula = 'F(' + ltl_formula + ')'
            print(ltl_formula)

    ltl_formula_file_name = problem.replace('.pddl', '.formula')
    ltl_file = open(ltl_formula_file_name, 'w')
    ltl_file.write(ltl_formula)
    ltl_file.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate LTL formula from goals specified in PDDL.")

    parser.add_argument('-p', dest='pddl_problem')

    args = parser.parse_args()
    read_generate_LTL_formula(args)
