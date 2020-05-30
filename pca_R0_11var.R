# install.packages("tidyverse")
# install.packages("R0")
library("tidyverse")
library(R0)

basic_reproductive_numbers <- read_csv("basic_reproductive_numbers.csv")

# Cleaning dataset for PCA
complete_data <- read_csv("complete_data.csv")

complete_data <- complete_data %>%
  column_to_rownames('Country Name')

complete_data <- complete_data[,
                               !(names(complete_data) %in% setdiff(
                                 colnames(complete_data),
                                 basic_reproductive_numbers$location
                               )
                               )
                               ]

data.matrix <- as.matrix(sapply(complete_data, as.double))

colnames(data.matrix) <- colnames(complete_data)
rownames(data.matrix) <- rownames(complete_data)

pca <- prcomp(t(data.matrix),
              scale = TRUE)

pca.data <- data.frame(Sample = rownames(pca$x),
                       X = pca$x[,1],
                       Y = pca$x[,2])

pca.data <- merge(
  pca.data, basic_reproductive_numbers,
  by.x = 'Sample', by.y = 'location'
)

pca.data %>%
  ggplot() +
  aes(x = X, y = Y) +
  geom_point(alpha = 0.5, aes(color = R_0, size = R_0)) +
  scale_color_viridis_c(direction = -1, option = "magma") +
  scale_size_continuous(range = c(1, 15)) +
  xlab(paste("PC1 - ", summary(pca)$importance[2,1]*100, "%", sep = "")) +
  ylab(paste("PC2 - ", summary(pca)$importance[2,2]*100, "%", sep = ""))
