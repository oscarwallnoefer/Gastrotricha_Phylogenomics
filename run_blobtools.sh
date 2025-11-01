#!/bin/bash
# Author: Oscar Wallnoefer

# This script automates the process for BlobTools analysis.
# Steps:
# 1. Indexes scaffolds with BWA.
# 2. Maps paired reads to scaffolds and processes SAM/BAM files with SAMtools.
# 3. Runs DIAMOND BLASTx on scaffolds.
# 4. Filters DIAMOND results and separates entries with 'N/A'.
# 5. Creates and views BlobTools databases.
#
# Usage:
#   ./blobtools.sh [--pll N]
# Options:
#   --pll N   Run the pipeline with N parallel jobs (default: 1).
#   -h        Show this help message.
#
# Each species directory should contain a `scaffolds.fasta` in `03_SPAdes/` and paired reads in the main directory.

# Define functions
run_blobtools() {
    echo "Running BlobTools pipeline on $1"
    mkdir -p "$1/04_BlobTools"
    cd "$1/04_BlobTools" || exit

    # Step 1
    bwa index ../03_SPAdes/scaffolds.fasta
    # Step 2
    bwa mem ../03_SPAdes/scaffolds.fasta ../paired_1.fq ../paired_2.fq > reads.sam
    samtools view -Sb reads.sam | samtools sort -o reads.sorted.bam
    samtools index reads.sorted.bam
    # Step 3
    diamond blastx -d /path/to/nr.dmnd -q ../03_SPAdes/scaffolds.fasta -o scaffolds.diamond.out --threads 8 --outfmt 6 qseqid staxids bitscore sscinames sskingdoms stitle
    # Step 4
    grep -v 'N/A' scaffolds.diamond.out > scaffolds_filtered.diamond.out
    grep 'N/A' scaffolds.diamond.out > nan_scaffolds.diamond.out
    # Step 5
    blobtools create -i ../03_SPAdes/scaffolds.fasta -y spades -t scaffolds_filtered.diamond.out \
        --bam reads.sorted.bam \
        --nodes /path/to/blobtools_dbs/nodes.dmp \
        --names /path/to/blobtools_dbs/names.dmp \
        --title "$1" --out create_bbt
    blobtools view -i create_bbt.*.blobDB.json -o view_bbt
    cd - || exit
}

# pipeline
main_pipeline() {
    for dir in "$@"; do
        if [[ -d "$dir/03_SPAdes" && -f "$dir/03_SPAdes/scaffolds.fasta" && \
              -f "$dir/paired_1.fq" && -f "$dir/paired_2.fq" ]]; then
            echo "ok, run $dir"
            run_blobtools "$dir"
        else
            echo "files not found in $dir, skipping"
        fi
    done
}

# execute
# Parse arguments
parallel_jobs=1
while [[ "$1" != "" ]]; do
    case "$1" in
        --pll) shift
               parallel_jobs=$1
               ;;
        -h)    echo "Usage: ./blobtools.sh [--pll N]"
               echo "Options:"
               echo "  --pll N   Run the pipeline with N parallel jobs (default: 1)."
               echo "  -h        Show this help message."
               exit 0
               ;;
        *)     echo "Invalid argument: $1"
               exit 1
               ;;
    esac
    shift
done

# Get list of directories
species_dirs=(*/)
# Run parallel
echo "ok, running with $parallel_jobs parallel jobs"
echo "ok, found ${#species_dirs[@]} directories"
export -f run_blobtools
parallel -j "$parallel_jobs" main_pipeline ::: "${species_dirs[@]}"

echo "END!"

