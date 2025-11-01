library(ggplot2)
library(ggExtra)

### covariation rf - gene length
rf <- read.table("rf_distances_vs_reference_new.tsv", header = T)
summary <- read.table("M80_aln_def_summary.txt", header = T)

data <- cbind(rf, summary$Alignment_length)
names(data)[names(data) == "summary$Alignment_length"] <- "Alignment_length"

ggplot(data, aes(x = normalized_RF, y = Alignment_length)) +
  geom_point(color = "black", size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(x = "Normalized RF", y = "Alignment Length") +
  theme_classic(base_size = 14) +
  theme(aspect.ratio = 1)

ggMarginal(p, type = "density", margins = "both",
           fill = "grey80", colour = "black")

### stats
> summary(data$normalized_RF)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.2609  0.5652  0.6667  0.6513  0.7391  0.8846 
> summary(data$Alignment_length)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
38.0   118.0   155.0   175.5   226.0   418.0 

### corr
> cor.test(data$normalized_RF, data$Alignment_length)
Pearson's product-moment correlation

data:  data$normalized_RF and data$Alignment_length
t = -6.7752, df = 219, p-value = 1.131e-10
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.5196962 -0.3008305
sample estimates:
       cor 
-0.4162752 