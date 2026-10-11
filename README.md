# CAD PRS: 1000 Genomes PCA Workflow

## Overview
This project explores genetic population structure using chromosome 22
genotype data from the 1000 Genomes Project Phase 3 reference dataset.

The workflow uses PLINK 1.9 for genotype conversion, SNP filtering,
linkage disequilibrium (LD) pruning, and principal component analysis (PCA).

This is an initial stage of a broader Coronary Artery Disease (CAD)
Polygenic Risk Score (PRS) project. CAD PRS calculation has not yet
been completed in this workflow.

## Data Sources
Chromosome 22 genotype VCF:
https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz

Population annotation panel:
https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel

Reference genome build: GRCh37.

## Tools
- Linux
- PLINK 1.9
- Python 3
- pandas
- matplotlib

## Workflow

### 1. Convert VCF to PLINK format
```bash
plink --vcf ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz --make-bed --out 1000G_chr22
