# 1000 Genomes Chromosome 22 PCA Workflow

## Overview

This project explores genetic population structure using chromosome 22
genotype data from the 1000 Genomes Project Phase 3 reference dataset.

The workflow uses PLINK 1.9 for genotype conversion, SNP filtering,
linkage disequilibrium (LD) pruning, and principal component analysis (PCA).

This is an initial stage of a broader Coronary Artery Disease (CAD)
Polygenic Risk Score (PRS) project. CAD PRS calculation has not yet
been completed in this workflow.

## Data Sources

- [Chromosome 22 genotype VCF](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz)
- [1000 Genomes population annotation panel](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel)

Reference genome build: GRCh37.

The input files are downloaded separately and are not committed to this
repository because the genotype data is large.

## Tools

- Linux
- PLINK 1.9
- Python 3
- pandas
- matplotlib

## Workflow

1. **VCF conversion:** convert chromosome 22 genotype data to PLINK
   binary format.
2. **SNP filtering:** retain SNPs with A/C/G/T alleles and assign IDs
   to variants that lack IDs.
3. **LD pruning:** select a subset of less-correlated variants using
   `--indep-pairwise 200 25 0.2`.
4. **PCA:** calculate the first 10 principal components using PLINK.
5. **Population annotation:** join PCA coordinates with the 1000 Genomes
   population and superpopulation labels.
6. **Visualization:** plot PC1 against PC2, grouped by superpopulation.

## Run the Workflow

Place the two downloaded input files in the project root directory.
Ensure PLINK 1.9 is installed and available in your PATH.

Run:

```bash
bash scripts/run_chr22_pca.sh
```

The script writes its analysis outputs to the `results/` directory.

## Key Outputs

- `chr22_pca.eigenvec` — PCA coordinates for each individual.
- `chr22_pca.eigenval` — eigenvalues for the principal components.
- `chr22_pca_with_pop.tsv` — PCA coordinates joined with population labels.
- `chr22_pca_plot.png` — PC1 versus PC2 visualization.
- `scripts/run_chr22_pca.sh` — reproducible analysis script.
- `plot_chr22_pca.py` — Python plotting script.

## Scope and Limitations

This analysis uses chromosome 22 only. It is a practice PCA workflow
and should not be interpreted as a genome-wide ancestry analysis.

PCA describes patterns of genetic variation; it does not calculate
an individual's CAD PRS or establish their disease risk.

## Project Status

Chromosome 22 PCA workflow completed. CAD PRS calculation is a future
project stage.
EOF
