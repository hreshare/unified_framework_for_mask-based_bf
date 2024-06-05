# Unified framework for mask-based beamformers
This repository includes experimental systems used in the paper titled "Can all variations within the unified mask-based beamformer framework achieve identical peak extraction performance?"



## How to use
These systems use the CHiME 4 dataset and depend on its baseline system for this dataset included in the Kaldi Speech Recognition Toolkit. Thus, the following steps are necesarry before using the experimental systems:

1. Obtain the CHiME 4 dataset. See https://spandh.dcs.shef.ac.uk/chime_challenge/chime2016/index.html .
2. Set up the Kaldi Speech Recognition Toolkit. See https://github.com/kaldi-asr/kaldi .
3. In that toolkit, go to kaldi/egs/chime4/s5_6ch/ and conduct the experiments using the baseline system.

After that, do following steps:

4. Copy the following directories to kaldi/egs/chime4/:
   - eval_limited_iteration_gev/
   - eval_limited_iteration_inv/
   - eval_limited_iteration_isev/
5. Execute 'prepare.sh' under each of the three directories.
5. You can conduct Experiment 1 with the following commands:
     (cd eval_limited_iteration_gev/;  ./experiment1.sh)
     (cd eval_limited_iteration_inv/;  ./experiment1.sh)
     (cd eval_limited_iteration_isev/; ./experiment1.sh)
6. You can conduct Experiment 2 with the following commands:
     (cd eval_limited_iteration_inv/;  ./experiment2.sh)
7. You can conduct Experiment 1 with the following commands:
     (cd eval_limited_iteration_gev/;  ./experiment3.sh)
     (cd eval_limited_iteration_inv/;  ./experiment3.sh)
     (cd eval_limited_iteration_isev/; ./experiment3.sh)


