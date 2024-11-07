#!/bin/bash -x

# ISEV-NS & L1-MN mask
./run.sh --bg_gain 1.0 --mode both --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both --scaling normask --iteration 500 --do_bn True

# ISEV-NO & L1-MN mask
./run.sh --bg_gain 1.0 --mode left --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode left --scaling normask --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode left --scaling normask --iteration 500 --do_bn True

# ISEV-OS & L1-MN mask
./run.sh --bg_gain 1.0 --mode right --scaling normask --iteration 1000 --do_bn True
./run.sh --bg_gain 2.0 --mode right --scaling normask --iteration 1000 --do_bn True
./run.sh --bg_gain 4.0 --mode right --scaling normask --iteration 1000 --do_bn True

## Experiment 3 in the previous manuscript
## ISEV-NS & non-negative mask
#./run.sh --bg_gain 1.0 --mode both --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 2.0 --mode both --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 4.0 --mode both --scaling absmask --iteration 500 --do_bn True

## ISEV-NO & non-negative mask
#./run.sh --bg_gain 1.0 --mode left --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 2.0 --mode left --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 4.0 --mode left --scaling absmask --iteration 500 --do_bn True

## ISEV-OS & non-negative mask
#./run.sh --bg_gain 1.0 --mode right --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 2.0 --mode right --scaling absmask --iteration 500 --do_bn True
#./run.sh --bg_gain 4.0 --mode right --scaling absmask --iteration 500 --do_bn True


# Summary
./summary4.sh