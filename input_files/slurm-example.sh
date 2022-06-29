#!/bin/bash
#SBATCH --job-name=<replace this comment with a max. 9 char name>
#SBATCH --partition=all
#SBATCH --output=out
#SBATCH --error=err
#$BATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --nodelist=ceta4

cd $SLURM_SUBMIT_DIR
source ~/.bash_profile
<replace this comment with your command(s)>
