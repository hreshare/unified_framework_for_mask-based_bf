#!/bin/bash

subdirs="
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-50_bn-True
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-100_bn-True
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-200_bn-True
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-300_bn-True
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-400_bn-True
limited_iteration_gev_bg-1.0_mode-both_min_scale-ideal_itr-500_bn-True
"


for d in $subdirs; do
    local/write_se_results_as_tsv.sh $d
done
