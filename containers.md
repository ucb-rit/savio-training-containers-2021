% Introduction to Containers: Creating Reproducible, Scalable, and Portable Workflows (tinyurl.com/brc-apr21)
% April 21, 2021 
% Nicolas Chan, Wei Feinstein, Oliver Muellerklein, and Chris Paciorek

# Upcoming events and hiring

 - Research IT is looking for researchers working with sensitive data, as we are building tools and services to support that work. Please email research-it@berkeley.edu for more information.

 - Research IT is hiring graduate and undergraduate students for a variety of positions. Please talk to Amy Neeser to get more information.

 - [Cloud Computing Meetup](https://www.meetup.com/ucberkeley_cloudmeetup/) (monthly, with next meeting April 29 at 1 pm) 

 - [Securing Research Data Working Group](https://dlab.berkeley.edu/working-groups/securing-research-data-working-group) (monthly, with next meeting May 10 at 2 pm)

 

# Introduction

We'll do this mostly as a demonstration. We encourage you to login to your account and try out the various examples yourself as we go through them.

The materials for this tutorial are available using git at the short URL ([tinyurl.com/brc-apr21](https://tinyurl.com/brc-apr21)), the  GitHub URL ([https://github.com/ucb-rit/savio-training-containers-2021](https://github.com/ucb-rit/savio-training-containers-2021)), or simply as a [zip file](https://github.com/ucb-rit/savio-training-containers-2021/archive/main.zip).

# Outline

This training session will cover the following topics:

 - Introduction to containers (Chris) 
    - Comparison with VMs
    - Docker and Singularity
    - Advantages of containers
 - Basic usage of containers (Chris)
    - Demo of running a Singularity container
    - More details on running a container
    - Use with Slurm
    - Sources of images
 - Building containers (Nicolas)
    - Various ways to build Singularity containers
    - Using definition files
    - Using registries
    - Rewritable/sandbox images
 - Specialized uses (Wei)
    - MPI
    - GPUs


# What is a container?

 - Containerization provides "lightweight, standalone, executable packages of software that include everything needed to run an application: code, runtime, system tools, system libraries and settings".
 - A container provides a self-contained (isolated) filesystem.
 - Containers are similar to virtual machines in some ways, but much lighter-weight.
 - Containers are portable, shareable, and reproducible.

# Terminology/Overview

 - *image*: a bundle of files, including the operating system, system libraries, software, and possibly data and files associated with the software
    - may be stored as a single file (e.g., Singularity) or a group of files (e.g., Docker)
 - *container*: a virtual environment based on an image (i.e., a running instance of an image)
    - software running in the container sees this environment
 - *registry*: a source of images
 - *host*: the actual machine on which the container runs

# Terminology/Overview, take 2

<center><img src="taxonomy-of-docker-terms-and-concepts.png"></center>

(Image from docs.microsoft.com)

# Containers versus VMs

Let's see a schematic of what is going on with a container.

<center><img src="vm_vs_container.png"></center>

(Image from Tin Ho, github.com/tin6150)

VMs have a copy of the entire operating system and need to be booted up, while containers use the Linux kernel of the host machine and processes running in the container can be seen as individual processes on the host.

# Why use containers?

 - Portability - install once, run "anywhere".
 - Control your environment/software on systems (such as Savio, XSEDE) you don't own.
 - Manage complex dependencies/installations by using containers for modular computational workflows/pipelines, one workflow per container.
 - Provide a reproducible environment:
     - for yourself in the future,
     - for others (e.g., your collaborators),
     - for software you develop and want to distribute,
     - for a publication.
 - Flexibility in using various OS, software, or application versions:
     - use outdated or updated versions of software or OS
     - use an OS you don't have.
     - test your code on various configurations or OSes.
 - High performance compared to VMs.

Much of this comes down to the fact that your workflow can depend in a fragile way on one or more pieces of software that may be difficult to install or keep operational.

# Limitations of containers

 - Another level of abstraction/indirection can be confusing
    - 'Where' am I?
    - Where are my files?
 - Can run into host-container incompatibilities (e.g., MPI, GPUs)
 - Limitations in going between CPU architectures (e.g., x86_64 versus ARM)

# Docker vs. Singularity (1)

What is Docker?

- Open-source computer software that encapsulates an application and all its dependencies into a single image, as a series of layers 
- Brings containerization to the individuals on their own machines
- Rich image repository
- Widely used by scientific communities
- Security concerns make it unsuitable for the HPC environment
- By default you are root in the container

# Docker vs. Singularity (2)

What is Singularity?

- Open-source computer software that encapsulates an application and all its dependencies into a single image, as a single file
- Brings containerization to Linux clusters and HPC
- Developed at LBL by Greg Kurtzer
- Typically users have a machine on which they have admin privileges and can build images but *don't* have admin privileges where the containers are run
- You are yourself (from the host machine) in the container

# Docker vs. Singularity (3)

How can Singularity leverage Docker?

 - Create and run a Singularity container based on a Docker image
      - From DockerHub
      - By archiving a Docker image (and transferring to Savio)
- Create Singularity images by running Singularity in a Docker container

# Examples of where containers are used

- Kubernetes runs pods based on Docker images
- MyBinder creates an executable environment by building a Docker image
- You can have GitHub Actions and Bitbucket Pipelines in a Docker container
- CodeOcean capsules are built on Docker images 

# Running pre-existing containers using Singularity

- No root/sudo privilege is needed
- Download or build immutable squashfs images/containers

```bash
singularity pull --help
```

- Pull a container from DockerHub.
```bash
singularity pull docker://ubuntu:18.04 
singularity pull docker://rocker/r-base:latest
singularity pull docker://postgres
ls -lrt | tail -n 10   # careful of your quota!
ls -l ~/.singularity
singularity cache list
```
- Now run the container
```bash
singularity run ubuntu_18.04.sif       # use downloaded image file
## alternatively, use ~/.singularity/cache
singularity run docker://ubuntu:18.04  
```

Note the change in prompt.

```bash
cat /etc/issue   # not the Savio OS!
which python     # not much here!
pwd
echo "written from the container" > junk.txt
ls -l /global/home/users/paciorek | head -n 5
exit
cat /global/home/users/paciorek/junk.txt
```

```bash
singularity run docker://rocker/r-base    # easy!
singularity run docker://postgres         # sometimes things are complicated!
```

# Other ways of running a container

- Singularity Hub: If no tag is specified, the master branch of the repository is used

```bash
$ singularity pull hello-world.sif shub://singularityhub/hello-world
$ singularity run hello-world.sif
```

Here's how one runs a Docker container (on a system where you have admin access and Docker installed):

```bash
echo $HOME
docker run -it --rm rocker/r-base bash
pwd
ls /accounts/gen/vis/paciorek    # no automatic mount of my host home directory
```


# Different ways of using a Singularity container

- **shell** sub-command: invokes an interactive shell within a container
```bash
singularity shell hello-world.sif
```
- **run** sub-command: executes the container’s runscript
```bash
singularity run hello-world.sif
```
- **exec** sub-command: execute an arbitrary command within container
```bash
singularity exec hello-world.sif cat /etc/os-release
```

Let's see what we can find out about this image:

```bash
singularity inspect -r hello-world.sif
```

# Container processes on the host system

Let's see how the container processes show up from the perspective of the host OS.

We'll run some intensive linear algebra in R.

```bash
singularity run docker://rocker/r-base:latest
```

```r
a <- matrix(rnorm(10000^2), 10000)
system.time(chol(crossprod(a)))
```

We see in `top` that the R process running in the container shows up as an R process on the host.

# Accessing the Savio filesystems and bind paths

 - Singularity allows mapping directories on host to directories within container via bind paths
 - This enables easy data access within containers
 - System-defined (i.e., automatic) bind paths on Savio
     - `/global/home/users/`
     - `/global/scratch/`
     - `/tmp`
 - User can define own bind paths: 
     - mount /host/path/ on the host to /container/path inside the container
     - `-B /host/path/:/container/path`

```bash
ls /global/scratch/paciorek/wikistats_small
singularity shell -B /global/scratch/paciorek/wikistats_small:/data hello-world.sif
ls /data
touch /data/erase-me
exit
ls -l /global/scratch/paciorek/wikistats_small
```

In general one would do I/O to files on the host system rather than writing into the container.

It is possible to create writeable containers. 

# Running containers on Savio via Slurm

You can run Singularity within an `sbatch` or `srun` session.

Here's a basic job script.

```bash
#!/bin/bash 
#SBATCH --job-name=container-test		 
#SBATCH --partition=savio2		 
#SBATCH --account=co_stat		 			
#SBATCH --time=5:00		

singularity exec hello-world.sif cat /etc/os-release
```

# Sources of container images (registries)

- [DockerHub](https://hub.docker.com)
- [SingularityHub (future is up in the air)](https://singularity-hub.org)
- [Sylabs container registry](https://cloud.sylabs.io/library)

DockerHub images are named liked this: OWNER/CONTAINERNAME:TAG.

Let's see an [example of the Continuum images](https://hub.docker.com/u/continuumio). Here's a specific example with [various tags](https://hub.docker.com/r/continuumio/miniconda3/tags).

(For images provided directly by Docker, you don't specify the OWNER.)


# Approaches to Building

 - Build a Docker image and convert
    - Convenient if you already have a Docker build file
 - Build from Singularity definition file
    - Bootstrap from another Singularity container or non-Docker base OS
    - Alows extra customization with directives

# Building a Docker container
```docker
FROM centos:7
RUN yum install -y epel-release && yum install -y cowsay
ENTRYPOINT ["/usr/bin/cowsay"]
```

See `cowsay-entrypoint` and `cowsay-cmd` in this repository.

Build the container:
```bash
docker build -t ghcr.io/nicolaschan/cowsay-entrypoint:latest -f cowsay-entrypoint .
docker build -t ghcr.io/nicolaschan/cowsay-cmd:latest -f cowsay-cmd .
```

# Running Docker container
ENTRYPOINT Docker container:
```bash
docker run ghcr.io/nicolaschan/cowsay-entrypoint hi
```

CMD Docker container (the following do the same thing):
```bash
docker run ghcr.io/nicolaschan/cowsay-cmd
docker run ghcr.io/nicolaschan/cowsay-cmd cowsay hi
```

# Pushing to Docker Registry
```bash
# use docker login to login according to the registry you are using
docker push ghcr.io/nicolaschan/cowsay-entrypoint:latest
docker push ghcr.io/nicolaschan/cowsay-cmd:latest
```
You can use the Docker container registry of your choice
or deploy your own registry: [https://docs.docker.com/registry/deploying/](https://docs.docker.com/registry/deploying/)

# Converting Docker to Singularity
- `singularity run docker://ghcr.io/nicolaschan/cowsay-entrypoint hi`
- `singularity build cowsay.simg docker://ghcr.io/nicolaschan/cowsay-entrypoint`

Reference: [https://github.com/ucb-rit/savio-singularity-template/blob/master/build_examples.md](https://github.com/ucb-rit/savio-singularity-template/blob/master/build_examples.md)

# Singularity Build Strategies
 - Install Singularity locally (demo today)
    - Requires root access on your system
 - Install Docker locally and use singularity-docker
    - https://github.com/singularityhub/singularity-docker
 - Build an image on a cloud service or continuous integration host
    - Sylabs Remote Builder: https://cloud.sylabs.io/builder

# Suggestions/Pitfalls
- Match CPU architecture of host where image is built and Savio
  - Savio is x86_64
- Savio will try to bind mount the following paths by default (from `/etc/singularity/singularity.conf`):

```
bind path = /etc/localtime
bind path = /etc/hosts
bind path = /global/scratch
bind path = /global/home/users
```

# Singularity Definition File
1. **Header**: Base to build the container off of, such as an existing Docker/Singularity/OS image
2. **Sections**: Denoted by a `%` which are executed once the container is built to configure it

Reference: https://sylabs.io/guides/3.0/user-guide/definition_files.html

# Singularity Build Example
- Building simple alpine asciiquarium image: `alpine-example.def`
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

# Rewritable/Sandbox Singularity Images
- Can be used for debugging software/images
- Prefer using a build script for reproducible builds

# Rewritable/Sandbox Demo
On Savio:
```bash
singularity build --sandbox alpine-sandbox docker://alpine
singularity shell --writable alpine-sandbox
echo "echo hi" > /bin/hi
chmod +x /bin/hi
exit
singularity build alpine-sandbox.sif alpine-sandbox/
./alpine-sandbox.sif
hi
```

Reference: https://sylabs.io/guides/3.0/user-guide/build_a_container.html#creating-writable-sandbox-directories

# Pushing to Singularity Registry
Similar to Docker registry, you can use the Singularity registry of your choice.
This can be a convenient way to manage your images and transferring them to/from Savio (but normal file transfers also work).
For details, see https://sylabs.io/guides/3.1/user-guide/cli/singularity_push.html

# Outline of MPI and GPU Containers 

 - MPI (Message Passing Interface) applications can utilize multiple nodes
 - Build and run MPI containers
    - Single node only
    - Cross multiple nodes: Rely on the MPI implementation available on the host 
 - MPI library version compatibility on the host and within containers


- Build GPU containers from a docker at NGC 
- Run GPU containers
- NVIDIA driver and CUDA version compatibility

 
# Build MPI singularity containers

- MPI application example: [mpitest.c](samples/mpitest.c)

```
[wfeinstein@n0000 singularity-test]$ cat host 
n0098.lr6
n0099.lr6

[wfeinstein@n0000 singularity]$ mpirun -np 4  --hostfile host mpitest
...
Hello, I am on n0098.lr6 rank 3/4
Hello, I am on n0098.lr6 rank 3/4
Hello, I am on n0099.lr6 rank 2/4
Hello, I am on n0099.lr6 rank 2/4
...
```

- Definition file  
[SINGULARITY-mpi3.1.0.def](samples/SINGULARITY-mpi3.1.0.def)

- Build MPI container locally
```
sudo singularity build mpi3.1.0.sif SINGULARITY-mpi3.1.0.def
```

- Transfer mpi3.1.0.sif to your preferred cluster
- Check out the container

```
[wfeinstein@n0000 singularity-test]$ singularity shell mpi3.1.0.sif         
Singularity mpi3.1.0.sif:/global/scratch/wfeinstein/singularity-test> ls /opt/
mpitest  mpitest.c  ompi

Singularity mpi3.1.0.sif:/global/scratch/wfeinstein/singularity-test> /opt/ompi/bin/mpirun --version
mpirun (Open MPI) 3.1.0

Singularity mpi3.1.0.sif:/global/scratch/wfeinstein/singularity-test> /opt/ompi/bin/mpirun -np 2 /opt/mpitest
Hello, I am on n0000.scs00 rank 0/2
Hello, I am on n0000.scs00 rank 1/2
``` 
 
# Run MPI containers

- Use MPI libraries soly within a container
- MPI tasks are launched within a container, no dependence on host, however can't expand to multiple nodes

```
[wfeinstein@n0000 singularity-test]$ singularity exec mpi3.1.0.sif  /opt/ompi/bin/mpirun -np 2 /opt/mpitest
Hello, I am on n0000.scs00 rank 0/2
Hello, I am on n0000.scs00 rank 1/2

[wfeinstein@n0000 singularity-test]$ module list
No Modulefiles Currently Loaded.
```

- Rely on the MPI implementation available on the host
- Can expand to multiple nodes 

```
[wfeinstein@n0000 singularity-test]$ mpirun -np 64 --hostfile host singularity exec mpi3.1.0.sif /opt/mpitest
...
Hello, I am on n0099.lr6 rank 34/64
Hello, I am on n0098.lr6 rank 27/64
Hello, I am on n0099.lr6 rank 41/64
Hello, I am on n0098.lr6 rank 31/64
...
[wfeinstein@n0000 singularity-test]$ module list
Currently Loaded Modulefiles:
  1) gcc/9.2.0           2) openmpi-gcc/3.1.0
```


# MPI version compatibility (1)

- Mismatch of MPI libaries on the host and within the container breaks container
- Extra caution to ensure MPI library compatibility

```
[wfeinstein@n0000 singularity-test]$ ls  *.sif
mpi2.0.4.sif  mpi3.0.1.sif  mpi3.1.0.sif  mpi4.0.1.sif

[wfeinstein@n0000 singularity-test]$ module list
Currently Loaded Modulefiles:
  1) gcc/9.2.0           2) openmpi/4.0.1-gcc

[wfeinstein@n0000 singularity-test]$ mpirun -np 4 --hostfile host singularity exec mpi3.0.1.sif /opt/mpitest
Hello, I am on n0098.lr6 rank 2/4
Hello, I am on n0098.lr6 rank 1/4
Hello, I am on n0098.lr6 rank 3/4
Hello, I am on n0098.lr6 rank 0/4

[wfeinstein@n0000 singularity-test]$ mpirun -np 4 --hostfile host singularity exec mpi4.0.1.sif /opt/mpitest
Hello, I am on n0098.lr6 rank 2/4
Hello, I am on n0098.lr6 rank 1/4
Hello, I am on n0098.lr6 rank 3/4
Hello, I am on n0098.lr6 rank 0/4

[wfeinstein@n0000 singularity-test]$ mpirun -np 4 --hostfile host singularity exec mpi2.0.4.sif /opt/mpitest
--------------------------------------------------------------------------
It looks like MPI_INIT failed for some reason; your parallel process is
likely to abort.  There are many reasons that a parallel process can
....
```

# MPI version compatibility (2)

```
[wfeinstein@n0000 singularity-test]$ module list
Currently Loaded Modulefiles:
  1) gcc/6.3.0           2) openmpi/3.0.1-gcc

[wfeinstein@n0000 singularity-test]$ mpirun -np 4 --hostfile host singularity exec mpi3.0.1.sif /opt/mpitest
Hello, I am on n0098.lr6 rank 2/4
Hello, I am on n0098.lr6 rank 3/4
Hello, I am on n0098.lr6 rank 0/4
Hello, I am on n0098.lr6 rank 1/4

[wfeinstein@n0000 singularity-test]$ mpirun -np 4 --hostfile host singularity exec mpi4.0.1.sif /opt/mpitest
[n0098.lr6:115220] PMIX ERROR: OUT-OF-RESOURCE in file client/pmix_client.c at line 225
[n0098.lr6:115220] OPAL ERROR: Error in file pmix3x_client.c at line 112
...
```

# GPU containers

 - Singularity supports NVIDIA’s CUDA GPU compute framework or AMD’s ROCm solution
 - Userspace NVIDIA driver components from the host are dynamically mounted in the container at runtime
    - --nv enables NVIDIA GPU support by providing the driver on the host
 - NVIDIA driver not present in the container image itself
 - Application built against a CUDA toolchain has a minimal host NVIDIA driver requirement
    - e.g., CUDA/11.2 requires NVIDIA driver >= R450 
 - Host driver version requirements are detailed in [NGC documentation](https://docs.nvidia.com/deploy/cuda-compatibility/index.html)


# GPU container examples

- Build PyTorch GPU container from [PyTorch Docker NGC registry](https://ngc.nvidia.com/catalog/containers/nvidia:pytorch)

```
docker pull nvcr.io/nvidia/pytorch:21.03-py3:21.03-py3
singularity build pytorch_21.03_py3.sif docker-daemon://nvcr.io/nvidia/pytorch:21.03-py3
```

- Run PyTorch on a GPU node

```
[wfeinstein@n0043 pytorch]$ nvidia-smi -L
GPU 0: Tesla V100-SXM2-32GB (UUID: GPU-df6fb04c-b0a4-69cc-98a2-763783d4e152)
GPU 1: Tesla V100-SXM2-32GB (UUID: GPU-3c41dc39-df54-1582-4d27-6c8454ed96c6)

[wfeinstein@n0043 singularity-test]$ nvidia-smi
Mon Apr 19 00:32:43 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.44       Driver Version: 440.44       CUDA Version: 10.2     |
...

[wfeinstein@n0043 pytorch]$ singularity exec --nv pytorch_21.03_py3.sif python -c "import torch; print(torch.__version__);print(torch.cuda.get_device_name(0)); print(torch.version.cuda)"
1.9.0a0+df837d0
Tesla V100-SXM2-32GB
11.2

[wfeinstein@n0043 singularity-test]$ singularity exec --nv ../pytorch/pytorch_19_12_py3.sif  python -c "import torch; print(torch.__version__);print(torch.cuda.get_device_name(0)); print(torch.version.cuda)"
1.4.0a0+a5b4d78
Tesla V100-SXM2-32GB
10.2
```


# Oliver's content

# Other container resources

- [San Diego supercomputing center training](https://education.sdsc.edu/training/interactive/202101_intro_to_singularity/)
- [XSEDE tutorial](https://github.com/XSEDE/Container_Tutorial)
- [Software Carpentries Docker training](https://carpentries-incubator.github.io/docker-introduction/index.html)
- [Software Carpentries Singularity training](https://carpentries-incubator.github.io/singularity-introduction/)


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
