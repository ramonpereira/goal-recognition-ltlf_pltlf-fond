"""
 Author: Ramon Fraga Pereira

 The aim of this wrapper is to call MyND planner to plan for LTL/PLTL goals.
"""

import os
import argparse
import subprocess
import fond4ltlfpltlf.core

def plan(domain_path, problem_path, verbose=True, ltl=False, formula=''):
    """
        Planning for temporally extended goals (LTLf or PLTL).
    """
    VERBOSE = verbose
    LTL = ltl

    domain = domain_path
    problem = problem_path

    if LTL:
        in_domain = open(domain_path).read()
        in_problem = open(problem_path).read()

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

    translate_command = 'python translator-fond/translate.py ' + domain + ' ' + problem
    os.system(translate_command)
    if VERBOSE:
        """ Print the planner output. """
        planner_command = 'java -jar MyND.jar -search LAOSTAR -heuristic FF output.sas -exportPlan policy.txt -exportDot policy.dot'
        print(planner_command)
        os.system(planner_command)
    else:
        """ Omit the planner output. """
        planner_command = 'java -jar MyND.jar -search LAOSTAR -heuristic FF output.sas -exportPlan policy.txt -exportDot policy.dot >/dev/null 2>&1'
        os.system(planner_command)
    
    print('\n$> Generating graph...')
    dot_command = "dot -Tpdf policy.dot -o policy.pdf"
    os.system(dot_command)
    print('\n$> Done !')

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

    plan(domain_path, problem_path, verbose, ltl, formula)

if __name__ == '__main__':
    """
    Usage: python myND_ltl_wrapper.py -d <DOMAIN> -p <PROBLEM>

    <DOMAIN> and <PROBLEM> are the original FOND domain and problem files.

    Example Usage: python myND_ltl_wrapper.py -d domain.pddl -p p01.pddl

    - Default search engine: LAOSTAR; and
    - Default Heuristic: FF.

    The argument -ltl allows MyND planenr to plan for temporally extended goals either formalized in LTLf or PLTL.
    - This wrapper has two options for planning for temporally extended goals:

        (1) Using a file: to do so, you have to create a file in the same directory with the <PROBLEM> (e.g., pb01.pddl)
        a file containing the temporally exetended goal you want to be achieved.
        This file must have the same name as the <PROBLEM> file with the extension .formula, for instance pb01.formula,
        in case the name of the <PROBLEM> file is pb01.pddl.

        (2) Using the parameter -formula:
        For example: -formula '(vehicleat_l15)'
    """
    parser = argparse.ArgumentParser(description="Wrapper to use MyND Planner.")

    parser.add_argument('-d', dest='domain_path', default='../../recognition/example/domain.pddl')
    parser.add_argument('-p', dest='problem_path', default='../../recognition/example/p01.pddl')
    parser.add_argument('-verbose', dest='verbose', type=_str2bool, const=True, nargs='?', default=True)
    parser.add_argument('-ltl', dest='ltl', type=_str2bool, const=True, nargs='?', default=False)
    parser.add_argument('-formula', dest='formula', default='')

    args = parser.parse_args()
    main(args)
