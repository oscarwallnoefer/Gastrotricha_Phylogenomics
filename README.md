<h1>
  Gastrotricha <img src="Lepidodermella_squamata.png" width="50" height="50" style="vertical-align: middle; margin: 0 0;">Phylogenomics
</h1>

This is main code used in `Towards a Phylogenomics of Gastrotricha`. 

DOI: 

Authors: `Wallnoefer Oscar`, `Kosakyan Anush`, `Todaro M. Antonio`, `Plazzi Federico`

Zenodo:

Dryrad:

Structure:

```
.
├── run_fts.sh         	   # fastQC, Trimmomatic and SPAdes
├── run_blobtools.sh       # Diamond + BlobTools
├── run_filt.py            # filter contaminants RNAseq 
├── run_concordance.R      # analyse concordance factor 
├── run_kiss.R             # plot genome size distribution
├── run_rf.R               # plot Robinson-Fould distances
├── run_acr.R              # plot ancestral state
└── run_missing.R          # identify missing genes and Venn plot
```

### Abstract

Gastrotricha are microscopic acoelomate worms that play key ecological roles in marine and freshwater meiobenthic communities. For a long time, their relationships have been inferred primarily from morphology, or from molecular studies based on only a few genes, due to the scarcity of genomic resources. Here we analyzed 221 nuclear loci from 31 species spanning nine families (including 28 newly assembled genomes), providing the first phylogenomic framework for the phylum. Our results support the deep split between the two main orders, Macrodasyida and Chaetonotida, and clarify the long-debated position of Neodasys, which is consistently recovered as sister to Macrodasyida. Within Chaetonotida, our analyses confirm the monophyly of the recently established clade Oiorpata. Phylogenetic mapping indicates a single marine-to-freshwater transition within Oiorpata. Since all oiorpatans are parthenogenetic, this suggests that the pre-existing reproductive mode may have facilitated the colonization of freshwater environments. Comparative genomic analyses reveal that Chaetonotida genomes have lost a defined set of conserved BUSCO genes, 9.6% in Muselliferidae + Xenotrichulidae and up to 11.2% in Oiorpata, indicating a broader genomic reorganization within the order. Together, these results provide both confirmation and new insights into the evolutionary history of Gastrotricha, demonstrating how expanding genomic datasets in understudied meiofaunal lineages can uncover hidden dimensions of metazoan genome evolution and diversification.
