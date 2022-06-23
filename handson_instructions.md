# Instructions for the hands-on session of the EMO BON hackathon 2022


## Log in into the CCMAR HPC cluster

To log in your student account, please open a terminal and run 

```bash=
    ssh <username>@ceta.ualg.pt
```


## Data Provenance

Throughtout this exercise, note down what provenance information (metadata) you would record so that it could be published with
the results. At the end of the session we will have a discussion of what should be included in the provenance metadata.



## Clone the emo-bon/Hackathon2022 GitHub repository

Use the [GIT version control system](https://git-scm.com/) to copy/clone the hackathon data to your home directory:


    git clone https://github.com/emo-bon/hackathon2022.git

Once you have downloaded the repo, you may see what's there by moving into it and listing the files and folders. 

    cd hackathon2022
    ls

In the `input_files` folder, you will find a partial metagenome sample. 
There are 2 files: one with the forward reads, and another with the reverse reads, of the sample. 
This indicates that the data are from a [paried-end sequencing](https://www.illumina.com/science/technology/next-generation-sequencing/plan-experiments/paired-end-vs-single-read.html) Illumina sequencing experiment.

Under the `tools` folder, you will find 2 commonly known bioinformatics software: 
    - [fastp](https://github.com/OpenGene/fastp): for fast, all-in-one preprocessing for FastQ files
    - [SeqPrep](https://github.com/jstjohn/SeqPrep): to merge paired-end Illumina reads that are overlapping into a single longer read

For each of these 2 software, you will find a folder, within which is a [Common Workflow Language]( https://www.commonwl.org/) `.cwl` file and its corresponding [YAML](https://en.wikipedia.org/wiki/YAML)`.yml` file. 


Finally, the `hack_wf.cwl` and its `.yml` file 
describe the 2-step workflow that we will run 
invoking `fastp` and `SeqPrep`. 


## Run a single tool 

First, we will run a single tool. 

Move into the `tools/` and then into the `fastp` folder.

View the `.cwl` script using the `nano` editor and pay attention to the `CommandLineTool` flag in the `class` argument. 

In the `hints` section, check the `DockerRequirement` flag 
The `dockerPull` command gets the corresponding softwares through DockerHub. 

> Can you find the `microbiomeinformatics/pipeline-v5.fastp:0.20.0` Docker image on [DockerHub](https://hub.docker.com)? 
> 

Then browse the `.yml` file and have a look into the arguments there. 

> What about the `inputs` sections of the `.cwl` and the `.yml` content? NEED TO ASK A PROPER QUESTION HERE!!


Now, let's run the `fastp` tool. Copy the `input_files/slurm-example.sh` file to the current `fastp` folder. Using the `nano` editor, add the following command to `slurm-example.sh` file, give the job a 9 letter name, and saving the file as `slurm-fastp.sh`: 

    cwltool fastp.cwl fastp.yml

Next submit the job to the SLURM queue:

    sbatch slurm-fastp.sh
    (Note: you can monitor the progress of your job using the `squeue` command.)

Once the job is finished, let's see the outcome! 

    ls 
    fastp.html  fastp.json wgs-paired-SRR1620013_1.fastq.fastp.fastq  wgs-paired-SRR1620013_2.fastq.fastp.fastq ...

> Download `fastp.html` to your local machine and open it in a web-browser. 

## Run the 2-step workflow 

Move in the zero-level of the repo. 

Let us now review the `hack_wf.cwl` script! 

The class of this `.cwl` is `Workflow` and not a `CommandLineTool`. 

An extra section is also present; in `steps` we have the 2 software tools 
that are listed in the `tools/` folder. 

> Can you see how the output of the `fastp` tool is provided as in input in the `SeqPrep` ? 

Let us now run the workflow. Write another SLURM queue submission script with the following command and submit it to the queue: 

    cwltool --outdir 2step-wf hack_wf.cwl hack_wf.yml


Once comlpeted, check on the output directory!


## Edit the `.yml` script of the workflow and run again


Multiple parameters can be set even in this short, 2-step workflow. 

During the hands-on, we will discuss some of those and each one of you
will edit a parameter. 

Then we will run again the workflow and see what happens! 



