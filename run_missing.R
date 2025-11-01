# Author: Oscar Wallnoefer

######## Presence Absence Matrix
busco_mat <- read.csv("BUSCO_presenceAbsence.tsv", row.names = 1)
dim(busco_mat)
colnames(busco_mat)
rownames(busco_mat)

# define groups
macrodasyida <- c( "Macrodasys_meristocytalis", "Anandrodasys_agadasys", "Crasiella_sp", 
                   "Thaidasys_sp", "Redudasys_fornerise", "Paradasys_sp2", 
                   "Turbanella_ambronensis", "Urodasys_acanthostylis", "Mesodasys_laticaudatus",
                   "Paraturbanella_pallida", "Pleurodasys_sp", "Urodasys_bifidostylis",
                   "Neodasys_sp" ) 
chaetonotida <- c( "Diuronotus_aspetos", "Musellifer_sp", "Heteroxenotrichula_squamosa", 
                   "Xenotrichula_intermedia", "Musellifer_sp2") 
oiorpata <- c( "Lepidodermella_sp2", "Litigonotus_ghinii", "Aspidiophorus_tentaculatus", 
               "Chaetonotus_apolemmus", "Chaetonotus_sp", "Lepidodermella_squamata2",
               "Lepidochaetus_zelinkai", "Aspidiophorus_sp2", "Setopus_sp", "Stylochaeta_sp",
               "Chaetonotus_neptuni", "Dasydytes_carvalhoe", "Polymerurus_nodicaudus" )

species <- colnames(busco_mat)
group <- ifelse(species %in% macrodasyida, "macrodasyida",
                ifelse(species %in% chaetonotida, "chaetonotida",
                       ifelse(species %in% oiorpata, "oiorpata", "Other")))
annotation <- data.frame(Group = factor(group))
rownames(annotation) <- species
busco_num <- as.matrix(busco_mat)

# plot
colors <- colorRampPalette(c("darkred", "gray"))(2)
pheatmap(busco_num, cluster_rows = TRUE, cluster_cols = TRUE, show_rownames = FALSE,
         show_colnames = TRUE, annotation_col = annotation,color = colors, main = "")

# absence function
absent_in_group <- function(group_cols) {
  apply(busco_num[, group_cols], 1, function(x) all(x == 0))
}

# find absence - presence
absent_oiorpata <- absent_in_group(oiorpata)
absent_chaetonotida <- absent_in_group(chaetonotida)
absent_macrodasyida <- absent_in_group(macrodasyida)
absent_all <- apply(busco_num, 1, function(x) all(x == 0))

# list absence per group
genes_absent_oiorpata <- rownames(busco_num)[absent_oiorpata]
genes_absent_chaetonotida <- rownames(busco_num)[absent_chaetonotida]
genes_absent_macrodasyida <- rownames(busco_num)[absent_macrodasyida]
genes_absent_all <- rownames(busco_num)[absent_all]

# percentages
total_genes <- nrow(busco_num)
percent_oiorpata <- sum(absent_oiorpata) / total_genes * 100
percent_chaetonotida <- sum(absent_chaetonotida) / total_genes * 100
percent_macrodasyida <- sum(absent_macrodasyida) / total_genes * 100
percent_all <- sum(absent_all) / total_genes * 100

# common ancestor oiorpata + chaetonotida
non_macrodasyida <- c(oiorpata, chaetonotida)
genes_absent_non_macrodasyida <- rownames(busco_mat)[rowSums(busco_mat[, non_macrodasyida]) == 0]
percent_non_macrodasyida <- length(genes_absent_non_macrodasyida) / nrow(busco_mat) * 100
cat("Non-Macrodasyida (Oiorpata + Chaetonotida):", length(genes_absent_non_macrodasyida),
    "genes absent (", round(percent_non_macrodasyida, 2), "%)\n")

######## summary table
Group Genes_absent   Percent
1         Oiorpata          107 11.215933
2     Chaetonotida           95  9.958071
3     Macrodasyida           17  1.781971
4 Non-Macrodasyida           61  6.394130
5      All_species           13  1.362683

######## pie chart
library(ggplot2)
library(gridExtra)

plot_pie <- function(absent_genes, group_name) {
  df <- data.frame(
    Status = c("Present", "Absent"),
    Count = c(total_genes - length(absent_genes), length(absent_genes))
  )
  ggplot(df, aes(x = "", y = Count, fill = Status)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar(theta = "y") +
    scale_fill_manual(values = c("Present" = "grey80", "Absent" = "red")) +
    theme_void() +
    ggtitle(group_name)
}

pie_oiorpata <- plot_pie(genes_absent_oiorpata, "Oiorpata")
pie_chaetonotida <- plot_pie(genes_absent_chaetonotida, "Chaetonotida")
pie_macrodasyida <- plot_pie(genes_absent_macrodasyida, "Macrodasyida")
pie_non_macrodasyida <- plot_pie(genes_absent_non_macrodasyida, "Non-Macrodasyida")
grid.arrange(pie_oiorpata, pie_chaetonotida, pie_macrodasyida, pie_non_macrodasyida, ncol=2)

####### venn
library(eulerr)
sets <- list(
  Macrodasyida   = genes_absent_macrodasyida,
  Chaetonotida   = genes_absent_chaetonotida,
  Oiorpata       = genes_absent_oiorpata
)
fit <- euler(sets)
plot(fit,fills = list(fill = c("aquamarine", "white", "steelblue"), alpha = 0.8),
labels = TRUE,quantities = TRUE,main = "")

####### fast presence/absence matrix

library(pheatmap)
library(RColorBrewer)

busco <- read.table("busco_presence_absence.tsv", header = TRUE, row.names = 1, sep = "\t")
col_palette <- colorRampPalette(c("white", "steelblue"))(100)

pheatmap(busco_matrix, 
color = col_palette, 
cluster_rows = TRUE, 
cluster_cols = TRUE, 
show_rownames = FALSE, 
show_colnames = TRUE,
border_color = NA,
main = "")

