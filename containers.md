% Introduction to Containers: Creating Reproducible, Scalable, and Portable Workflows
% April 21, 2021 
% Nicolas Chan, Wei Feinstein, Oliver Muellerklein, and Chris Paciorek

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

 - Containerization provides an isolated environment in which you can install your software and dependencies. 
 - Containers are similar to virtual machines in some ways, but much lighter-weight.
 - Containers are portable, shareable, and reproducible.

Terminology:

- image: a bundle of files, including the operating system, software, and possibly data and files associated with the software
   - may be stored as a single file (e.g., Singularity) or a group of files (e.g., Docker)
- container: a virtual environment based on an image (i.e., a running instance of an image)
   

## Containers versus VMs

perhaps show a figure - try to edit Wei's figure

## Why use containers
 - portability - install once, run 'anywhere'
 - control your environment/software on systems (such as Savio, XSEDE) you don't own
 - manage complex dependencies by using containers for modular computational workflows/pipelines, one workflow per container
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

- Bring containerization to the community-scale
- Rich image repository
- Widely used by scientific communities
- Compose for defining multi-container, recipe/definition file to build docker images
- Security concerns not ideal for the HPC environment

What is Singularity?

- Open-source computer software that encapsulates an application and all its dependencies into a single image
- Bring containers and reproducibility to scientific computing and HPC
- Developed at LBL by Greg Kurtzer
- Typically users have a build system as root users, but may not be root users on a production system

How Singularity can leverage Docker.

Running Singularity containers on Savio, including using Docker images

## Examples of where containers are used

- Kubernetes
- MyBinder
- check runMyCode, etc.

## perhaps other related slides

# Basic container use

## Running pre-existing containers using Singularity

- No root/sudo privilege is needed
- Create/download immutable squashfs images/containers
```
singularity pull --help
```
- Docker Hub:  Pull a container from Docker Hub.
```
$ singularity pull docker://ubuntu:18.04 
$ singularity pull docker://gcc:7.2.0
```

```
singularity run docker://ubuntu:18.04
```

- Singularity Hub:  If no tag is specified, the master branch of the repository is used

```
$ singularity pull hello-world.sif shub://singularityhub/hello-world
$ singularity run hello-world.sif
```

## Other ways of running a container

(also show same container running via Docker on personal system)
(also show direct usage of a Singularity container)




## Different ways of using a Singularity container

- **shell** sub-command: invokes an interactive shell within a container
```
singularity shell hello-world.sif
```
- **run** sub-command: executes the container’s runscript
```
singularity run hello-world.sif
```
- **exec** sub-command: execute an arbitrary command within container
```
singularity exec hello-world.sif cat /etc/os-release
```

`singularity inspect -r file.sif`

## Container processes on the host system

Show what seen in terms of a container application with ps and top

(run some intensive Python calculation with multiple cores on a Python Docker-based container)

## Accessing the Savio filesystems and bind paths

- Singularity allow mapping directories on host to directories within container
- Easy data access within containers
- System-defined bind paths on Savio
        - /global/home/users/
        - /global/scratch/
- User can define own bind paths: 
- e.g.: mount  /host/path/ on the host to /container/path inside the container via `-B /host/path/:/container/path`, e.g.,

```
singularity shell -B /global/home/users/$USER/mydir:/tmp/my_personal_dir pytorch_19_12_py3.sif 
```

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
