#!/bin/csh -f

cd /RAID2/COURSE/2026_Fall/iclab/iclab089/Lab01_2026_F/FALL_2026_LAB01/01_RTL

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/cad/synopsys/vcs/2022.06/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

