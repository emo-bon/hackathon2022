#!/bin/bash
#SBATCH --job-name=<add a nine alphanumeric name here>
#SBATCH --output=out
#SBATCH --error=err
#$BATCH --nodes=1
#SBATCH --ntasks-per-node=1

cd $SLURM_SUBMIT_DIR
source ~/.bash_profile
