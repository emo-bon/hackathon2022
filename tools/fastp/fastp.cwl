#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.2

label: fastp

hints:
    DockerRequirement:
        dockerPull: microbiomeinformatics/pipeline-v5.fastp:0.20.0

baseCommand: [ fastp ]


# If you need to manipulate input parameters, include the requirement InlineJavascriptRequirement 
# and then anywhere a parameter reference is legal you can provide a fragment of Javascript that will be evaluated by the CWL runner.
# Note: JavaScript expressions should only be used when absolutely necessary. 
# When manipulating file names, extensions, paths etc, consider whether one of the built in File properties like `basename`, `nameroot`, `nameext`, etc, could be used instead. 
 
arguments:
    - prefix: -o
      valueFrom: $(inputs.fastq1.nameroot).fastp.fastq
    - prefix: -O
      valueFrom: $(inputs.fastq2.nameroot).fastp.fastq

inputs:
    fastq1:
      type: File
      format:
        - edam:format_1929 # FASTQ
      inputBinding:
        prefix: -i
    fastq2:
      format:
        - edam:format_1929 # FASTQ
      type: File?
      inputBinding:
        prefix: -I
    threads:
      type: int?
      default: 1
      inputBinding:
        prefix: --thread
    min_length_required:
      type: int?
      default: 50
      inputBinding:
        prefix: --length_required
    force_polyg_tail_trimming:
      type: boolean?
      inputBinding:
        prefix: --trim_poly_g
    disable_trim_poly_g:
      type: boolean?
      default: true
      inputBinding:
        prefix: --disable_trim_poly_g
    base_correction:
      type: boolean?
      default: true
      inputBinding:
        prefix: --correction



outputs:
    out_fastq1:
       type: File
       format: $(inputs.fastq1.format)
       outputBinding:
           glob: $(inputs.fastq1.nameroot).fastp.fastq
    out_fastq2:
       type: File?
       format: $(inputs.fastq2.format)
       outputBinding:
           glob: $(inputs.fastq2.nameroot).fastp.fastq
    html_report:
      type: File
      outputBinding:
        glob: fastp.html
    json_report:
      type: File
      outputBinding:
        glob: fastp.json

$namespaces:
  edam: http://edamontology.org/
$schemas:
  - http://edamontology.org/EDAM_1.18.owl