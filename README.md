# Unified framework for mask-based beamformers
This repository includes experimental systems used in the manuscript titled ["Can all variations within the unified mask-based beamformer framework achieve identical peak extraction performance?"](https://arxiv.org/abs/2407.15310)

(Nov. 6th, 2024)
According to the major revision of the manuscript, experiments were revised as follows:

1. Al experiments were renumbered,as Appendix A was moved to Experiment 1.
2. New Experiment 3 (old Experiment 2) examines not only non-negative and ratio masks but also L1-mean-normalized (MN) and l2-MN masks as scaling masks.
3. New Experiment 4 (old Experiment 3) employs the L1-MN mask instead of non-negative one as a scaling mask.


## How to use
These systems use the CHiME 4 dataset and depend on its baseline system for this dataset included in the Kaldi Speech Recognition Toolkit. Thus, the following steps are necessary before using the experimental systems:

1. Obtain the CHiME 4 dataset. See https://www.chimechallenge.org/challenges/chime4/index .
2. Set up the Kaldi Speech Recognition Toolkit. See https://github.com/kaldi-asr/kaldi .
3. In that toolkit, go to kaldi/egs/chime4/s5_6ch/ and conduct the experiments using the baseline system.

After that, do following steps:

4. Copy the following directories to kaldi/egs/chime4/:
   - eval_limited_iteration_gev/
   - eval_limited_iteration_inv/
   - eval_limited_iteration_isev/
   - eval_mask_based_scaling_with_ideal_mmse/
5. Execute 'prepare.sh' under each of the four directories.
6. You can conduct Experiment 1 with the following commands:
   - (cd eval_limited_iteration_gev/;  ./experiment1_wo_bn.sh; ./experiment1_with_bn.sh)
   - (cd eval_limited_iteration_inv/;  ./experiment1_wo_bn.sh; ./experiment1_with_bn.sh)
   - (cd eval_limited_iteration_isev/; ./experiment1_wo_bn.sh; ./experiment1_with_bn.sh)
7. You can conduct Experiment 2 with the following commands:
   - (cd eval_limited_iteration_gev/;  ./experiment2.sh)
   - (cd eval_limited_iteration_inv/;  ./experiment2.sh)
   - (cd eval_limited_iteration_isev/; ./experiment2.sh)
8. You can conduct Experiment 3 with the following commands:
   - (cd eval_mask_based_scaling_with_ideal_mmse/; ./experiment3.sh)
9. You can conduct Experiment 4 with the following commands:
   - (cd eval_limited_iteration_gev/;  ./experiment4.sh)
   - (cd eval_limited_iteration_inv/;  ./experiment4.sh)
   - (cd eval_limited_iteration_isev/; ./experiment4.sh)

## Cite this work
    Hiroe, A., Itoyama, K. & Nakadai, K. Can all variations within the unified mask-based beamformer framework achieve identical peak extraction performance?. J AUDIO SPEECH MUSIC PROC. 2024, 66 (2024). https://doi.org/10.1186/s13636-024-00387-x

