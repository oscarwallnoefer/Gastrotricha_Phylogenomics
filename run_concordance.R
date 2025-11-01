# gCF and sCF
# similar to https://www.robertlanfear.com/blog/files/concordance_factors.html

library(viridis)
library(ggplot2)
library(dplyr)
library(ggrepel)
library(GGally)
library(entropy)

# scf <- read.table("iqtree3/00_scfl_CFs.cf.stat", header = T, skip = 14)
gcf <- read.table("iqtree2/CFs.cf.stat", header = T, skip = 14)

d <- cbind(scf$ID, scf$sCF, gcf$gCF, scf$Label)
d <- as.data.frame(d)
colnames(d) <- c("id", "x", "y", "bootstrap")

ggplot(gcf, aes(x = gCF, y = sCF, label = ID)) +
  geom_point(aes(colour = Label), size = 4) +
  scale_colour_viridis(direction = -1) +
  xlim(0, 100) +
  ylim(0, 100) +
  theme_light() +
  theme(
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11)
  ) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  geom_text_repel(max.overlaps = Inf,box.padding = 0.5,point.padding = 0.1,segment.size = 0.5)

##########
> summary(gcf$gCF)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
1.32   13.12   21.23   36.12   47.80   99.16 
> summary(gcf$sCF)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
30.86   35.77   39.51   44.45   45.54   95.09 

# correlations with branch lengths
# As long
gcf_long <- gcf %>%
  pivot_longer(
    cols = c(gCF, sCF),
    names_to = "CF_type",
    values_to = "CF_value"
  )

ggplot(gcf_long, aes(x = Length, y = CF_value, colour = CF_type)) +
  geom_smooth(aes(colour = CF_type), method = "loess", se = FALSE, linewidth = 0.5, alpha = 0.3) +
  geom_point(size = 3) +
  xlab("Branch Length") +
  ylab("Concordance Factor") +
  geom_text_repel(aes(label = ID), size = 3) +
  scale_colour_manual(
    values = c("gCF" = "black", "sCF" = "grey")
  ) +
  theme_light()

###################
> cor_gCF
Spearman's rank correlation rho

data:  gcf$Length and gcf$gCF
S = 705.59, p-value = 3.386e-08
alternative hypothesis: true rho is not equal to 0
sample estimates:
      rho 
0.8262101 

> cor_sCF
Spearman's rank correlation rho

data:  gcf$Length and gcf$sCF
S = 1722, p-value = 0.001315
alternative hypothesis: true rho is not equal to 0
sample estimates:
  rho 
0.5758621 

# test incomplete lineage sorting
chisq = function(DF1, DF2, N){
  tryCatch({
    # converts percentages to counts, runs chisq, gets pvalue
    chisq.test(c(round(DF1*N)/100, round(DF2*N)/100))$p.value
  },
  error = function(err) {
    return(1.0)
  })
}

e = gcf %>% 
  group_by(ID) %>%
  mutate(gEF_p = chisq(gDF1, gDF2, gN)) %>%
  mutate(sEF_p = chisq(sDF1, sDF2, sN))

subset(data.frame(e), (gEF_p < 0.05 | sEF_p < 0.05))

###########
# ILS_test
# A tibble: 12 × 7
# Groups:   ID [12]
ID   gCF   sCF Length       gEF_p    sEF_p Discordance
<int> <dbl> <dbl>  <dbl>       <dbl>    <dbl> <chr>      
  1    35 18.3   35.2 0.0518 0.00270     1.45e- 3 Both       
2    40 18.2   41.5 0.0294 0.000232    6.37e- 2 Gene_only  
3    41 13.1   34.2 0.0208 0.321       3.14e- 3 Site_only  
4    42 41.2   55.2 0.0432 0.320       2.94e- 2 Site_only  
5    43  1.32  32.6 0.0162 0.000137    3.95e- 4 Both       
6    44 23.5   41.1 0.0233 1           1.27e- 3 Site_only  
7    47 18.6   39.5 0.0321 0.0828      6.62e- 4 Site_only  
8    48  8.57  30.9 0.0251 0.000000105 6.24e-17 Both       
9    49 20.1   40.1 0.0232 0.0499      8.54e- 4 Both       
10    50 47.8   40.6 0.0369 0.0269      4.26e- 5 Both       
11    51 24.4   35.4 0.0641 0.00595     7.26e- 1 Gene_only  
12    52 81.1   49.8 0.215  0.00468     2.18e- 1 Gene_only  
