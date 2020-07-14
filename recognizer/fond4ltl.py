import os, sys
import fond4ltlfpltlf.core
from fond4ltlfpltlf.automa.symbol import Symbol

def translate(domain, problem):
    formula_1 = "F(vehicleat_l22)"
    # vehicle-at l-1-3
    in_domain = open(domain).read()
    in_problem = open(problem).read()

    domain_prime, problem_prime = fond4ltlfpltlf.core.execute(in_domain, in_problem, formula_1)
    print(domain_prime)
    print(problem_prime)

if __name__ == '__main__':
    try:
        (domain, problem) = os.sys.argv[1:]
    except:
        print("\nWrong input.")
        os.sys.exit(1)

    translate(domain, problem)
