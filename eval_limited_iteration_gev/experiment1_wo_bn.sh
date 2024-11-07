#!/bin/bash -x

# MinGEV-NS
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 50 --do_bn False
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 100 --do_bn False
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 200 --do_bn False
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 300 --do_bn False
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 400 --do_bn False
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 500 --do_bn False

# MinGEV-NO
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 50 --do_bn False
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 100 --do_bn False
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 200 --do_bn False
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 300 --do_bn False
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 400 --do_bn False
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 500 --do_bn False

# MinGEV-OS
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 50 --do_bn False
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 100 --do_bn False
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 200 --do_bn False
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 300 --do_bn False
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 400 --do_bn False
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 500 --do_bn False

# Summary
./summary1_wo_bn.sh
