#!/bin/sh

# Author: Oscar Wallnoefer

# run_FTS.sh
# This script automates WGS assemblies for multiple species directories.
# Steps:
# 1. Runs FastQC for quality control of raw FASTQ files.
# 2. Trims adapters and low-quality sequences using Trimmomatic.
# 3. Assembles reads into contigs using SPAdes.

# Usage:
#   ./run_FTS.sh [--pll N | -h]
# Options:
#   --pll N   Run the pipeline with N parallel jobs (default: 1).
#   -h        Display this help message.
# Each species directory should contain paired FASTQ files. The script recognizes files with "_1.fastq" and "_2.fastq" or "_1.fq" and "_2.fq" in their names (regardless of other prefixes).

# functions
run_fastqc() {
    echo "ok, running FastQC on $1"
    mkdir -p "$1/fastqc"
    fastqc "$1"/*_1.{fastq,fq} "$1"/*_2.{fastq,fq} -o "$1/fastqc" -f fastq
}
run_trimmomatic() {
    echo "ok, running Trimmomatic on $1"
    mkdir -p "$1/trimmomatic"
    trimmomatic PE -threads 5 -phred33 \
        "$1"/*_1.{fastq,fq} "$1"/*_2.{fastq,fq} \
        "$1/trimmomatic/paired_1.fq" "$1/trimmomatic/unpaired_1.fq" \
        "$1/trimmomatic/paired_2.fq" "$1/trimmomatic/unpaired_2.fq" \
        ILLUMINACLIP:/usr/local/anaconda3/share/trimmomatic-0.39-2/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> "$1/trimmomatic/stats_trimmomatic"
}
run_spades() {
    echo "ok, running SPAdes on $1"
    mkdir -p "$1/spades"
    spades.py -o "$1/spades" \
        -1 "$1/trimmomatic/paired_1.fq" \
        -2 "$1/trimmomatic/paired_2.fq" \
        --checkpoints last -t 16
}

# Main
main_pipeline() {
    for dir in "$@"; do
        if [[ -d "$dir" && -n "$(ls "$dir"/*_1.{fastq,fq} 2>/dev/null)" && \
              -n "$(ls "$dir"/*_2.{fastq,fq} 2>/dev/null)" ]]; then
            echo "processing directory: $dir"
            run_fastqc "$dir"
            run_trimmomatic "$dir"
            run_spades "$dir"
        else
            echo "No paired FASTQ files found in $dir, Skipping."
        fi
    done
}

# Execution
echo "[INFO] Starting pipeline..."

# Parsing
parallel_jobs=1
while [[ "$1" != "" ]]; do
    case "$1" in
        --pll) shift
               parallel_jobs=$1
               ;;
        -h)    echo "Usage:"
               echo "  ./run_FTS.sh [--pll N | -h]"
               echo ""
               echo "Options:"
               echo "  --pll N   Run the pipeline with N parallel jobs (default: 1)."
               echo "  -h        Display this help message."
               echo ""
               echo "Description:"
               echo "  This script automates WGS assemblies for multiple species directories."
               echo "  Each species directory should contain paired FASTQ files (_1.fastq, _2.fastq or _1.fq, _2.fq)."
               exit 0
               ;;
        *)     echo "Invalid argument: $1"
               exit 1
               ;;
    esac
    shift
done

# Directories
species_dirs=(*/)

# Run in parallel
echo "ok, running with $parallel_jobs parallel jobs"
echo "ok, found ${#species_dirs[@]} directories"
export -f run_fastqc run_trimmomatic run_spades
parallel -j "$parallel_jobs" main_pipeline ::: "${species_dirs[@]}"
echo "END!"