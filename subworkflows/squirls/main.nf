#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    SQUIRLS subworkflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Implements the usage of SQUIRLS v2.0.0 as a VCF annotator
----------------------------------------------------------------------------------------
*/

process predict_variant_effect {
    
    /* Function receives input vcf, and necessary squirls files,
    annotates all the variants for which there are available
    scores and then saves them to the designated output folder*/

    label 'inSeries'

    input:
        tuple val(vcf_name), path(input_vcf), path(squirls_db)

    output:
        path "${input_vcf.baseName}.vcf"

    script:
        """
        java -jar /squirls-cli-2.0.0.jar annotate-vcf --threads ${params.t} -f vcf -d ${squirls_db} ${input_vcf} .
        mv squirls.vcf ${input_vcf.SimpleName}.vcf
        """

}

workflow squirls {

  // SQUIRLS subworkflow

  take:
    spliceai_results
    squirls_db
 
  main: 
    squirls_results = predict_variant_effect(spliceai_results.combine(squirls_db))

  emit: 
    squirls_results

}