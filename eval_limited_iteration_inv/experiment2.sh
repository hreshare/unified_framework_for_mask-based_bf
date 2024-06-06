#!/bin/bash -x

# Ideal MMSE BF & non-negative mask
./run.sh --bg_gain 1.0 --mode ideal --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode ideal --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode ideal --scaling absmask --iteration 500 --do_bn True

# Ideal MMSE BF & ratio mask
./run.sh --bg_gain 1.0 --mode ideal --scaling mask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode ideal --scaling mask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode ideal --scaling mask --iteration 500 --do_bn True

# Ideal MMSE BF & ideal scaling
./run.sh --bg_gain 1.0 --mode ideal --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode ideal --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode ideal --scaling ideal --iteration 500 --do_bn False

# Ideal MMSE BF & MDP
./run.sh --bg_gain 1.0 --mode ideal --scaling mdp --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode ideal --scaling mdp --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode ideal --scaling mdp --iteration 500 --do_bn False


# Summary
./summary2.sh
