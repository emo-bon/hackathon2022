## Additional Exercise!

Not everyone will complete the Hands-on exercise at the same pace; so this additional exercise is for those who would like to know more about how to use Docker.

Log in to `ceta.ualg.pt` as before, if you are not already connected. Previously, we submitted our work to the SLURM queue using a script that specifies how the job is run - this is the typical way of doing work on an HPC. However, it is also possible to open up an interactive session on one of the compute nodes, which is what we will do in this exercise. Execute the following command, which will open a session on compute node ceta4:

```
srun -w ceta4 -N 1 -n 1 --pty bash -i

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


        
        
