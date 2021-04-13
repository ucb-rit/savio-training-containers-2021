% Introduction to Containers: Creating Reproducible, Scalable, and Portable Workflows
% April 21, 2021 
% Nicolas Chan, Oliver Muellerklein, and Chris Paciorek

# Upcoming events and hiring

 - [Cloud Computing Meetup](https://www.meetup.com/ucberkeley_cloudmeetup/) (monthly) 

 - Looking for researchers working with sensitive data as we are building tools and services to support that work. Get in touch for more information. 

 - [Securing Research Data Working Group](https://dlab.berkeley.edu/working-groups/securing-research-data-working-group) (monthly)

 - Research IT is hiring graduate students as domain consultants. See flyers or talk to one of us.

# Introduction

We'll do this mostly as a demonstration. We encourage you to login to your account and try out the various examples yourself as we go through them.

The materials for this tutorial are available using git at the short URL ([tinyurl.com/brc-apr21](https://tinyurl.com/brc-apr21)), the  GitHub URL ([https://github.com/ucb-rit/savio-training-containers-2021](https://github.com/ucb-rit/savio-training-containers-2021)), or simply as a [zip file](https://github.com/ucb-rit/savio-training-containers-2021/archive/main.zip).

# Outline

This training session will cover the following topics:

# Introduction to containers

## What is a container

(see Wei materials)

Terminology:

- image: a bundle of files, including the oeprating system, software, and possibly data and files associated with the software
   - may be stored as a single file (e.g., Singularity) or a group of files (e.g., Docker)
- container: a virtual environment based on a container; alternatively a running instance of an image
   

## Containers versus VMs

perhaps show a figure

(see Wei materials)

## Why use containers
 - portability - install once, run 'anywhere'
 - control your environment/software on systems you don't own
 - manage complex dependencies by creating modular workflows, one workflow per container
 - provide a reproducible environment
     - for yourself in the future
     - for others (lab members)
     - for a publication 
 - run work that requires outdated versions of software or OS
 - test your code on various configurations or OSes	 

## Limitations of containers

(see SDSC training)

## Docker vs. Singularity

What is Docker?
What is Singularity?

How Singularity can leverage Docker.

Running Singularity containers on Savio, including using Docker images

## Examples of where containers are used

- Kubernetes
- MyBinder
- check runMyCode, etc.

## perhaps other related slides

# Basic container use

## Demo a Singularity container based on Dockerhub

(singularity pull)
(see Wei notes)

## Other ways of running a container

(also show same container running via Docker on personal system)
(also show direct usage of a Singularity container)


## Accessing the Savio filesystems and bind paths

## Different ways of using a Singularity container

Shell vs. exec vs. run

(see Wei materials)

`singularity inspect -r file.sif`

## Running containers on Savio via Slurm

quick demo srun
show what goes into an sbatch job script

```
#!/bin/bash -l
#SBATCH --job-name=container-test		 
#SBATCH --partition=lr5			 
#SBATCH --account=ac_xxx		 
#SBATCH --qos=lr_normal			
#SBATCH --nodes=1			
#SBATCH --time=1-2:0:0			

cd $SLURM_SUBMIT_DIR
singularity exec mycontainer.sif cat /etc/os-release
```

## Container processes on the host system

Show what seen in terms of a container application with ps and top

## Sources of container images

- DockerHub
- SingularityHub

## Singularity workflow (leading into Nicolas' material)

- install Singularity locally (or build an image in the cloud) (link to Wei instructions)
- transfer image to Savio
- run container on Savio

# Nicolas' content

# Wei's content

# Oliver's content

# Other container resources

https://education.sdsc.edu/training/interactive/202101_intro_to_singularity/
https://github.com/XSEDE/Container_Tutorial
https://carpentries-incubator.github.io/docker-introduction/index.html
https://carpentries-incubator.github.io/singularity-introduction/

list various tutorials/trainings - see Google doc

# How to get additional help

 - Check the Status and Announcements page:
    - [https://research-it.berkeley.edu/services/high-performance-computing/status-and-announcements](https://research-it.berkeley.edu/services/high-performance-computing/status-and-announcements)
 - For technical issues and questions about using Savio:
    - brc-hpc-help@berkeley.edu
 - For questions about computing resources in general, including cloud computing:
    - brc@berkeley.edu
    - office hours: office hours: Wed. 1:30-3:00 and Thur. 9:30-11:00 [on Zoom](https://research-it.berkeley.edu/programs/berkeley-research-computing/research-computing-consulting)
 - For questions about data management (including HIPAA-protected data):
    - researchdata@berkeley.edu
    - office hours: office hours: Wed. 1:30-3:00 and Thur. 9:30-11:00 [on Zoom](https://research-it.berkeley.edu/programs/berkeley-research-computing/research-computing-consulting)
