#!/bin/bash -x

# MinGEV-NS & L1-MN mask
./run.sh --bg_gain 1.0 --mode both_min --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both_min --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both_min --scaling normask --iteration 500 --do_bn True

# MinGEV-NO & L1-MN mask
./run.sh --bg_gain 1.0 --mode left_min --scaling normask --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode left_min --scaling normask --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode left_min --scaling normask --iteration 500 --do_bn False

# MinGEV-OS & L1-MN mask
./run.sh --bg_gain 1.0 --mode right_min --scaling normask --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode right_min --scaling normask --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode right_min --scaling normask --iteration 500 --do_bn False

## Experiment 3 described in the previous manuscript
## MinGEV-NS & non-negative mask
#./run.sh --bg_gain 1.0 --mode both_min --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 2.0 --mode both_min --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 4.0 --mode both_min --scaling absmask --iteration 500 --do_bn True

## MinGEV-NO & non-negative mask
#./run.sh --bg_gain 1.0 --mode left_min --scaling absmask --iteration 500 --do_bn False
#./run.sh --bg_gain 2.0 --mode left_min --scaling absmask --iteration 500 --do_bn False
#./run.sh --bg_gain 4.0 --mode left_min --scaling absmask --iteration 500 --do_bn False

## MinGEV-OS & non-negative mask
#./run.sh --bg_gain 1.0 --mode right_min --scaling absmask --iteration 500 --do_bn False
#./run.sh --bg_gain 2.0 --mode right_min --scaling absmask --iteration 500 --do_bn False
#./run.sh --bg_gain 4.0 --mode right_min --scaling absmask --iteration 500 --do_bn False

# Summary
./summary4.sh
