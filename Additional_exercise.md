## Additional Exercise!

Not everyone will complete the Hands-on exercise at the same pace; so this additional exercise is for those who would like to know more about how to use Docker.

Log in to `ceta.ualg.pt` as before, if you are not already connected. Previously, we submitted our work to the SLURM queue using a script that specifies how the job is run - this is the typical way of doing work on an HPC. However, it is also possible to open up an interactive session on one of the compute nodes, which is what we will do in this exercise. Execute the following command, which will open a session on compute node ceta4:

```
$ srun -w ceta4 -N 1 -n 1 --pty bash -i

```

Your prompt should now say `@ceta4 ~]` instead of `@ceta ~]`

## More about Docker
In the [fastp tool workflow](tools/fastp/fastp.cwl) we use previously the following command downloaded the [fastp Docker image](https://hub.docker.com/r/microbiomeinformatics/pipeline-v5.fastp), which as part of `pipeline-v5` from the [microbiomeinformatics](https://hub.docker.com/u/microbiomeinformatics) repositiory on [DockerHub](https://hub.docker.com/): 

```
hints:
    DockerRequirement:
        dockerPull: microbiomeinformatics/pipeline-v5.fastp:0.20.0
```

In fact, what happens is that the image is downloaded only once and stored in a local Docker repository. Each time Docker is required to use an image it first looks in this repository for the requested image, and only if it is missing will it then download it from DockerHub (or whatever repository is specified). This obviouisly same a lot of unnecessary bandwidth and time in repeating the download.

In this exercise, intead of using the `microbiomeinformatics/pipeline-v5.fastp:0.20.0` container image obtained from DockerHub, we are going to build our own Docker container image for `fastp` using the source code, and perform the same analysis as was done by the [fastp tool workflow](tools/fastp/fastp.cwl).

Navigate to the `hackathon22/Docker` directory. Here you will find a file called `Dockerfile` which describes how to build the Docker container image for `fastp`. Note that by convention, all Docker image building scripts are named just `Dockerfile`.

Open the `Dockerfile` in `nano` and read the comments - in particular contrast the build commands with the commands given on the [fastp GitHub source code Repository](https://github.com/OpenGene/fastp#or-compile-from-source).

```
# v 0.1
# Dockerfile for building the fastp image

# This image uses the Apline Linux operating system
FROM alpine

# Because the Alpine Linux is a bare-bones system, first thing we need to do is
# use the APK package manager to install the basic requirements for building
# software from source code:
RUN  apk add --no-cache --update autoconf \
        automake \
        libtool \ 
        nasm \
        yasm \
        git \
        build-base \
        ; \
    \
    # Fastp has two dependencies `isa-l` and `libdeflate` that are not
    # available from the APK package repository, so we must build them
    # from the source code on Github:
    git clone https://github.com/intel/isa-l.git; \
    cd isa-l && ./autogen.sh; \
    ./configure --prefix=/usr --libdir=/usr/lib64 && make && make install; \
    \
    git clone https://github.com/ebiggers/libdeflate.git; \
    cd libdeflate && make && make install; \
    \
    #Now we can download, build and install fastp from the Github source code:
    git clone https://github.com/OpenGene/fastp.git; \
    cd fastp && make && make install; \
    cd

# This sets an environmental variable so that fastp knows where the `isa-l`
# library is installed
ENV LD_LIBRARY_PATH /usr/lib64
# This next command defines the command that is issued when the image is run:
ENTRYPOINT ["fastp"]
```





        
        
