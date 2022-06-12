#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 2
    ramMin: 500

hints:
  DockerRequirement:
    dockerPull: microbiomeinformatics/pipeline-v5.seqprep:v1.2

baseCommand: [ SeqPrep ]

inputs:
 forward_reads:
   type: File?
   label: first read input fastq
   inputBinding:
     prefix: -f
 reverse_reads:
   type: File?
   label: second read input fastq
   inputBinding:
     prefix: -r
 namefile: File?

arguments:
 - "-1"
 - forward_unmerged.fastq.gz
 - "-2"
 - reverse_unmerged.fastq.gz
 - valueFrom: |
     ${ return inputs.namefile.nameroot.split('_')[0] + '_MERGED.fastq.gz' }
   prefix: "-s"


outputs:
  merged_reads:
    type: File
    outputBinding:
      glob: '*_MERGED*'
  forward_unmerged_reads:
    type: File
    outputBinding:
      glob: forward_unmerged.fastq.gz
  reverse_unmerged_reads:
    type: File
    outputBinding:
      glob: reverse_unmerged.fastq.gz

doc: >
  SeqPrep is a program to merge paired end Illumina reads that are overlapping into a single
  longer read. It may also just be used for its adapter trimming feature without doing any paired
  end overlap. When an adapter sequence is present, that means that the two reads must overlap (in most cases)
  so they are forcefully merged. When reads do not have adapter sequence they must be treated
  with care when doing the merging, so a much more specific approach is taken. The default
  parameters were chosen with specificity in mind, so that they could be ran on libraries where
  very few reads are expected to overlap. It is always safest though to save the overlapping
  procedure for libraries where you have some prior knowledge that a significant portion of
  the reads will have some overlap.

label: Tool for stripping adaptors and/or merging paired reads with overlap into single reads.

