#!/usr/bin/env nextflow


params.hisat2_index = "/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly.*.*"
params.reads = "/gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/ERR188021_{1,2}.fastq.gz"
params.threads = 10

hs2_indices = Channel
       .fromPath("${params.hisat2_index}*")
       .ifEmpty { exit 1, "HISAT2 index not found: ${params.hisat2_index}" }

/*
 * Creates the `read_pairs` channel that emits for each read-pair a tuple containing
 * three elements: the pair ID, the first read-pair file and the second read-pair file
 */
Channel
    .fromFilePairs( params.reads )                                             
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }  
    .set { read_pairs }

/*
 *https://github.com/nf-core/rnaseq/blob/master/main.nf
 */
process mapping {    
    publishDir "results"
    
    input:
    file hs2_indices from hs2_indices.collect()
    set pair_id, files from read_pairs
  
    output:
    set pair_id, "sorted.bam" into results
  
    script:
    index_base = hs2_indices[0].toString() - ~/.\d.ht2l?/
    
    """
    module load python-3.6.3
    module load samtools-1.9
    source activate bio
    
    
    hisat2 -q -x  $index_base --threads params.threads -1 ${files[0]} -2 ${files[1]} | samtools view -Sb | samtools sort > sorted.bam
    """
}




