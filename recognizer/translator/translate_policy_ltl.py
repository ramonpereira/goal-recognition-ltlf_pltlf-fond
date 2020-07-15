"""
 Author: Francesco Fuggitti
 The aim of this translator is to translate a policy with trans actions 
 (actions added in the domain model by the LTL2DFA) to a policy with no trans actions.
"""

import argparse
import re

def get_value(text, regex):
    """Dump a value from a file based on a regex passed in."""
    pattern = re.compile(regex, re.MULTILINE)
    results = pattern.findall(text)
    if results:
        return results
    else:
        print("Could not find the value {}, in the text provided".format(regex))
        return []


def process_policy(policy):
    """Process the PRP policy removing trans."""
    with open(policy, "r") as f:
        policy_with_trans = f.read()

    if_holds = get_value(policy_with_trans, r".*If holds:[\s]*(.*?)\n.*")
    executes = get_value(policy_with_trans, r".*Execute:[\s]*(.*?)\n.*")

    actual_if_holds = []
    actual_executes = []
    for a, b in zip(if_holds, executes):
        if "trans" not in b:
            res_1 = re.sub(r"q[0-9]{1,2}\(.*?\)", "", a)
            res_2 = re.sub(r"turndomain\(\)", "", res_1)
            actual_if_holds.append(res_2.strip("/"))
            actual_executes.append(b)
        else:
            assert "not(turndomain())" in a
        if "goal" in b:
            actual_if_holds[0] = re.sub(r"/q[0-9]{1,2}\(.*\)", "", if_holds[1])

    with open("new-policy.out", "w+", encoding="utf-8") as fo:
        t = "Policy:\n"
        for a, b in zip(actual_if_holds, actual_executes):
            t += "If holds: {}\nExecute: {}\n\n".format(a, b)
        fo.write(t)
