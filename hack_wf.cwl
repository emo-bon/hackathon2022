#!/usr/bin/env cwl-runner

# Usage: 
# cwltool hack_wf.cwl hack_wf.yml --outdir 2step-wf-output


class: Workflow
cwlVersion: v1.2

# For more about workflow requirements, you may have a look here
# https://www.commonwl.org/v1.0/Workflow.html#WorkflowStep
requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {} #  run a tool or workflow multiple times over a list of inputs. 

inputs:

    raw_data1:
      type: File
    
    raw_data2:
      type: File 

    paired_reads_length_filter: 
      type: int

steps:
  qc_step:
    run: tools/fastp/fastp.cwl
    in:
      fastq1: raw_data1
      fastq2: raw_data2
      min_length_required: paired_reads_length_filter
      base_correction: { default: false }
      disable_trim_poly_g: { default: false }
      force_polyg_tail_trimming: { default: false }
      threads: {default: 2}

    out:
      [ out_fastq1, out_fastq2, json_report, html_report  ]


  merge_reads:
    run: tools/SeqPrep/SeqPrep.cwl
    in: 
        forward_reads: qc_step/out_fastq1
        reverse_reads: qc_step/out_fastq2
        namefile: qc_step/out_fastq1
    out:
        [ merged_reads ]


outputs: 

    qc-html-report:
      type: File
      outputSource: # Specifies one or more workflow parameters that supply the value of to the output parameter.
        - qc_step/html_report

    merged-seqs:
      type: File
      outputSource: 
        - merge_reads/merged_reads
