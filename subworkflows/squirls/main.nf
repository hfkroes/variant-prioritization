#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    SQUIRLS subworkflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Implements the usage of SQUIRLS as a VCF annotator
----------------------------------------------------------------------------------------
*/

process squirls_predict_variant_effect {
    
    /* Function receives input vcf, and necessary squirls files,
    annotates all the variants for which there are available
    scores and then saves them to the designated output folder*/

    tag "${input_vcf.baseName}"
    publishDir params.o

    input:
        each input_vcf
        path squirls_cli
        path squirls_db

    output:
        path "splicing_${input_vcf.baseName}"

    script:
        """
        java -jar ${squirls_cli} annotate-vcf -f vcf -d ${squirls_db} ${input_vcf} .
        mv squirls.vcf splicing_${input_vcf.baseName}
        """

}