# Run PCA for only 29 countries having all 11 variables non empty

# install.packages("tidyverse")
# install.packages("R0")
library("tidyverse")
library(R0)

CFR <- read_csv("CFR.csv")

all_var_29_country <- read_csv("all_var_29_country.csv")

all_var_29_country <- all_var_29_country %>%
  column_to_rownames('Country Name')

all_var_29_country <- all_var_29_country[,
                                         !(names(all_var_29_country) %in% setdiff(
                                           colnames(all_var_29_country),
                                           CFR$Country_Region
                                         )
                                         )
                                         ]

data.matrix <- as.matrix(sapply(all_var_29_country, as.double))

colnames(data.matrix) <- colnames(all_var_29_country)
rownames(data.matrix) <- rownames(all_var_29_country)

pca_29_country <- prcomp(t(data.matrix),
                         scale = TRUE)

pca_29_country.data <- data.frame(Sample = rownames(pca_29_country$x),
                                  X = pca_29_country$x[,1],
                                  Y = pca_29_country$x[,2])

pca_29_country_cfr.data <- merge(
  pca_29_country.data, CFR,
  by.x = 'Sample', by.y = 'Country_Region'
)

# DO NOT RUN BOTH AT ONCE
# Run only either of the two for ploting a graph

# Show PCA plot

pca_29_country_cfr.data %>%
  ggplot() +
  aes(x = X, y = Y) +
  geom_point(alpha = 0.5, aes(color = CFR)) +
  scale_color_viridis_c(direction = -1, option = "magma") +
  xlab(paste("PC1 - ", summary(pca_29_country)$importance[2,1]*100, "%", sep = "")) +
  ylab(paste("PC2 - ", summary(pca_29_country)$importance[2,2]*100, "%", sep = ""))
# 
# group <- pca_29_country_cfr.data %>%
#   mutate(
#     group = case_when(
#       (0 < R_0)&(R_0 < 1) ~ "R_0 < 1",
#       (1 <= R_0)&(R_0 <= 1.4) ~ "1 <= R_0 <= 1.4",
#       R_0 > 1.4 ~ "R_0 > 1.4"
#     )
#   )

# group <- factor(group$group)

# Show loading plot
loadings <- rownames_to_column(
  as.data.frame(
    pca_29_country$rotation
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
