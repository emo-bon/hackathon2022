#!/bin/bash
#SBATCH --job-name=<add a nine alphanumeric name here>
#SBATCH --partition=fat
#SBATCH --output=out
#SBATCH --error=err
#$BATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --mail-user=my-email@local.com
#SBATCH --mail-type=ALL


cd $SLURM_SUBMIT_DIR
source ~/.bash_profile
<put your command(s) here>
