#!/bin/bash -x

# MaxGEV-NS
./run.sh --bg_gain 1.0 --mode both_max --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both_max --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both_max --scaling ideal --iteration 500 --do_bn True

# MaxGEV-NO
./run.sh --bg_gain 1.0 --mode right_max --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode right_max --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode right_max --scaling ideal --iteration 500 --do_bn False

# MaxGEV-OS
./run.sh --bg_gain 1.0 --mode left_max --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode left_max --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode left_max --scaling ideal --iteration 500 --do_bn False

# MinGEV-NS
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both_min --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both_min --scaling ideal --iteration 500 --do_bn True

# MinGEV-NO
./run.sh --bg_gain 1.0 --mode left_min --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode left_min --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode left_min --scaling ideal --iteration 500 --do_bn False

# MinGEV-OS
./run.sh --bg_gain 1.0 --mode right_min --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 2.0 --mode right_min --scaling ideal --iteration 500 --do_bn False
./run.sh --bg_gain 4.0 --mode right_min --scaling ideal --iteration 500 --do_bn False

# Summary
./summary2.sh
