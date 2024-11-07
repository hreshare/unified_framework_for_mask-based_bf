#!/bin/bash

subdirs="
limited_iteration_isev_bg-1.0_mode-both_scale-normask_itr-500_bn-True
limited_iteration_isev_bg-2.0_mode-both_scale-normask_itr-500_bn-True
limited_iteration_isev_bg-4.0_mode-both_scale-normask_itr-500_bn-True

limited_iteration_isev_bg-1.0_mode-left_scale-normask_itr-500_bn-True
limited_iteration_isev_bg-2.0_mode-left_scale-normask_itr-500_bn-True
limited_iteration_isev_bg-4.0_mode-left_scale-normask_itr-500_bn-True

limited_iteration_isev_bg-1.0_mode-right_scale-normask_itr-1000_bn-True
limited_iteration_isev_bg-2.0_mode-right_scale-normask_itr-1000_bn-True
limited_iteration_isev_bg-4.0_mode-right_scale-normask_itr-1000_bn-True
"

# Experiment 3 in the previous manuscript
#limited_iteration_isev_bg-1.0_mode-both_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-2.0_mode-both_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-4.0_mode-both_scale-absmask_itr-500_bn-True

#limited_iteration_isev_bg-1.0_mode-left_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-2.0_mode-left_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-4.0_mode-left_scale-absmask_itr-500_bn-True

#limited_iteration_isev_bg-1.0_mode-right_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-2.0_mode-right_scale-absmask_itr-500_bn-True
#limited_iteration_isev_bg-4.0_mode-right_scale-absmask_itr-500_bn-True



for d in $subdirs; do
    local/write_se_results_as_tsv.sh $d
done
