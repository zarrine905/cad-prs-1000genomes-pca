import pandas as pd
import matplotlib.pyplot as plt

columns = [
    "FID", "IID", "Population", "Superpopulation",
    "PC1", "PC2", "PC3", "PC4", "PC5",
    "PC6", "PC7", "PC8", "PC9", "PC10"
]

df = pd.read_csv(
    "chr22_pca_with_pop.tsv",
    sep=r"\s+",
    header=None,
    names=columns
)

for group, subset in df.groupby("Superpopulation"):
    plt.scatter(
        subset["PC1"],
        subset["PC2"],
        label=group,
        alpha=0.7,
        s=12
    )

plt.xlabel("PC1")
plt.ylabel("PC2")
plt.title("1000 Genomes PCA — Chromosome 22")
plt.legend(title="Superpopulation")
plt.tight_layout()
plt.savefig("chr22_pca_plot.png", dpi=300)
plt.show()
