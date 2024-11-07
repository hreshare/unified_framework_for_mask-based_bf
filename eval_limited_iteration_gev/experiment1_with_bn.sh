#!/bin/bash -x

# MinGEV-NS
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 50 --do_bn True
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 100 --do_bn True
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 200 --do_bn True
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 300 --do_bn True
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 400 --do_bn True
./run.sh --bg_gain 1.0 --mode both_min --scaling ideal --iteration 500 --do_bn True


# Summary
./summary1_with_bn.sh
