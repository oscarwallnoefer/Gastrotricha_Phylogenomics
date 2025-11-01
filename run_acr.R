# Author: oscar wallnoefer
# script for ancestral state reconstruction
# marine/freshwater or other discrete traits
library(ape)
library(phytools)
library(tidyverse)

# load tree
tree <- read.tree("M80.nwk")
tree <- root(tree, outgroup = "Macrostomum_cliftonense", resolve.root = TRUE)
tree <- drop.tip(tree, "Macrostomum_cliftonense")  # remove outgroup

# load traits .tsv (column: Species, Marine, Hermaphrodite, etc.)
# nb: NA will be excluded
traits <- read_tsv("char_gastrotricha.tsv", na = c("", "NA"))
head(traits)
# select trait
selected_column <- "Marine"

# Filter species
traits_filtered <- traits %>% 
  filter(Species %in% tree$tip.label)

# rename traits, remove NA
states_raw <- setNames(traits_filtered[[selected_column]], traits_filtered$Species)
states_clean <- states_raw[!is.na(states_raw)]
states_clean <- factor(states_clean, levels = c("no", "si"))

# Prune tree with valid species
tree_pruned <- drop.tip(tree, setdiff(tree$tip.label, names(states_clean)))

# Fit models
fit_er  <- fitMk(tree_pruned, states_clean, model = "ER",  pi = "fitzjohn")
fit_sym <- fitMk(tree_pruned, states_clean, model = "SYM", pi = "fitzjohn")
fit_ard <- fitMk(tree_pruned, states_clean, model = "ARD", pi = "fitzjohn")

# Compare models
AIC(fit_er, fit_sym, fit_ard)

# Stochastic character mapping
simmap_res <- simmap(fit_er, nsim = 1000)  # change model
summary(simmap_res)
cols <- setNames(c("orange", "steelblue"), levels(states_clean))
plot(summary(simmap_res), colors = cols, ftype = "i")
legend("topleft", legend = levels(states_clean),
       pch = 19, pt.bg = cols, pt.cex = 1)
plot(density(simmap_res), bty = "o")
title("")
