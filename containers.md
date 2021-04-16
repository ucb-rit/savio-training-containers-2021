% Introduction to Containers: Creating Reproducible, Scalable, and Portable Workflows
% April 21, 2021 
% Nicolas Chan, Wei Feinstein, Oliver Muellerklein, and Chris Paciorek

# Upcoming events and hiring

 - Looking for researchers working with sensitive data as we are building tools and services to support that work. Get in touch for more information.

 - Research IT is hiring graduate and undergraduate students for a variety of positions. Please talk to Amy Neeser to get more information.

 - [Cloud Computing Meetup](https://www.meetup.com/ucberkeley_cloudmeetup/) (monthly, with next meeting April 29 at 1 pm) 

 - [Securing Research Data Working Group](https://dlab.berkeley.edu/working-groups/securing-research-data-working-group) (monthly, with next meeting May 10 at 2 pm)

 

# Introduction

We'll do this mostly as a demonstration. We encourage you to login to your account and try out the various examples yourself as we go through them.

The materials for this tutorial are available using git at the short URL ([tinyurl.com/brc-apr21](https://tinyurl.com/brc-apr21)), the  GitHub URL ([https://github.com/ucb-rit/savio-training-containers-2021](https://github.com/ucb-rit/savio-training-containers-2021)), or simply as a [zip file](https://github.com/ucb-rit/savio-training-containers-2021/archive/main.zip).

# Outline

This training session will cover the following topics:

- Introduction to containers
   - Comparison with VMs
   - Docker and Singularity
   - Advantages of containers
- Basic usage of containers
   - Demo of running a Singularity container
   - More details on running a container
   - Use with Slurm
   - Sources of images

(need to add outline items for Wei, Oliver, Nicolas sections)

# What is a container?

 - Containerization provides "lightweight, standalone, executable packages of software that include everything needed to run an application: code, runtime, system tools, system libraries and settings".
 - A container provides a self-contained (isolated) filesystem.
 - Containers are similar to virtual machines in some ways, but much lighter-weight.
 - Containers are portable, shareable, and reproducible.

Terminology:

- image: a bundle of files, including the operating system, system libraries, software, and possibly data and files associated with the software
   - may be stored as a single file (e.g., Singularity) or a group of files (e.g., Docker)
- container: a virtual environment based on an image (i.e., a running instance of an image)
   - software running in the container sees this environment


(can we find/create a good graphic?)

see vm versus container graphic here:
https://github.com/XSEDE/Container_Tutorial/blob/master/Gateways2020/Day1_1_Introduction-to-Containers.pdf

## Containers versus VMs

perhaps show a figure - try to edit Wei's figure

VMs have a copy of the entire operating system and need to be booted up, while containers use the Linux kernel of the host machine and processes running in the container can be seen as individual processes on the host.

# Why use containers?

 - Portability - install once, run "anywhere".
 - Control your environment/software on systems (such as Savio, XSEDE) you don't own.
 - Manage complex dependencies/installations by using containers for modular computational workflows/pipelines, one workflow per container.
 - Provide a reproducible environment:
     - for yourself in the future,
     - for others (lab members),
     - for software you develop,
     - for a publication.
 - Run work that requires outdated or updated versions of software or OS or an OS you don't have.
 - Test your code on various configurations or OSes.
 - High performance compared to VMs.

Much of this comes down to the fact that your workflow can depend in a fragile way on one or more pieces of software that may be difficult to install or keep operational.

# Limitations of containers

- Another level of abstraction/indirection can be confusing
- Can run into host-container incompatibilities (e.g., MPI, GPUs)
- Limitations in going between CPU architectures (e.g., x86_64 versus ARM)

# Docker vs. Singularity

What is Docker?

- Open-source computer software that encapsulates an application and all its dependencies into a single image, as a series of layers 
- Brings containerization to the individuals on their own machines
- Rich image repository
- Widely used by scientific communities
- Security concerns make it unsuitable for the HPC environment
- By default you are root in the container

What is Singularity?

- Open-source computer software that encapsulates an application and all its dependencies into a single image, as a single file
- Brings containerization to Linux clusters and HPC
- Developed at LBL by Greg Kurtzer
- Typically users have a machine on which they have admin privileges and can't build images but don't have admin privileges where the containers are run
- You are yourself (from the host machine) in the container

How can Singularity can leverage Docker?

- Create and run a Singularity container based on a Docker image
- (transform a Dockerfile?)
- Create Singularity images by running Singularity in a Docker container
- other?

# Examples of where containers are used

- Kubernetes runs pods based on Docker images
- MyBinder creates an executable environment by building a Docker image
- You can have GitHub Actions and Bitbucket Pipelines in a Docker container
- CodeOcean capsules are built on Docker images 

# Running pre-existing containers using Singularity

- No root/sudo privilege is needed
- Create/download immutable squashfs images/containers

```
singularity pull --help
```

- DockerHub: Pull a container from DockerHub.
```
$ singularity pull docker://ubuntu:18.04 
$ singularity pull docker://rocker/r-base:latest
$ singularity pull docker://postgres
$ ls -lrt | tail -n 10   # careful of your quota!
$ ls -l ~/.singularity
$ singularity cache list
```

```
singularity run ubuntu_18.04.sif       # use downloaded image file
## alternatively, use ~/.singularity/cache
singularity run docker://ubuntu:18.04  
```

Note the change in prompt.

```
cat /etc/issue   # not the Savio OS!
which python     # not much here!
pwd
echo "written from the container" > junk.txt
ls /global/scratch/paciorek | head -n 5
exit
cat junk.txt
```

```
singularity run docker://rocker/r-base    # easy!
singularity run docker://postgres         # sometimes things are complicated!
```

# Other ways of running a container

- Singularity Hub: If no tag is specified, the master branch of the repository is used

```
$ singularity pull hello-world.sif shub://singularityhub/hello-world
$ singularity run hello-world.sif
```

Here's how one runs a Docker container (on a system where you have admin access):

```
echo $HOME
docker run -it --rm rocker/r-base bash
pwd
ls /accounts/gen/vis/paciorek    # no automatic mount of my host home directory
```


# Different ways of using a Singularity container

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

`singularity inspect -r hello-world.sif`

# Container processes on the host system

Let's see how the container processes show up from the perspective of the host OS.

We'll run some intensive linear algebra in R.

```
singularity run docker://rocker/r-base:latest
```

```r
a <- matrix(rnorm(10000^2), 10000)
system.time(chol(crossprod(a)))
```

We see in `top` that the R process running in the container shows up as an R process on the host.

# Accessing the Savio filesystems and bind paths

- Singularity allow mapping directories on host to directories within container
- Easy data access within containers
- System-defined bind paths on Savio
        - /global/home/users/
        - /global/scratch/
        - /tmp
- User can define own bind paths: 
- e.g.: mount  /host/path/ on the host to /container/path inside the container via `-B /host/path/:/container/path`, e.g.,

```
ls /global/scratch/paciorek/wikistats_small
singularity shell -B /global/scratch/paciorek/wikistats_small:/data hello-world.sif
ls /data
touch /data/erase-me
exit
ls -l /global/scratch/paciorek/wikistats_small
```

In general one would do I/O to data on the host system rather than writing into the container.

It is possible to create writeable containers. 

# Running containers on Savio via Slurm

You can run Singularity within an `sbatch` or `srun` session.

Here's a basic job script.

```
#!/bin/bash 
#SBATCH --job-name=container-test		 
#SBATCH --partition=savio2		 
#SBATCH --account=co_stat		 			
#SBATCH --time=5:00		

singularity exec hello-world.sif cat /etc/os-release
```

# Sources of container images

- [DockerHub](https://hub.docker.com)
- [SingularityHub](https://singularity-hub.org)

DockerHub images are named liked this: OWNER/CONTAINERNAME:TAG, e.g., [https://hub.docker.com/u/continuumio](https://hub.docker.com/u/continuumio).

For images provided by Docker, you don't specify the OWNER.



# Singularity workflow (leading into Nicolas' material)

- [install Singularity locally](https://docs.google.com/document/d/10XAtH9yj5uyiHr3eGHTk9h82bZXEp0aixMCmgYJhGNQ/edit?usp=sharing) (or build an image in the cloud) 
- transfer image to Savio
- run container on Savio

# Nicolas' content

# Approaches to Building
- Build a Docker image and convert
  - Convenient if you already have a Docker build file
- Build from Singularity definition file
  - Bootstrap from another Singularity container or non-Docker base OS
  - Alows extra customization with directives

# Building a Docker container
```docker
FROM ubuntu:18.04
RUN mkdir -p /app
```

- TODO: cover ENTRYPOINT and CMD

# Pushing to Docker Registry
TODO

# Converting Docker to Singularity
- `singularity run docker://...`
- `singularity build test.simg docker://`

Reference: https://github.com/ucb-rit/savio-singularity-template/blob/master/build_examples.md

# Singularity Definition File
1. **Header**: Base to build the container off of, such as an existing Docker/Singularity/OS image
2. **Sections**: Denoted by a `%` which are executed once the container is built to configure it

Reference: https://sylabs.io/guides/3.0/user-guide/definition_files.html

# Singularity Build Example
- Building simple archlinux asciiquarium image: `arch-example.def`
- `%setup`: Executed on host system before container is built
- `%environment`: Set environment variables in the container
- `%post`: Executed within the container at build time
- `%runscript`: Executed with `singularity run busybox-example.simg` or `./busybox-example.simg`

Reference: https://github.com/ucb-rit/savio-singularity-template

# Singularity Build Example (demo)
- `sudo singularity build alpine-example.simg alpine-example.def`
- `singularity run alpine-example.simg`
- `scp alpine-example.simg nicolaschan@dtn.brc.berkeley.edu:.`
- On Savio: `singularity run alpine-example.simg`
- On Savio: `singularity exec alpine-example.simg sh`
  - `echo $MY_VAR_VALUE`

# Singularity Build Options
- Install Singularity locally
- Install Docker locally and use singularity-docker
  - https://github.com/singularityhub/singularity-docker
- Build an image on a cloud service or continuous integration host
  - Sylabs Remote Builder: https://cloud.sylabs.io/builder

# Rewritable/Sandbox Singularity Images
TODO

# Pushing to Singularity Registry
TODO

# Wei's content

# Oliver's content

# Other container resources

- [San Diego supercomputing center training](https://education.sdsc.edu/training/interactive/202101_intro_to_singularity/)
- [XSEDE tutorial](https://github.com/XSEDE/Container_Tutorial)
- [Software Carpentries Docker training](https://carpentries-incubator.github.io/docker-introduction/index.html)
- [Software Carpentries Singularity training](https://carpentries-incubator.github.io/singularity-introduction/)

(any others?)

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
