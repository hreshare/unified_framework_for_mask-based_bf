#!/bin/bash

subdirs="
eval_scaling_bg-1.0_mode-ideal_mwf_scale-absmask_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-absmask_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-absmask_itr-500_bn-True

eval_scaling_bg-1.0_mode-ideal_mwf_scale-normask_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-normask_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-normask_itr-500_bn-True

eval_scaling_bg-1.0_mode-ideal_mwf_scale-sqnormask_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-sqnormask_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-sqnormask_itr-500_bn-True

eval_scaling_bg-1.0_mode-ideal_mwf_scale-mask_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-mask_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-mask_itr-500_bn-True

eval_scaling_bg-1.0_mode-ideal_mwf_scale-ideal_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-ideal_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-ideal_itr-500_bn-True

eval_scaling_bg-1.0_mode-ideal_mwf_scale-mdp_itr-500_bn-True
eval_scaling_bg-2.0_mode-ideal_mwf_scale-mdp_itr-500_bn-True
eval_scaling_bg-4.0_mode-ideal_mwf_scale-mdp_itr-500_bn-True
"

for d in $subdirs; do
    local/write_se_results_as_tsv.sh $d
done
