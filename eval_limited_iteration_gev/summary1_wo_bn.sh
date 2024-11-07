#!/bin/bash

subdirs="
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-50_bn-False
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-100_bn-False
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-200_bn-False
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-300_bn-False
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-400_bn-False
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-500_bn-False

limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-50_bn-False
limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-100_bn-False
limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-200_bn-False
limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-300_bn-False
limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-400_bn-False
limited_iteration_gev_bg-1.0_mode-left_min_scale-ideal_itr-500_bn-False

limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-50_bn-False
limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-100_bn-False
limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-200_bn-False
limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-300_bn-False
limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-400_bn-False
limited_iteration_gev_bg-1.0_mode-right_min_scale-ideal_itr-500_bn-False
"


for d in $subdirs; do
    local/write_se_results_as_tsv.sh $d
done
