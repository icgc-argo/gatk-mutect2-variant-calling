#!/usr/bin/env nextflow

/*
  Copyright (C) 2021,  Ontario Institue for Cancer Research

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

  Authors:
    Junjun Zhang
*/

nextflow.enable.dsl = 2
version = '4.1.8.0-2.0'  // package version

// universal params go here, change default value as needed
params.container = ""
params.container_registry = ""
params.container_version = ""
params.cpus = 1
params.mem = 1  // GB
params.publish_dir = ""  // set to empty string will disable publishDir

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.cleanup = true

include { demoCopyFile } from "./local_modules/demo-copy-file"
include { payloadAddUniformIds } from './wfpr_modules/github.com/icgc-argo/data-processing-utility-tools/payload-add-uniform-ids@0.1.1/main.nf' params([*:params, 'cleanup': false])
include { cleanupWorkdir } from './wfpr_modules/github.com/icgc-argo/data-processing-utility-tools/cleanup-workdir@1.0.0/main.nf' params([*:params, 'cleanup': false])
include { getSecondaryFiles; getBwaSecondaryFiles } from './wfpr_modules/github.com/icgc-argo/data-processing-utility-tools/helper-functions@1.0.0/main.nf' params([*:params, 'cleanup': false])


// please update workflow code as needed
workflow GatkMutect2VariantCalling {
  take:  // update as needed
    input_file


  main:  // update as needed
    demoCopyFile(input_file)


  emit:  // update as needed
    output_file = demoCopyFile.out.output_file

}


// this provides an entry point for this main script, so it can be run directly without clone the repo
// using this command: nextflow run <git_acc>/<repo>/<pkg_name>/<main_script>.nf -r <pkg_name>.v<pkg_version> --params-file xxx
workflow {
  GatkMutect2VariantCalling(
    file(params.input_file)
  )
}