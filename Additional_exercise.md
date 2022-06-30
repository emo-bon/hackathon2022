## Additional Exercise!

Not everyone will complete the Hands-on exercise at the same pace; so this additional exercise is for those who would like to know more about how to use Docker.

Log in to `ceta.ualg.pt` as before, if you are not already connected. Previously, we submitted our work to the SLURM queue using a script that specifies how the job is run - this is the typical way of doing work on an HPC. However, it is also possible to open up an interactive session on one of the compute nodes, which is what we will do in this exercise. Execute the following command, which will open a session on compute node ceta4:

```
srun -w ceta4 -N 1 -n 1 --pty bash -i

```

Your prompt should now say `@ceta4 ~]` instead of `@ceta ~]`

## More about Docker
In the [fastp tool workflow](tools/fastp/fastp.cwl) we used previously, the following command downloaded the [fastp Docker image](https://hub.docker.com/r/microbiomeinformatics/pipeline-v5.fastp), which as part of `pipeline-v5` from the [microbiomeinformatics](https://hub.docker.com/u/microbiomeinformatics) repositiory on [DockerHub](https://hub.docker.com/): 

```
hints:
    DockerRequirement:
        dockerPull: microbiomeinformatics/pipeline-v5.fastp:0.20.0
```

In fact, what happens is that the image is downloaded only once and stored in a local Docker repository. Each time Docker is required to use an image it first looks in this repository for the requested image, and only if it is missing will it then download it from DockerHub (or whatever repository is specified). This obviously saves a lot of unnecessary bandwidth and time in repeating the download.

In this exercise, intead of using the `microbiomeinformatics/pipeline-v5.fastp:0.20.0` container image obtained from DockerHub, we are going to build our own Docker container image for `fastp` using the source code, and perform the same analysis as was done by the [fastp tool workflow](tools/fastp/fastp.cwl). You might want to do this if the verion of the software you want to use doesn't have a Docker image: in fact the `fastp` version that is used by the workflow from DockerHub is `v.0.20.0` whereas `v0.23.2` was released in December 2021, six months ago at the time of writing.


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

Now we are going to build the new `fastp` image and give it a unique name (a tag) - use you own name so that you can identify the image in the local repository. The `docker build` command autotmatically looks for a file named `Dockerfile` in the current directory:

```
docker build -no-cache -t fastp-<your name> .

```

`e.g. docker build --no-cache -t fastp-cymon .` It will take a few minutes to build the new image. The `--no-cache` command forces Docker to rebuild the image from new, rather than use an image that may have already been built by one of your fellow students. 

Once the image is built, you can issue the following command to see the new image in the local Docker repository:

```
docker images

```

You can check that the your new `fastp` Docker image works by issuing the following command that displays the `fastp` help information:

```
docker run -it --rm -v "$PWD:$PWD" -w "$PWD" fastp-<your name> --help

```
The last command is a bit complex: `-it` means run interactibly if needed; `--rm` means remove the running container after the command has executed; `-w "$PWD:$PWD"` attaches the current working directory to the running container so that data/files can be passed in and out of the container; `-w $PWD` specifies the current directory as the working directroy; and finally we envoke the new `fastp` image and run the command "--help"

Because the new fastp container only `sees` the current working directory and not the entire directory tree, all the data files needed to execute the command must be in the current working directory (see `v "$PWD:$PWD" -w "$PWD"` in the above command).

Here we copy the raw sequence reads data files to the current directory so that we can feed them into the conatiner.

```
cp ../input_files/wgs-paired-SRR1620013_* .

```

OK, so we are ready to execute the same 'fastp' command as we previously did with the `fastp.cwl` workflow (remember to specify your named image):

```
docker run -it --rm -v "$PWD:$PWD" -w "$PWD" fastp-<your name> \
    -i wgs-paired-SRR1620013_1.fastq.gz \
    -I wgs-paired-SRR1620013_2.fastq.gz \
    -o wgs-paired-SRR1620013_1.fastq.fastp.fastq \
    -O wgs-paired-SRR1620013_2.fastq.fastp.fastq \
    --length_required 70 \
    --thread 2
    
```

Check the output and compare it to the workflow output; they should be the same!





        
        
