# Instructions for the hands-on session of the EMO BON hackathon 2022


## Data Provenance

Throughtout this exercise, note down what provenance information (metadata) you would record so that it could be published with
the results. At the end of the session we will have a discussion of what should be included in the provenance metadata.

## Log in into the CCMAR HPC cluster

To log in to your account, please open a terminal and run 

```bash=
    ssh <username>@ceta.ualg.pt
```

## Clone the emo-bon/Hackathon2022 GitHub repository

Use the [GIT version control system](https://git-scm.com/) to copy/clone the hackathon data to your home directory:


    $ git clone https://github.com/emo-bon/hackathon2022.git

<!--- Once you have downloaded the repo, you may see what's there by moving into it and listing the files and folders. 

    cd hackathon2022
    ls
--->

Navigate to the `input_files` folder where you will find a small metagenomic sequencing sample. 
There are 2 files: one with the forward reads, and another with the reverse reads, of the sample. 
This indicates that the data are from a [paried-end sequencing](https://www.illumina.com/science/technology/next-generation-sequencing/plan-experiments/paired-end-vs-single-read.html) Illumina sequencing experiment.

Under the `tools` folder, you will find 2 commonly known bioinformatics software:
- [fastp](https://github.com/OpenGene/fastp): for fast, all-in-one preprocessing for [FastQ](https://en.wikipedia.org/wiki/FASTQ_format)  formatted sequence read files
- [SeqPrep](https://github.com/jstjohn/SeqPrep): to merge paired-end Illumina reads that are overlapping into a single longer read.

For each of these 2 software, you will find a folder, within which is a workflow written in the [Common Workflow Language]( https://www.commonwl.org/) `.cwl` file and its corresponding [YAML](https://en.wikipedia.org/wiki/YAML)`.yml` configuration file. Take a look at the contents of these files using the `more` command (use the spacebar to display more of the file when necessary):

    $ more <filename>

Notice how the names of the parameters in the YAML configuration file correspond to the inputs of the workflow. Note also how the prefix names (e.g. `wgs-paired-SRR1620013_1`) of the output files are taken from the orginal input sequence files described in the YAML file through a name variable (e.g. `$(inputs.fastq1.nameroot`).

Finally, in the top-level directory you will find the `hack_wf.cwl` and its `.yml` file  which describe a 2-step workflow that we will run invoking `fastp` and `SeqPrep`. Take a look at these files and note how data flow in and out of first `fastp` then `SeqPrep`.


## Running the `fastp` tool on its own 

First, we will run a single tool. Navigate to the `tools/fastp` directory.

View the `.cwl` script using the `nano` editor and note the `CommandLineTool` flag in the `class` argument. (Note that the `^` character in `nano` signifies the CONTROL key.) 

In the `hints` section, check the `DockerRequirement` flag: the [dockerPull](https://docs.docker.com/engine/reference/commandline/pull/) command fetches the corresponding software from DockerHub. Can you find the `microbiomeinformatics/pipeline-v5.fastp:0.20.0` Docker image on [DockerHub](https://hub.docker.com)? 

Now, let's run the `fastp` tool. Copy the `input_files/slurm-example.sh` file to the current `fastp` folder. Using the `nano` editor, add the following command to `slurm-example.sh` file, give the job a <9 letter name, and save the file as `slurm-fastp.sh`: 

    cwltool fastp.cwl fastp.yml

Next submit the job to the [SLURM](https://slurm.schedmd.com/documentation.html) queue:

    $ sbatch slurm-fastp.sh
   
(Note: you can monitor the progress of your job using the `squeue` command.)

Once the job is finished, let's see the outcome! 

    $ ls 
    fastp.html  fastp.json wgs-paired-SRR1620013_1.fastq.fastp.fastq  wgs-paired-SRR1620013_2.fastq.fastp.fastq ... etc

Download `fastp.html` to your local machine using the secure-copy command `scp` and open it in a web-browser.

    $ scp <username>@ceta.ualg.pt:~/hackathon-test/hackathon2022/tools/fastp/fastp.html .
    
At the very bottom of the `fastp.html` web-page you will see the full command that was generated from the `.cwl` and `.yml` files; make sure you understand how the command was built.

Download the [JSON](https://www.json.org/json-en.html) file to your local machine. JSON is a machine operable format and can be read and manipulated by programming languages. The following command extracts the command used to execute `fastp`:

    $ python3 -c "import json; print(json.load(open('fastp.json'))['command'])"

## Run the 2-step workflow 

Move to the top-level directry of the repo. Let us now review the `hack_wf.cwl` script! 

The class of this `.cwl` workflow is `Workflow` and not `CommandLineTool` that was used when we were only running a single software (e.g. in fastp.cwl). An extra section is also present; in `steps` we describe the 2 software tools that are in the `tools` folder. 

Can you see how the output of the `fastp` tool is provided as in input in the `SeqPrep` ? 

Let us now run the workflow. Write another SLURM queue submission script with the following command and submit it to the queue: 

    cwltool --outdir 2step-wf hack_wf.cwl hack_wf.yml

Once comlpeted, check the output directory!

NEED QUESTIONS...


## Edit the `.yml` script of the workflow and run again


Multiple parameters can be set even in this short, 2-step workflow. 

During the hands-on, we will discuss some of those and each one of you
will edit a parameter. 

Then we will run again the workflow and see what happens! 



