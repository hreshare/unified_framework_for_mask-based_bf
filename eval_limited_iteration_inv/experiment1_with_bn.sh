#!/bin/bash -x

# INV-NS
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 50 --do_bn True
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 100 --do_bn True
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 200 --do_bn True
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 300 --do_bn True
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 400 --do_bn True
./run.sh --bg_gain 1.0 --mode both --scaling ideal --iteration 500 --do_bn True

# INV-NO
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 50 --do_bn True
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 100 --do_bn True
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 200 --do_bn True
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 300 --do_bn True
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 400 --do_bn True
./run.sh --bg_gain 1.0 --mode left --scaling ideal --iteration 500 --do_bn True

# INV-OS
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 50 --do_bn True
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 100 --do_bn True
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 200 --do_bn True
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 300 --do_bn True
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 400 --do_bn True
./run.sh --bg_gain 1.0 --mode right --scaling ideal --iteration 500 --do_bn True

# Summary
./summary1_with_bn.sh
