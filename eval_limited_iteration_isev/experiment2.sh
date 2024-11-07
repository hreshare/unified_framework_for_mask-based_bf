#!/bin/bash -x

# ISEV-NS
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode both --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode both --scaling ideal --iteration 500 --do_bn True

# ISEV-NO
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 2.0 --mode left --scaling ideal --iteration 500 --do_bn True
./run.sh --bg_gain 4.0 --mode left --scaling ideal --iteration 500 --do_bn True

# ISEV-OS (using 1000 iterations because of slower convergence)
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 1000 --do_bn True
./run.sh --bg_gain 2.0 --mode right --scaling ideal --iteration 1000 --do_bn True
./run.sh --bg_gain 4.0 --mode right --scaling ideal --iteration 1000 --do_bn True

# Summary
./summary2.sh
