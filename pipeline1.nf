#!/usr/bin/env nextflow

hs2_indices = Channel
       .fromPath("${params.hisat2_index}*")
       .ifEmpty { exit 1, "HISAT2 index not found: ${params.hisat2_index}" }

fasta_refs = Channel
       .fromPath("${params.fasta_ref}*")
       .ifEmpty { exit 1, "FASTA reference not found: ${params.fasta_ref}" }

Channel
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }  
    .set { read_pairs }

/*
 *https://github.com/nf-core/rnaseq/blob/master/main.nf
 */
process mapping {
    input:
    file hs2_indices from hs2_indices.collect()
    set pair_id, files from read_pairs
    
    output:
    set pair_id, "mapped.bam" into bam_files
    
    script:
    index_base = hs2_indices[0].toString() - ~/.\d.ht2l?/
    """
    hisat2 -q -x  $index_base --threads params.threads -1 ${files[0]} -2 ${files[1]} | samtools view -Sb > mapped.bam
    """
}


process sort {
    input:
    set pair_id, bam_file from bam_files
    
    output:
    set pair_id, "sorted.bam" into sorted
    
    script:
    """
    samtools sort ${bam_file} -@ params.threads  > sorted.bam
    """
}


process cram {
    input:
    file refs from fasta_refs.collect()
    
    set pair_id, f from sorted
    
    output:
    set pair_id, "sorted.cram" into cram
    
    script:
    ref = refs[0].toString()
    """
    samtools view -C -T $ref ${f} -@ params.threads > sorted.cram
    """
}

process lossy {
    publishDir "results"
    
    input:
    set pair_id, f from cram
    
    output:
    set pair_id, "lossy.cram" into lossy
    
    script:
    """    
    $crumble -I CRAM -O cram,lossy_names,seqs_per_slice=100000 ${f} > lossy.cram
    """
}


