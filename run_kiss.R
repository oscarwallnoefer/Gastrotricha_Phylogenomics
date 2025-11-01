### total length comparisons between assemblies (spades, blobtools and redundans)

library(dplyr)
library(ggplot2)

macrodasyida <- c("Macrodasys_meristocytalis", "Anandrodasys_agadasys", "Crasiella_sp", "Thaidasys_sp", "Redudasys_fornerise", "Paradasys_sp2", "Turbanella_ambronensis", "Urodasys_acanthostylis", "Mesodasys_laticaudatus", "Paraturbanella_pallida", "Pleurodasys_sp", "Urodasys_bifidostylis", "Neodasys_sp") 
chaetonotida <- c("Lepidodermella_sp2", "Litigonotus_ghinii", "Aspidiophorus_tentaculatus", "Chaetonotus_apolemmus", "Chaetonotus_sp", "Lepidodermella_squamata2", "Lepidochaetus_zelinkai", "Aspidiophorus_sp2", "Setopus_sp", "Stylochaeta_sp", "Diuronotus_aspetos", "Chaetonotus_neptuni", "Musellifer_sp", "Heteroxenotrichula_squamosa", "Xenotrichula_intermedia", "Musellifer_sp2", "Dasydytes_carvalhoe", "Polymerurus_nodicaudus") 
oiorpata <- c("Lepidodermella_sp2", "Litigonotus_ghinii", "Aspidiophorus_tentaculatus", "Chaetonotus_apolemmus", "Chaetonotus_sp", "Lepidodermella_squamata2", "Lepidochaetus_zelinkai", "Aspidiophorus_sp2", "Setopus_sp", "Stylochaeta_sp", "Chaetonotus_neptuni", "Dasydytes_carvalhoe", "Polymerurus_nodicaudus")

assembly <- read.csv("Assembly_stats.csv", header = T, sep = ";")
assembly_red <- assembly %>%
  filter(Assembly == "redundans") %>%
  mutate(Group = case_when(Species %in% macrodasyida ~ "Macrodasyida",Species %in% chaetonotida ~ "Chaetonotida", TRUE ~ "Other"),Oiorpata_flag = ifelse(Species %in% oiorpata, "Oiorpata", "Non-Oiorpata"))

ggplot(assembly_red, aes(x = Group, y = Total.length, fill = Group)) +
  geom_violin(alpha = 0.5) +
  geom_jitter(aes(color = Oiorpata_flag), width = 0.2, size = 2) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  labs(
    y = "Total Length (bp)",
    x = "Group",
    title = "Distribution of Total Length for Redundans Assemblies"
  ) +
  scale_fill_manual(values = c("Macrodasyida" = "red", "Chaetonotida" = "blue", "Other" = "grey")) +
  scale_color_manual(values = c("Oiorpata" = "orange", "Non-Oiorpata" = "black"))

kruskal_test <- kruskal.test(Total.length ~ PointGroup, data = assembly_red)

# Kruskal-Wallis rank sum test
# Kruskal-Wallis chi-squared = 3.8128, df = 2, p-value = 0.1486

### violin plot of total length 
library(ggplot2)
library(dplyr)
library(scales)

### violin total length
assembly <- read.csv("Assembly_stats.csv", header = TRUE, sep = ";")
assembly_red <- assembly_red %>%
  mutate(
    Group = factor(Group, levels = c("Macrodasyida", "Chaetonotida")),
    Oiorpata_flag = ifelse(Species %in% oiorpata, "Oiorpata", "Non-Oiorpata")
  )

ggplot() +
  geom_violin(data = assembly_red, aes(x = 1, y = Total.length),
              fill = "lightgray", alpha = 0.5, trim = FALSE) +
  geom_boxplot(data = assembly_red, aes(x = 1, y = Total.length, fill = Group),
               width = 0.25, alpha = 0.7, notch = F, position = position_dodge(width = 0.3)) +
  geom_jitter(data = assembly_red, aes(x = 1, y = Total.length, color = Group),
              size = 3, position = position_dodge(width = 0.3)) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Macrodasyida" = "darkblue", "Chaetonotida" = "steelblue")) +
  scale_color_manual(values = c("Macrodasyida" = "darkblue", "Chaetonotida" = "steelblue")) +
  theme_minimal() +
  labs(
    y = "Total Length (bp)",
    x = "",
    title = ""
  ) +
  theme(legend.position = "right")