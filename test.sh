#!/bin/bash 
#SBATCH --job-name=container-test		 
#SBATCH --partition=savio2		 
#SBATCH --account=co_stat		 			
#SBATCH --time=5:00		

singularity exec hello-world.sif cat /etc/os-release
