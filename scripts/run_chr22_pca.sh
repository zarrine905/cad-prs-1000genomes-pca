#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Project: CAD PRS - 1000 Genomes chromosome 22 PCA
# Purpose: Practice genotype processing and PCA with PLINK 1.9
# Reference build: GRCh37
# Dataset: 1000 Genomes Project Phase 3
# ==========================================================

# Run this script from the project root directory.
VCF="ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"
PANEL="integrated_call_samples_v3.20130502.ALL.panel"
OUTDIR="results"

# Check dependencies and input files.
command -v plink >/dev/null 2>&1 || {
    echo "ERROR: PLINK is not installed or is not in PATH."
    exit 1
}

[[ -f "$VCF" ]] || {
    echo "ERROR: Missing input VCF: $VCF"
    exit 1
}

[[ -f "$PANEL" ]] || {
    echo "ERROR: Missing population panel: $PANEL"
    exit 1
}

mkdir -p "$OUTDIR"

echo "Step 1/5: Convert VCF to PLINK binary format..."
plink \
    --vcf "$VCF" \
    --make-bed \
    --out "$OUTDIR/1000G_chr22"

echo "Step 2/5: Keep SNPs and assign IDs to variants missing IDs..."
plink \
    --bfile "$OUTDIR/1000G_chr22" \
    --snps-only just-acgt \
    --set-missing-var-ids '@:#:$1:$2' \
    --make-bed \
    --out "$OUTDIR/1000G_chr22_snps"

echo "Step 3/5: Perform linkage disequilibrium pruning..."
plink \
    --bfile "$OUTDIR/1000G_chr22_snps" \
    --indep-pairwise 200 25 0.2 \
    --out "$OUTDIR/chr22_prune"

echo "Step 4/5: Create the LD-pruned dataset..."
plink \
    --bfile "$OUTDIR/1000G_chr22_snps" \
    --extract "$OUTDIR/chr22_prune.prune.in" \
    --make-bed \
    --out "$OUTDIR/chr22_pruned"

echo "Step 5/5: Calculate 10 principal components..."
plink \
    --bfile "$OUTDIR/chr22_pruned" \
    --pca 10 \
    --out "$OUTDIR/chr22_pca"

echo "Creating population annotation table..."
awk 'BEGIN {OFS="\t"}
    NR > 1 {print $1, $2, $3, $4}
' "$PANEL" > "$OUTDIR/population_labels.tsv"

echo "Joining PCA coordinates with population labels..."
awk 'BEGIN {FS="[ \t]+"; OFS="\t"}
    NR == FNR {
        pop[$1] = $2
        super[$1] = $3
        next
    }
    {
        printf "%s\t%s\t%s\t%s", $1, $2, pop[$2], super[$2]
        for (i = 3; i <= NF; i++) printf "\t%s", $i
        printf "\n"
    }
' "$OUTDIR/population_labels.tsv" "$OUTDIR/chr22_pca.eigenvec" \
    > "$OUTDIR/chr22_pca_with_pop.tsv"

echo "Checking number of PCA samples..."
wc -l "$OUTDIR/chr22_pca_with_pop.tsv"

echo "Checking for missing population labels..."
awk -F '\t' '
    $3 == "" || $4 == "" {n++}
    END {print "Rows with missing labels:", n+0}
' "$OUTDIR/chr22_pca_with_pop.tsv"

echo "PCA workflow completed successfully."
echo "Results are saved in: $OUTDIR/"
EOF
