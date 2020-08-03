#!/usr/bin/python
import sys
import os
import math
from decimal import *
from random import randint
from operator import itemgetter

def main() :
	domainName = sys.argv[1]
	numberOfProblems = sys.argv[2]
	hypothesis = sys.argv[3]

	for problemNumber in range(1, int(numberOfProblems)+1):
		# Creating a PDDL problem template according to the defined problem number		
		problemTemplate = open('template.pddl', 'w')
		planningProblemNumber = open('pb' + str(problemNumber) + '.pddl')
		for line in planningProblemNumber:
			problemTemplate.write(line)

		problemTemplate.close()

		# Creating file with the hypothesis candidate goals according to the defined problem number
		problemHypothesisGoals = open('pb' + str(problemNumber) +'_hyps_goals.dat')
		hypothesisGoals = open('hyps.dat', 'w')
		for line in problemHypothesisGoals:
			hypothesisGoals.write(line)

		hypothesisGoals.close()

		# Generating observations according to the goal hypothesis (number) and its associated plan
		for hypNumber in range(1, int(hypothesis)+1):
			goalHypothesis = open('pb' + str(problemNumber) + '_hyp' + str(hypNumber) + '.goal')
			goalHyp = goalHypothesis.readline()
			realGoalHypothesis = open('real_hyp.dat', 'w')
			realGoalHypothesis.write(goalHyp)
			realGoalHypothesis.close()

			goalHypothesisFullPlan = open('pb' + str(problemNumber) + '_hyp' + str(hypNumber) + '.plan')
			goalPlan = list(goalHypothesisFullPlan)

			# Observations varying in 10%, 30%, 50%, and 70% of the full plan
			observability = [10, 25, 30, 50, 70, 75]
			for obs in observability:
				for alternativeObs in range(1,4):				
					getcontext().prec = 5
					obsFloat = Decimal(obs) / Decimal(100)
					numberOfObservations = math.ceil(Decimal(len(goalPlan)) * obsFloat)
					if numberOfObservations < 1:
						numberOfObservations = 1
					print('OBS: ' + str(obs))
					print(numberOfObservations)
					# print(randint(0,numberOfObservations-1))

					obsIndexes = []
					obsCounter = 0
					while obsCounter < numberOfObservations:
						index = randint(0,len(goalPlan)-1)
						if index not in obsIndexes:
							obsIndexes.append(index)
							obsCounter = obsCounter + 1

					obsStringPlan = ''
					observations = open('obs.dat', 'w')
					for i in sorted(obsIndexes):
						obsStringPlan += goalPlan[i]

					observations.write(obsStringPlan)
					observations.close()

					observability_file = open('observability.dat', 'w')
					observability_file.write(str(obs))
					observability_file.close()
					
					cmd = 'tar jcvf ' + domainName + '_p0' + str(problemNumber) + '_hyp-' + str(hypNumber) + '_' + str(obs) + '_' + str(alternativeObs) + '.tar.bz2' + ' domain.pddl initial_state.pddl hyps.dat obs.dat observability.dat real_hyp.dat'
					os.system(cmd)

			# Full plan (100%)
			goalHypothesisFullPlan = open('pb' + str(problemNumber) + '_hyp' + str(hypNumber) + '.plan')
			observations = open('obs.dat', 'w')
			for line in goalHypothesisFullPlan:
				observations.write(line)

			observations.close()

			observability_file = open('observability.dat', 'w')
			observability_file.write('100')
			observability_file.close()

			cmd = 'tar jcvf ' + domainName + '_p0' + str(problemNumber) + '_hyp-' + str(hypNumber) + '_full.tar.bz2' + ' domain.pddl initial_state.pddl hyps.dat obs.dat observability.dat real_hyp.dat'
			os.system(cmd)

if __name__ == '__main__' :
	main()