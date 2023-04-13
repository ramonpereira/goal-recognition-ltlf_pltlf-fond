"""
 Author: Ramon Fraga Pereira
"""

import os
import sys
import pandas as pd
import glob
import json
import numpy as np
import itertools

BASE_DIR = '../fond-recognition-benchmarks'
RESULTS_DIR = os.path.join(BASE_DIR, 'results/')

def compute_posterior(index, prob, priors):
    num = prob[index] * priors[index]
    denom = np.sum(prob*priors)
    return num / denom

def compute_rank(probs, true_goal):
    max_value = max(probs)
    if max_value == true_goal:
        return 1
    
    list_probs = probs
    list_probs.sort(reverse=True)
    return list_probs.index(true_goal)+1

def generate_ranking(domain, type_goal):    
    for p_number in range(1, 3):
        for prob_num in range(1, 4):
            json_files = []
            # print('/' + domain + '/' + type_goal + '/' + '*p0' + str(p_number) + '_*-' + str(prob_num) + '*full.json')
            files = glob.glob(os.path.join(RESULTS_DIR + '/' + domain + '/' + type_goal + '/' + '*p0' + str(p_number) + '_*-' + str(prob_num) + '*full.json'))
            for f in files:
                json_files.append(f)

            print("Results found:", len(json_files))

            print(json_files[0])
            print(os.path.basename(json_files[0]))
            filename, ext = os.path.basename(json_files[0]).split('.')

            tokens = filename.split('_')

            dataset = {
            'domain' : [],\
            'problem' : [],\
            'observability' : [],\
            'goals' : [],\
            'judge_point' : [],\
            'obs_len' : [],\
            'true_goal': [],\
            'time': [],\
            'posterior': []}

            sum_obs_dict = dict()
            problems_obs_dict = dict()

            sum_goals = 0

            for pathname in json_files:
                filename, ext = os.path.basename(pathname).split('.')
                tokens = filename.split('_')
                approach = tokens[0]
                model_type = tokens[-1]
                data = {}
                with open(pathname) as instream:
                    buffer = instream.read()
                    data = json.loads(buffer)

                #print(approach, model_type, data['domain'], data['problem'], data['observability'])
                
                num_goals = len(data["G"])
                true_goal = data["G"].index(data['G*'])
                likelihoods = data['P(Obs | G)']
                sum_goals += num_goals
                
                if data['observability'] in sum_obs_dict:
                    problems_obs_dict[data['observability']] += 1
                    sum_obs_dict[data['observability']] += len(data['Obs'])
                else:
                    problems_obs_dict[data['observability']] = 1
                    sum_obs_dict[data['observability']] = len(data['Obs'])
                
                for k, prob_O_G in enumerate(likelihoods):
                    post_probs = [compute_posterior(j, prob_O_G, np.ones(num_goals)/num_goals) \
                                 for j in range(len(data['G']))]
                    dataset['domain'] += [data['domain']]
                    dataset['problem'] += [data['problem']]
                    dataset['goals'] += [num_goals]
                    dataset['judge_point'] += [k]
                    dataset['obs_len'] += [len(data['Obs'])]
                    dataset['true_goal'] += [true_goal]
                    dataset['observability'] += [data['observability']]
                    dataset['time'] += [data['time']]
                    dataset['posterior'] += [np.array(post_probs)]

                avg_obs = 0.0
                sum_obs = 0.0
                avg_obs_observability = dict()
                for k in sum_obs_dict.keys():
                    avg = sum_obs_dict[k] / problems_obs_dict[k]
                    avg_obs_observability[k] = avg
                    sum_obs += avg
                    
                avg_obs = sum_obs / len(sum_obs_dict)
                avg_goals = sum_goals/len(json_files)

            dataset = pd.DataFrame(dataset)
            print(dataset['posterior'])
            print()

            file_content = ''
            for i in range(0,len(dataset['posterior'])):
                probs_dataset = dataset['posterior'][i]
                true_goal_value = probs_dataset[true_goal]
                probs_dataset_copy = probs_dataset
                probs_list = probs_dataset_copy.tolist()
                probs_list.index(true_goal_value)
                rank = compute_rank(probs_list, true_goal_value)
                obs_index_rank = str(i) + '\t' + str(rank)
                file_content += obs_index_rank + '\n'
                print(obs_index_rank)

            print(os.path.basename(json_files[0]).replace('json', 'txt'))
            with open(os.path.basename(json_files[0]).replace('json', 'txt'), 'w') as f:
                f.write(file_content)

if __name__ == '__main__':
    # domain = 'blocksworld'
    # domain = 'logistics'
    # domain = 'tidyup'
    # domain = 'tireworld'
    # domain = 'triangle-tireworld'
    domain = 'zenotravel'
    
    # type_goal = 'ltl_eventuality'
    # type_goal = 'ltl_ordering'
    # type_goal = 'ltl_until'
    # type_goal = 'pltl_once'
    type_goal = 'pltl_since'

    generate_ranking(domain, type_goal)
