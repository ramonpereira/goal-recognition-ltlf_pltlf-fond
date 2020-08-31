"""
 Author: Ramon Fraga Pereira
"""

import os
import argparse

def convert_ltl_formula_to_PDDL_conjunctive_goal(args):
    fomula_file_r = open(args.formula_file, 'r')
    for line in fomula_file_r:
        line = line.replace('\n', '')
        line = line.replace('F(', '(and (')
        line = line.replace(' & ', ') (')
        line = line.replace('_', ' ')
        line = line + ')'

        print(line)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Convert LTLf formula (F()) to PDDL conjunctive goal.")

    parser.add_argument('-f', dest='formula_file')

    args = parser.parse_args()
    convert_ltl_formula_to_PDDL_conjunctive_goal(args)
