"""
 Author: Ramon Fraga Pereira
"""

import sys
# insert at 1, 0 is the script path (or '' in REPL)
sys.path.append('../planning/PRP')

import os
import argparse
import json
import math
import time
import numpy as np
import prp_ltl_wrapper as prp_planner
import validator


def recognize(recognition_problem_path, ltl=True, verbose=True):
    """ Removing temporary files. """
    start_time = time.time()
    os.system('rm -rf graph.dot *.out *.fsap plan_numbers_and_cost sas_plan elapsed.time output *.sas *.pddl *.dat')
    print('\n@@@> Starting Recognition Process: \n')
    print('  Problem file: ' + recognition_problem_path)
    os.system('tar -xf ' + recognition_problem_path)

    trace = {}
    trace['problem'] = os.path.split(os.path.basename(recognition_problem_path).replace('.tar.bz2', ''))[-1]
    trace['domain'] = trace['problem'].split('_')[0]
    trace['observability'] = open('observability.dat', "r").readlines()[0]

    goals_file = open('hyps.dat', "r")
    obs_file = open('obs.dat', "r")
    correct_goal_file = open('real_hyp.dat', "r")

    possible_goals = []
    for g in goals_file:
        possible_goals.append(g.replace('\n', ''))

    observations = []
    for o in obs_file:
        observations.append(o.replace('\n', ''))

    correct_goal = correct_goal_file.readlines()[0].replace('\n', '')

    goals_file.close()
    obs_file.close()
    correct_goal_file.close()
    goal_plans = dict()
    goal_all_plans = dict()

    trace['G'] = possible_goals
    trace['G*'] = correct_goal
    trace['Obs'] = [o for o in observations]

    print('\n> STEP 1: Planning for getting the policies for the possible goals: ')
    for goal in possible_goals:
        print('\n\t### Goal: ' + goal)
        if ltl:
            prp_planner.plan('domain.pddl', 'initial_state.pddl', False, ltl, goal)
            conjuctive_goal = _get_goal()
            _create_problem_with_goal(conjuctive_goal)
        else:
            _create_problem_with_goal(goal)
            prp_planner.plan('domain.pddl', 'problem.pddl', False)

        G = validator.validate_and_generate_graph('domain.pddl', 'problem.pddl', 'policy-translated.out', 'prp')
        all_plans, actions_avg_distance_to_goal = prp_planner.extract_plans_from_graph(G, False)
        goal_plans[goal] = actions_avg_distance_to_goal
        goal_all_plans[goal] = all_plans

    print('> STEP 2: Computing achieved observations for the goals ... \n')
    goals_achieved_observations_dist = dict()
    goals_achieved_observations = dict()
    for i, obs in enumerate(observations):
        print('- Obs (' + str(i) + '): ' + obs)

    print()
    for goal in possible_goals:
        achieved_obs_dist = []
        achieved_obs =[]
        for obs in observations:
            """ TO-DO: We need to think about it, sys.max is affecting
            the computation of the posterior probabilities."""
            """ I think that the use of the Euler constant e seems
            a good alternative."""
            obs_dist_g = math.e ** 5
            plan_actions_dist = goal_plans[goal]
            if obs in list(plan_actions_dist.keys()):
                obs_dist_g = plan_actions_dist[obs]
                achieved_obs.append(obs)

            achieved_obs_dist.append(obs_dist_g)

        goals_achieved_observations_dist[goal] = achieved_obs_dist
        goals_achieved_observations[goal] = achieved_obs

    print('\t #> Achieved observations for the goals: ')
    for goal in possible_goals:
        print('\t ### Goal: ' + goal + ' \n\t\t = ' + str(goals_achieved_observations[goal]))

    print('\n> STEP 3: Computing probabilities for the goals:')
    """
    Compute scores for the goals.
    """
    posterior_probs = dict()
    trace['P(Obs | G)'] = []
    for i in range(0, len(observations)):
        # posterior = 0
        prob_O_G_i = []
        for goal in goals_achieved_observations_dist.keys():
            obs_dist_goal = goals_achieved_observations_dist[goal][i]
            sum_dist_other_goals = 0
            for goal_prime in goals_achieved_observations_dist.keys():
                if goal != goal_prime:
                    sum_dist_other_goals += goals_achieved_observations_dist[goal_prime][i]

            penalty_value = 0
            if i > 0:
                penalty_value = _compute_penalty_value(goal_all_plans[goal], observations[i-1], observations[i])

            penalty = math.e ** penalty_value
            score = float((penalty*obs_dist_goal)/sum_dist_other_goals)
            """
            Compute P(Obs | G) for the goals.
            """
            h = float(1 / (1 + score))
            prob_O_G_i += [float(h)]
            total_posterior = (h / len(possible_goals))
            posterior_probs[goal] = total_posterior
        trace['P(Obs | G)'] += [prob_O_G_i]

    """
    Compute P(G | Obs) for the goals.
    """
    normalization_factor = np.full(len(possible_goals), 1/len(possible_goals))
    highest_prob_G = 0
    prob_all_goals = dict()
    for goal in possible_goals:
        prob_G = _compute_posterior(goal, posterior_probs, normalization_factor)
        print('\n\t###> Goal: ' + goal)
        print('\n\t  P(G | Obs) = ' + str(prob_G))
        prob_all_goals[goal] = prob_G
        if prob_G > highest_prob_G:
            highest_prob_G = prob_G

    for goal in possible_goals:
        if highest_prob_G == prob_all_goals[goal] and goal == correct_goal:
            print('\n> The correct goal [' + goal + '] has the highest posterior probability (' + str(prob_all_goals[goal]) + ') among all goals.')
            break

    recognition_time = (time.time() - start_time)
    print("> Total time: %s seconds" % recognition_time)
    trace['time'] = recognition_time

    """ Generating a JSON file containing the probabilities for the goals for each observation step.
        This allows us to recognizing goals in two settings: online (step-by-step) and offline (all steps).
    """
    with open('{}.json'.format(trace['problem']), 'w') as output:
        json.dump(trace, output, indent=True, sort_keys=True)

    print()

