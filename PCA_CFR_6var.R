# Run PCA for 142 countries having only 6 variables non empty
# Using CFR instead of R0 as indicator

# install.packages("tidyverse")
# install.packages("R0")
library("tidyverse")
library(R0)

CFR <- read_csv("CFR.csv")

six_var <- read_csv("six_var.csv")

six_var <- six_var %>%
  column_to_rownames('Country Name')

six_var <- six_var[,
                   !(names(six_var) %in% setdiff(
                     colnames(six_var),
                     CFR$Country_Region
                   )
                   )
                   ]

data.matrix <- as.matrix(sapply(six_var, as.double))

colnames(data.matrix) <- colnames(six_var)
rownames(data.matrix) <- rownames(six_var)

pca_six_var <- prcomp(t(data.matrix),
                      scale = TRUE)

pca_six_var.data <- data.frame(Sample = rownames(pca_six_var$x),
                               X = pca_six_var$x[,1],
                               Y = pca_six_var$x[,2])

pca_six_var_r0.data <- merge(
  pca_six_var.data, CFR,
  by.x = 'Sample', by.y = 'Country_Region'
)

# DO NOT RUN BOTH AT ONCE
# Run only either of the two for ploting a graph

# Show PCA plot

pca_six_var_r0.data %>%
  ggplot() +
  aes(x = X, y = Y) +
  geom_point(alpha = 0.5, aes(color = CFR, size = CFR)) +
  scale_color_viridis_c(direction = -1, option = "magma") +
  xlab(paste("PC1 - ", summary(pca_six_var)$importance[2,1]*100, "%", sep = "")) +
  ylab(paste("PC2 - ", summary(pca_six_var)$importance[2,2]*100, "%", sep = ""))

# Show loading plot 
loadings <- rownames_to_column(
  as.data.frame(
    pca_six_var$rotation
  ),
  "Variable")

loadings_group <- loadings %>%
  gather(key = "PC",
         value = "Loadings",
         -Variable)

loadings_group %>%
  ggplot(aes(fill=Variable, y = Loadings, x = PC)) +
  geom_bar(position="dodge", stat="identity") +
  theme(legend.position="bottom", legend.box = "horizontal")
