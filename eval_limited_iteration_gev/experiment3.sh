#!/bin/bash -x

# MinGEV-NS
./run.sh --bg_gain 1.0 --mode both_min --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both_min --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both_min --scaling absmask --iteration 500 --do_bn True

# MinGEV-NO
./run.sh --bg_gain 1.0 --mode left_min --scaling absmask --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode left_min --scaling absmask --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode left_min --scaling absmask --iteration 500 --do_bn False

# MinGEV-OS
./run.sh --bg_gain 1.0 --mode right_min --scaling absmask --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode right_min --scaling absmask --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode right_min --scaling absmask --iteration 500 --do_bn False

# Summary
./summary3.sh