def _compute_penalty_value(all_plans, obs_prev, obs):
    penalty_value = 3

    ordering_okay = False
    for plan in all_plans:
        if obs in plan and obs_prev in plan:
            i = plan.index(obs)
            i_prev = plan.index(obs_prev)
            if i_prev < i:
                ordering_okay = True
            else:
                return penalty_value

    if ordering_okay:
        penalty_value = 0

    return penalty_value

def _compute_posterior(goal, posterior_probs, normalization_factor):
    num = posterior_probs[goal] * normalization_factor[0]
    denom = np.sum(list(posterior_probs.values()) * normalization_factor)
    return num / denom

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

def _create_problem_with_goal(goal):
    content = ''
    with open('initial_state.pddl') as initial_state:
        content = initial_state.read()
    goal = goal.replace('(and ', '')
    goal = goal.replace('))', ')')
    content = content.replace('(goal_state)', goal.replace('(and ', ''))

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
    problem_path = args.problem_path
    ltl = args.ltl
    verbose = args.verbose

    recognize(problem_path, ltl, verbose)

if __name__ == '__main__':
    """
    Usage: python recognizer.py -p <RECOGNITION_PROBLEM>

    <RECOGNITION_PROBLEM> is a file that contains:
    - a FOND domain model (domain.pddl);
    - an initial state (template.pddl);
    - a set of possible goals (hyps.dat);
    - the correct intended goal (real_hyp.dat);
    - a sequences of observations (obs.dat);
    """
    parser = argparse.ArgumentParser(description="Goal Recognition in FOND Domain Models with LTLf/PLTL Goals")

    parser.add_argument('-p', dest='problem_path', default='example/triangle-tireworld_p01_hyp-1-example.tar.bz2')
    parser.add_argument('-ltl', dest='ltl', type=_str2bool, const=True, nargs='?', default=True)
    parser.add_argument('-verbose', dest='verbose', type=_str2bool, const=True, nargs='?', default=True)

    args = parser.parse_args()
    main(args)
