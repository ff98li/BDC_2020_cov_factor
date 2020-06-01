# Decision tree is sufficient for explanatory analysis
library("tidyverse")
library("partykit")

basic_reproductive_numbers <- read_csv("basic_reproductive_numbers.csv")

six_var <- read_csv("six_var.csv")

six_var <- six_var %>%
  column_to_rownames('Country Name')

six_var <- six_var[,
                   !(names(six_var) %in% setdiff(
                     colnames(six_var),
                     basic_reproductive_numbers$location
                   )
                   )
                   ]

brn_class <- basic_reproductive_numbers %>%
  mutate(Control = ifelse(R_0 < 1,
                          "Controled",
                          "Uncontroled"))

brn_class$Control <- as.factor(brn_class$Control)

brn_class <- brn_class[, !(names(brn_class)%in%c("R_0"))]
    
six_var <- six_var %>%
  rownames_to_column() %>%
  pivot_longer(-rowname) %>%
  pivot_wider(names_from = rowname)

names(six_var)[names(six_var) == "name"] <- "location"

six_var <- merge(
  six_var, brn_class,
  by.x = 'location', by.y = 'location'
)

six_var$location <- NULL

# Build model
set.seed(114514) # For reproduceable result

data <- six_var %>% rowid_to_column()
n <- nrow(data)
train_index <- sample(1:n, size = round(0.75 * n))
train <- data[train_index,]
test <- data[-train_index,]

tree <- rpart(Control ~ ., data = train)
plot(as.party(tree), type = "extended")

tree_pred <- predict(tree, newdata = test) %>%
  as_tibble() %>%
  mutate(
    prediction = ifelse(
      Controled >= 0.5,
      "Predict Controled",
      "Predict Uncontroled"
    )
  )
confusion_matrix <- table(tree_pred$prediction, test$Control)

accuracy <- sum(diag(confusion_matrix))/sum(confusion_matrix)
sensitivity <- confusion_matrix[1]/sum(confusion_matrix)
specificity <- confusion_matrix[4]/sum(confusion_matrix)


# Plot ROC curve for the decision tree model
library(ROCR)
# Predicted probabilities
pred_probs <- predict(object = tree, newdata = test, type = "prob")
# Create R objects which will be used to create the ROC plot
pred <- ROCR::prediction(predictions = pred_probs[,2],
                         labels=test$Control)
perf <- ROCR::performance(pred, 'tpr', 'fpr')
# Create a data framewith tpr and fpr -> need to use data.frame here
perf_df <- data.frame(perf@x.values, perf@y.values)
names(perf_df) <- c("fpr", "tpr")
# Plot the ROC curve
roc <- ggplot(data = perf_df, aes(x=fpr, y=tpr)) +
  geom_line(color = "blue") + 
  geom_abline(intercept = 0, slope=1, lty=3) +
  ylab(perf@y.name) + xlab(perf@x.name)

roc