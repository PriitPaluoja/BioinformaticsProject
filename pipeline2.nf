#!/usr/bin/env nextflow

hs2_indices = Channel
       .fromPath("${params.hisat2_index}.*ht2")
       .ifEmpty { exit 1, "HISAT2 index not found: ${params.hisat2_index}" }


fasta_refs = Channel
       .fromPath("${params.fasta_ref}*")
       .ifEmpty { exit 1, "FASTA reference not found: ${params.fasta_ref}" }


crams = Channel
        .fromPath("${params.crams}*.cram")
        .ifEmpty { exit 1, "FASTA reference not found: ${params.crams}" }

crams_indices = Channel
            .fromPath("${params.crams}*.crai")
            .ifEmpty { exit 1, "FASTA reference not found: ${params.crams}" }


process bam {
    time '7h'
    memory '16 GB'
    cpus 5
    
    publishDir "final"

    input:
    file f from crams
    file refs from fasta_refs.collect()
    file cram_ind from crams_indices.collect()
    file hs2_indices from hs2_indices.collect()

    output:
    file "*.bam" into bam_files

    script:
    ref = refs[0].toString()
    index_base = hs2_indices[0].toString() - ~/.\d.ht2l?/
    fasta_base = refs[0].toString() - ~/.\d.fai?/
    """
    
    java -Dsamjdk.reference_fasta=$fasta_base -Xmx8G -jar $bazam -bam ${f} | hisat2 -q -x $index_base --threads 5 -U - | samtools view -Sb -@ 5 > ${f.baseName}.bam
    """
}


