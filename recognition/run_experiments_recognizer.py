"""
 Author: Ramon Fraga Pereira
"""

import os
import argparse
import recognizer


def run_experiments(domain_name, observability):
    observabilities = []
    if 'all' in observability:
        observabilities = ['10', '25', '30', '50', '70', '75', '100']
    else:
        observabilities = [observability]

    experiments_path = '../fond-recognition-benchmarks/' + domain_name
    for obs in observabilities:
        experiments_path_obs = experiments_path + '/' + obs
        for filename in os.listdir(experiments_path_obs):
            full_dir_filename = experiments_path_obs + '/' + filename
            recognizer.recognize(full_dir_filename)

def main(args):
    domain_name = args.domain_name
    observability = args.observability

    run_experiments(domain_name, observability)

if __name__ == '__main__':
    """
    Usage: python run_experiments_recognizer.py -d <DOMAIN_NAME> -obs <OBSERVABILITY>
    """
    parser = argparse.ArgumentParser(description="Goal Recognition in FOND Domain Models with LTLf/PLTL Goals")

    parser.add_argument('-d', dest='domain_name', default='triangle-tireworld')
    parser.add_argument('-obs', dest='observability', default='all')

    args = parser.parse_args()
    main(args)
