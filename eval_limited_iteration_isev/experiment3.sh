#!/bin/bash -x

# ISEV-NS
./run.sh --bg_gain 1.0 --mode both --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both --scaling absmask --iteration 500 --do_bn True

# ISEV-NO
./run.sh --bg_gain 1.0 --mode left --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode left --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode left --scaling absmask --iteration 500 --do_bn True

# ISEV-OS
./run.sh --bg_gain 1.0 --mode right --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode right --scaling absmask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode right --scaling absmask --iteration 500 --do_bn True

# Summary
./summary3.sh
