#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process testProcess {
  label 'test'
  publishDir "${params.output}", mode: 'copy'

  output:
  path('test.txt')

  script:
  """
  echo "testProcess Output" > test.txt
  """
}

workflow {
  if (params.concurrentworkers > 0) {
    Channel.from( 0..params.concurrentworkers ) | testConcurrentProcess
  } else {
    testProcess()
  }
}


process testConcurrentProcess {
  container = "ubuntu:latest"
  machineType='f1-micro'
  disk='10 GB'

  input:
    val n
  publishDir "${params.output}", mode: 'copy'

  output:
  path("test_${n}.txt")

  script:
  """
  echo "testProcess ${n}  Output" > "test_${n}.txt"
  """
}