"""
 Author: Ramon Fraga Pereira
"""

import os
import argparse
import recognizer


def run_experiments(domain_name, formula, observability):
    observabilities = []
    if 'all' in observability:
        observabilities = ['10', '30', '50', '70', '100']
        # observabilities = ['10', '25', '30', '50', '70', '75', '100']
    else:
        observabilities = [observability]

    results_computed = []
    results_path = '../fond-recognition-benchmarks/results/' + domain_name + '/' + formula
    for result_file in os.listdir(results_path):
        result = result_file.replace('.json', '')
        results_computed.append(result)

    experiments_path = '../fond-recognition-benchmarks/domains/' + domain_name + '/' + formula
    for obs in observabilities:
        experiments_path_obs = experiments_path + '/' + obs
        for filename in os.listdir(experiments_path_obs):
            if filename.replace('.tar.bz2', '') in results_computed:
                continue
            full_dir_filename = experiments_path_obs + '/' + filename
            ltl = True
            if 'conjunctive' in formula:
                ltl = False
            recognizer.recognize(full_dir_filename, ltl, True)
            os.system('mv *.json ../fond-recognition-benchmarks/results/' + domain_name + '/' + formula)

def main(args):
    domain_name = args.domain_name
    formula = args.formula
    observability = args.observability

    run_experiments(domain_name, formula, observability)

if __name__ == '__main__':
    """
    Usage: python run_experiments_recognizer.py -d <DOMAIN_NAME> -obs <OBSERVABILITY>
    """
    parser = argparse.ArgumentParser(description="Goal Recognition in FOND Domain Models with LTLf/PLTL Goals")

    parser.add_argument('-d', dest='domain_name', default='triangle-tireworld')
    parser.add_argument('-f', dest='formula', default='conjunctive')
    parser.add_argument('-obs', dest='observability', default='all')

    args = parser.parse_args()
    main(args)
