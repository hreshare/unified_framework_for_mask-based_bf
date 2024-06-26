#!/usr/bin/env bash

#!/bin/bash
# Copyright 2017 Johns Hopkins University (Author: Aswin Shanmugam Subramanian)
# Apache 2.0

. ./cmd.sh
. ./path.sh

# Config:
nj=10
cmd=run.pl
track=6
. utils/parse_options.sh || exit 1;

if [ $# != 9 ]; then
   echo "Wrong #arguments ($#, expected 9)"
   echo "Usage: local/run_train_and_infer.sh [options] <chime4-dir> <chime3-dir> <wav-out-dir> <bg_gain> <mode> <scaling> <iteration> <do_bn> <do_plot>"
   echo "main options (for others, see top of script file)"
   echo "  --nj <nj>                                # number of parallel jobs"
   echo "  --cmd <cmd>                              # Command to run in parallel with"
   echo "  --track <track>            # Chime data to use (2 or 6)"
   exit 1;
fi

sdir=$1
chime3_dir=$2
odir=$3
bg_gain=$4
mode=$5
scaling=$6
iteration=$7
do_bn=$8
do_plot=$9

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

#miniconda_dir=$HOME/miniconda3/
#if [ ! -d $miniconda_dir ]; then
#    echo "$miniconda_dir does not exist. Please run '../../../tools/extras/install_miniconda.sh' and '../../../tools/extras/install_chainer.sh';"
#fi

## check if chainer is installed
##result=`$HOME/miniconda3/bin/python -c "\
#result=`python3 -c "\
#try:
#    import chainer
#    print('1')
#except ImportError:
#    print('0')"`
#
#if [ "$result" == "1" ]; then
#    echo "Chainer is installed"
#else
#    echo "Chainer is not installed. Please run ../../../tools/extras/install_chainer.sh"
#fi

#if [ ! -d local/nn-gev ]; then
#    cd local/
#    git clone https://github.com/fgnt/nn-gev.git
#    cd nn-gev/
#    git checkout 3a039a4b707419fab05deb9679b41360ea92d779 .
#    git apply ../fix_read_sim_from_different_directory.patch
#    cd ../../
#else
#    cd local/nn-gev/
#    git checkout 3a039a4b707419fab05deb9679b41360ea92d779 .
#    git apply ../fix_read_sim_from_different_directory.patch
#    cd ../../
#fi

mkdir -p $odir
set +e
n_isolated_dirs=`ls local/mask_and_bf/data/audio/16kHz/isolated/ 2>/dev/null | wc -l`
n_isolated_ext_dirs=`ls local/mask_and_bf/data/audio/16kHz/isolated_ext/ 2>/dev/null | wc -l`
set -e
#if [[ "$n_isolated_dirs" -ne 12 || "$n_isolated_ext_dirs" -ne 12 ]];then
#   echo "generating simulation data and storing in local/mask_and_bf/data"
#   $cmd $odir/simulation.log matlab -nodisplay -nosplash -r "addpath('local'); CHiME3_simulate_data_patched_parallel(1,$nj,'$sdir','$chime3_dir');exit"
#else
#   echo "Didn't run Matlab simulation. Using existing data in local/mask_and_bf/data/audio/"
#fi

echo "Training a network for end-to-end minimal variance BF and enhancing signals with the BF"
$cuda_cmd $odir/beamform.log \
   local/run_min_var_bf.sh \
      $sdir $odir $track \
      $bg_gain $mode $scaling $iteration $do_bn $do_plot
