# Instructions for the hands-on session of the EMO BON hackathon 2022


## Data Provenance

Throughout this exercise, note down the provenance information (metadata) that you think is relevant for each step. At the end of the session we will have a discussion of what should be included in the provenance metadata for the outputs of the workflow that are published/shared with others.

## Log in into the CCMAR HPC cluster

To log in to your account, please open a terminal and run 

```bash=
    ssh <username>@ceta.ualg.pt
```

Once you are logged in, you may check your present working directory and what is in there: 

    pwd
    /home/<username>
    ls
    

## Clone the emo-bon/Hackathon2022 GitHub repository

Use the [GIT version control system](https://git-scm.com/) to copy/clone the `hackathon2022` repository to your home directory:


    git clone https://github.com/emo-bon/hackathon2022.git

Once you have downloaded the repo, you may see what's there by moving into it and listing the files and folders. 

    cd hackathon2022
    ls
    Additional_exercise.md  Commands_Cheatsheet.md  Docker  hack_wf.cwl  hack_wf.yml  handson_instructions.md  input_files  README.md  slurm-example.sh  tools


Navigate to the `input_files` folder where you will find a small metagenomic sequencing sample. 
There are two files: one with the forward reads, and another with the reverse reads, of the sample. 
This indicates that the data are from a [paried-end sequencing](https://www.illumina.com/science/technology/next-generation-sequencing/plan-experiments/paired-end-vs-single-read.html) Illumina sequencing experiment.

Under the `hackathon22/tools` folder, you will find two commonly-known bioinformatics software:
- [fastp](https://github.com/OpenGene/fastp): for fast, all-in-one preprocessing for [`.fastq`](https://en.wikipedia.org/wiki/FASTQ_format) formatted sequence read files
- [SeqPrep](https://github.com/jstjohn/SeqPrep): to merge paired-end Illumina reads that are overlapping into a single longer read.

For each of these pieces of software, you will find a folder: within which is a workflow written in the [Common Workflow Language]( https://www.commonwl.org/) in a file with a `.cwl` extension, and a corresponding [YAML](https://en.wikipedia.org/wiki/YAML) `.yml` configuration file. Take a look at the contents of these files using the `more` command:

    more <filename>

Under the [`hackathon22/input_files`](https://github.com/emo-bon/hackathon2022/tree/main/input_files) folder you can see that the two data input files that are are described in the YAML configuration file.

Take a look at the contents of these files using the `gunzip` and the `more` commands 
(use the spacebar to display more of the file when necessary and `q` to quit):

    gunzip <filename>
    more <filename>

When, you have finished looking at the files, you need to re-compress them using the `gzip` command

    gzip <filename>

<!--- Haris to explain
Note how the prefix names (e.g. `wgs-paired-SRR1620013_1`) of the output files are taken from the original input sequence files described in the YAML file through a name variable (e.g. `$(inputs.fastq1.nameroot`).
--->

Under the `Docker` folder there is a `Dockerfile` that will be discussed later (maybe!). 

Finally, in the top-level directory (called `hackathon2022`) you will find the files [`hack_wf.cwl`](https://github.com/emo-bon/hackathon2022/blob/main/hack_wf.cwl) and its corresponding [`.yml`](https://github.com/emo-bon/hackathon2022/blob/main/hack_wf.yml) file: 
these describe the two-step workflow that we will run in this hackathon, 
and which will invoke the software `fastp` and `SeqPrep`. 
Take a look at these files and note how data flow in and out of first `fastp` then `SeqPrep`.

Last but not least, at the top level of the repo, you will also find the [`slurm-example.sh`](https://github.com/emo-bon/hackathon2022/blob/main/slurm-example.sh) script
that you will use as a template to submit jobs on the cluster. 

> At the top level of this repo, you will also find the [`Commands_Cheatsheet.md`](https://github.com/emo-bon/hackathon2022/blob/main/Commands_Cheatsheet.md) with some basic commands that you can always use if you need any help and the [Additional_exercise.md](https://github.com/emo-bon/hackathon2022/blob/main/Additional_exercise.md) file with an extra exercise focusing on Docker. 


## Running the `fastp` tool on its own 

First, we will run a single tool. Navigate to the [`tools/fastp`](https://github.com/emo-bon/hackathon2022/tree/main/tools/fastp) directory.

View the `.cwl` script using the `nano` editor and note the `CommandLineTool` flag in the `class` argument at the very top of the file. 
(Note that the `^` character in `nano` signifies the CONTROL key.) 

In the `hints` section, check the `DockerRequirement` flag: the [dockerPull](https://docs.docker.com/engine/reference/commandline/pull/) command fetches the corresponding software from DockerHub. 
Can you find the `microbiomeinformatics/pipeline-v5.fastp:0.20.0` Docker image on [DockerHub](https://hub.docker.com)? 
(if not, [here](https://hub.docker.com/r/microbiomeinformatics/pipeline-v5.fastp) it is).

Now, let's run the `fastp` tool. 
Copy the [`slurm-example.sh`](https://github.com/emo-bon/hackathon2022/blob/main/slurm-example.sh) file to the current [`fastp`](https://github.com/emo-bon/hackathon2022/tree/main/tools/fastp) folder, giving it a specific name for the specific job to run:

    # current working directory is the top level of the repo, i.e. /home/<username>/hackathon2022
    cp slurm-example.sh tools/fastp/slurm-fastp.sh
    cd tools/fastp/

Using the `nano` editor, add the following command to the `slurm-fastp.sh` file and give the job a <9 letter name: 

   cwltool fastp.cwl fastp.yml

Next submit the job to the [SLURM](https://slurm.schedmd.com/documentation.html) queue:

     sbatch slurm-fastp.sh
   
(Note: you can monitor the progress of your job using the `squeue` command - but it will only take ~10 seconds.)

Once the job is finished, let's see the outcome! 

     ls 
    fastp.html  fastp.json wgs-paired-SRR1620013_1.fastq.fastp.fastq  wgs-paired-SRR1620013_2.fastq.fastp.fastq ..

Open a new terminal and download `fastp.html` to your local machine using the secure-copy command `scp` (or any other file transfer sotfware you have installed) and open it in a web-browser.

    scp <username>@ceta.ualg.pt:~/hackathon2022/tools/fastp/fastp.html .


The results are also recorded in [JSON](https://www.json.org/json-en.html) format: `fastp.json`. JSON is a machine operable format and can be read and manipulated by programming languages. The following command extracts the command used to execute `fastp`:

    python3 -c "import json; print(json.load(open('fastp.json'))['command'])"
    
Make sure you understand how the command was built from the `.cwl` and `.yml` files.


## Run the two-step workflow 

Move to the top-level directry (`hackathon2022`). 
Let us review the [`hack_wf.cwl`](https://github.com/emo-bon/hackathon2022/blob/main/hack_wf.cwl) script there. 

The class of this `.cwl` workflow is `Workflow` and not `CommandLineTool` that was used when we were only running a single software (e.g. in fastp.cwl). An extra section is present in this CWL file; in the section `steps` we invoke the two pieces of software that are in the [`tools`](https://github.com/emo-bon/hackathon2022/tree/main/tools) folder. 
   * Can you see how the output of the `fastp` tool is provided as in input in the `SeqPrep` ? 

Let us now run the workflow. Write another SLURM queue submission script with the following command and submit it to the queue: 

    cwltool --outdir 2step-wf hack_wf.cwl hack_wf.yml

The job will take ~20secs, once completed, check the output directory!


## Edit the `.yml` script of the workflow and run again


Multiple parameters can be set even in this short, 2-step workflow. 

During the hands-on, we will discuss some of those and each one of you
will edit a parameter. 

Then we will run again the workflow and see what happens! 



