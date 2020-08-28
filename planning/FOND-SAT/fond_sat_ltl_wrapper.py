"""
 Author: Ramon Fraga Pereira

 The aim of this wrapper is to call FOND-SAT planner to plan for LTL/PLTL goals.
"""

import os
import argparse
import copy
import fond4ltlfpltlf.core

from file_read_backwards import FileReadBackwards
from pydot import Dot, Edge, Node

class Triplet:

    def __init__(self, source, action, destination):
        self.source = source
        self.action = action
        self.destination = destination


    def __str__(self):
        return '({0} {1} {2})'.format(self.source, self.action, self.destination)


def plan(domain_path, problem_path, verbose=True, ltl=False, formula=''):
    """
        Planning for temporally extended goals (LTLf or PLTLf).
    """
    """ Removing temporary files. """
    os.system('rm -rf formula-extra-temp.txt formula-temp.txt plan_*.txt graph-policy.pdf')

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

        print('\n$> LTLf/PLTLf Formula: ')
        print(ltl_formula)

        domain_prime, problem_prime = fond4ltlfpltlf.core.execute(in_domain, in_problem, ltl_formula)
        domain_prime_path, problem_prime_path = generate_domain_problem_files_ltl(domain_prime, problem_prime, domain, problem)

        domain = domain_prime_path
        problem = problem_prime_path

    if VERBOSE:
        """ Print the planner output. """
        planner_command = 'python main.py {} {} -strong 1 -policy 1 | tee plan_.txt'.format(domain, problem)
        os.system(planner_command)
    else:
        """ Omit the planner output. """
        planner_command = 'python main.py {} {} -strong 1 -policy 1 >/dev/null 2>&1'.format(domain, problem)
        os.system(planner_command)
        
    print('\n$> Generating graph out of the plan... ')
    generate_graph("plan_.txt".format(str(ltl_formula)), False)
    print('\n$> Done ! ')    
        
        
def generate_graph(file_path, no_trans=False):
    """Generate the graph out of the policy."""
    #assert os.path.isfile("plan_{}.txt".format(formula))
    with FileReadBackwards(file_path, encoding="utf-8") as frb:
        # getting lines by lines starting from the last line up
        lines = []
        for line in frb:
            lines.append(line)

        _interesting = []
        csActionArg = {}
        csActioncs = []
        count = 0
        for i in reversed(lines):
            if count > 5 and count < 9:
                # print(i)
                _interesting.append(i)
            if i == '===================':
                count += 1

    interesting = _interesting[2:]
    i = 0
    pos = 0
    while interesting[i] != '===================':
        temp = interesting[i][1:-1]
        if '(' in temp:
            _temp = temp.split(',', 1)
            if _temp[0] in csActionArg.keys():
                csActionArg[_temp[0]].append(_temp[1])
            else:
                csActionArg[_temp[0]] = [_temp[1]]
        i += 1
        pos = i

    interesting2 = interesting[pos + 4:]
    i = 0
    while interesting2[i] != '===================':
        s, a, d = interesting2[i][1:-1].split(',')
        actions_with_args = csActionArg[s]
        for act in actions_with_args:
            if a in act:
                csActioncs.append(Triplet(s, act, d))
        i += 1

    # deleting trans and mapping nodes
    new_final = str()
    if no_trans:
        mapping = {}
        for triple in copy.copy(csActioncs):
            if 'trans' in triple.action:
                mapping[triple.destination] = triple.source
                csActioncs.remove(triple)
                if triple.destination == 'ng':
                    new_final = triple.source

        for triple in csActioncs:
            if triple.source in mapping.keys():
                triple.source = mapping[triple.source]

    # creating the digraph
    g = Dot(graph_type='digraph', graph_name='policiesTS', center='true', size='7.5,7.5')
    g.set_edge_defaults(fontname='Courier')
    g.set_node_defaults(height=0.5, width=0.5)
    g.set_node_defaults(shape='doublecircle')
    if not no_trans:
        g.add_node(Node('ng'))
    else:
        g.add_node(Node(new_final))
    g.set_node_defaults(shape='circle')
    if not no_trans:
        for key in csActionArg.keys():
            if key != 'ng':
                g.add_node(Node(str(key)))
    else:
        pass
    g.add_node(Node('init', shape='plaintext', label=''))
    g.add_edge(Edge('init', 'n0'))
    for triple in csActioncs:
        g.add_edge(Edge(triple.source, triple.destination, label=triple.action))

    g.write('graph-policy.pdf', format='pdf')


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
    Usage: python fond-sat_wrapper.py -d <DOMAIN> -p <PROBLEM>

    <DOMAIN> and <PROBLEM> are the original FOND domain and problem files.

    Example Usage: python fond_sat_ltl_wrapper.py -d domain.pddl -p p01.pddl

    The argument -ltl allows FOND-SAT planner to plan for temporally extended goals either formalized in LTLf or PLTL.
    - This wrapper has two options for planning for temporally extended goals:

        (1) Using a file: to do so, you have to create a file in the same directory with the <PROBLEM> (e.g., pb01.pddl)
        a file containing the temporally exetended goal you want to be achieved.
        This file must have the same name as the <PROBLEM> file with the extension .formula, for instance pb01.formula,
        in case the name of the <PROBLEM> file is pb01.pddl.

        (2) Using the parameter -formula:
        For example: -formula '(vehicleat_l15)'
    """
    parser = argparse.ArgumentParser(description="Wrapper to use FOND-SAT Planner.")

    parser.add_argument('-d', dest='domain_path', default='../../recognition/example/domain.pddl')
    parser.add_argument('-p', dest='problem_path', default='../../recognition/example/p01.pddl')
    parser.add_argument('-verbose', dest='verbose', type=_str2bool, const=True, nargs='?', default=True)
    parser.add_argument('-ltl', dest='ltl', type=_str2bool, const=True, nargs='?', default=False)
    parser.add_argument('-formula', dest='formula', default='')

    args = parser.parse_args()
    main(args)
