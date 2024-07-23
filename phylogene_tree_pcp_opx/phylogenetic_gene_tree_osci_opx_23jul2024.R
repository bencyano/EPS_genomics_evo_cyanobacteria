#1.Install packages and load libraries-----
libs <- c('tidyverse', 'treeio', 'phytools', 'geiger', 'ggtree')
lapply(libs, require, character.only = TRUE)
library(readxl)
library(ape)
library(ggpubr)

#2.Import the phylogenetic gene tree of PCP and Oscillatoriales-----
phylo_tree_opx_osci_23jul2024 <- ape::read.tree("input_files/trimmed_truecopies_opx_hits_osci_aligned_ALE_06jun2024.fasta.treefile")

##2.1.Get the bootstraps values-----
phylo_tree_opx_osci_23jul2024$node.label

#3.Do a previous visualization of the phylogenetic gene tree-----

treeplot_opx_osci_23jul2024 <- ggtree(phylo_tree_opx_osci_23jul2024, layout = "equal_angle",)+
                               geom_tiplab(size=0.3)

#4.Save the previous visualization of the phylogenetic gene tree-----
ggsave("output_files/treeplot_opx_osci_23jul2024.pdf", treeplot_opx_osci_23jul2024,width = 200, height = 200, units = "mm", limitsize = FALSE )

#5.Convert the tree into a tibble data-----
osci_opx_tibble_23jul2024 <- as_tibble(phylo_tree_opx_osci_23jul2024)
View(osci_opx_tibble_23jul2024)
