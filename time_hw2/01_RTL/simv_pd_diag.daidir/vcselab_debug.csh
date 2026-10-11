#!/bin/csh -f

cd /home/m114/m114061584/time_2026fall/time_hw2/01_RTL

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/cad/synopsys/vcs/2022.06/linux64/bin/vcselab $* \
    -o \
    simv_pd_diag \
    -nobanner \

cd -

