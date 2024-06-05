#!/bin/bash

subdirs="
limited_iteration_inv_bg-1.0_mode-ideal_scale-absmask_itr-500_bn-True
limited_iteration_inv_bg-2.0_mode-ideal_scale-absmask_itr-500_bn-True
limited_iteration_inv_bg-4.0_mode-ideal_scale-absmask_itr-500_bn-True

limited_iteration_inv_bg-1.0_mode-ideal_scale-mask_itr-500_bn-True
limited_iteration_inv_bg-2.0_mode-ideal_scale-mask_itr-500_bn-True
limited_iteration_inv_bg-4.0_mode-ideal_scale-mask_itr-500_bn-True

limited_iteration_inv_bg-1.0_mode-ideal_scale-ideal_itr-500_bn-True
limited_iteration_inv_bg-2.0_mode-ideal_scale-ideal_itr-500_bn-True
limited_iteration_inv_bg-4.0_mode-ideal_scale-ideal_itr-500_bn-True

limited_iteration_inv_bg-1.0_mode-ideal_scale-mdp_itr-500_bn-True
limited_iteration_inv_bg-2.0_mode-ideal_scale-mdp_itr-500_bn-True
limited_iteration_inv_bg-4.0_mode-ideal_scale-mdp_itr-500_bn-True
"

for d in $subdirs; do
    local/write_se_results_as_tsv.sh $d
done
