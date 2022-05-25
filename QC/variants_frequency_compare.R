library(ggplot2)
library(reshape2)
library(plyr)
library(cowplot)

# COMPARE ALLELE FREQUENCIES WITH OTHER STUDIES
# Look at global allele frequencies for 1000GP and ExAC
S1905PGX.westlake <- read.table("~/Desktop/mut.S1905PGX.westlake.freq.txt", header=T)
#ExAC.1000GP$freq_1000gp <- as.numeric(as.character(ExAC.1000GP$freq_1000GP))
#ExAC.1000GP$diff <- abs(ExAC.1000GP$freq_1000GP - ExAC.1000GP$freq_exac)

# Plot results 
# Calculate r2 value
westlakeR2 <- round((summary(lm(S1905PGX.westlake$S1905PGX_freq ~ S1905PGX.westlake$westlake_freq))$r.squared),digits = 2)
westlakePlot <- ggplot(data=S1905PGX.westlake, aes(x=S1905PGX_freq, y=westlake_freq)) + geom_point(alpha=0.4, size=2.5) +
  theme_bw() + xlab("S1905PGx allele frequency") + ylab("Westlake allele frequency") +
  geom_smooth(method='lm') + 
  annotate("text", size=5, color="red", x = 0.1, y = 0.95, label = paste("R2 =",westlakeR2))
westlakePlot



S1905PGX.G1000EAS <- read.table("~/Desktop/mut.S1905PGX.G1000EAS.freq.txt", header=T)

# Plot results 
# Calculate r2 value
G1000EASR2 <- round((summary(lm(S1905PGX.G1000EAS$S1905PGX_freq ~ S1905PGX.G1000EAS$G1000EAS_freq))$r.squared),digits = 2)
G1000EASPlot <- ggplot(data=S1905PGX.G1000EAS, aes(x=S1905PGX_freq, y=G1000EAS_freq)) + geom_point(alpha=0.4, size=2.5) +
  theme_bw() + xlab("S1905PGx allele frequency") + ylab("G1000EAS allele frequency") +
  geom_smooth(method='lm') + 
  annotate("text", size=5, color="red", x = 0.1, y = 0.95, label = paste("R2 =",G1000EASR2))
G1000EASPlot



plot_grid(westlakePlot, G1000EASPlot, labels = c("A", "B"), align = "h", nrow=1)
ggsave("~/Desktop/pgxExternalAlleleFreqComparison.tiff", 
       height=7, width=7*2, units='in', dpi=360)

