# Load required libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(corrplot)
library(lmtest)
library(car)
library(sandwich)

# Load and prepare data 
data <- read_excel("Purchasing_data.xlsx")
keep_cols <- c("D08", "D11", paste0("Q01_", 1:15))
data_clean <- data[-1, keep_cols]
data_clean <- as.data.frame(data_clean)
print(paste("Initial data:", nrow(data_clean), "rows"))

# Convert ALL payment variables to numeric (all 15 Q01 columns)
q01_cols <- paste0("Q01_", 1:15)
data_clean[q01_cols] <- lapply(data_clean[q01_cols], function(x){
  as.numeric(x != "0")
})

# Create key behavioral indicators
data_clean$UsesDigital <- as.numeric(data_clean$Q01_8 | data_clean$Q01_9 | 
                                       data_clean$Q01_10 | data_clean$Q01_12)
data_clean$UsesTraditional <- as.numeric(data_clean$Q01_1 | data_clean$Q01_2)
data_clean$TotalPayments <- rowSums(data_clean[, q01_cols])

# Clean and prepare demographic variables
names(data_clean)[names(data_clean) == "D11"] <- "Income"
names(data_clean)[names(data_clean) == "D08"] <- "AgeGroup"
data_clean$Income <- as.factor(data_clean$Income)
data_clean$AgeGroup <- as.factor(data_clean$AgeGroup)

# Remove incomplete cases for analysis variables
data_clean <- data_clean %>%
  filter(!is.na(Income), !is.na(AgeGroup), !is.na(TotalPayments))
print(paste("Final analysis dataset:", nrow(data_clean), "rows"))

# PLOT 1: Correlation Matrix
corr_data <- data_clean
corr_data$Income_numeric <- as.numeric(corr_data$Income)
corr_data$AgeGroup_numeric <- as.numeric(corr_data$AgeGroup)

cor_vars <- c("TotalPayments", "UsesDigital", "UsesTraditional", "Income_numeric", "AgeGroup_numeric")
cor_matrix <- cor(corr_data[, cor_vars])
print("Correlation Matrix:")
print(round(cor_matrix, 3))

corrplot(cor_matrix, 
         method = "color", 
         addCoef.col = "black",
         tl.col = "black",
         tl.srt = 45,
         title = "Correlation Matrix: Payment Behaviors and Demographics",
         mar = c(0,0,2,0))

# Model 1: Simple regression
model1 <- lm(TotalPayments ~ UsesDigital, data = data_clean)
print("Simple Regression Results:")
summary(model1)

# PLOT 2: Box Plot - Digital vs Non-digital
ggplot(data_clean, aes(x = factor(UsesDigital), y = TotalPayments)) +
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  labs(title = "Payment Method Diversity: Digital vs Non-Digital Users",
       x = "Uses Digital Payments (0=No, 1=Yes)", 
       y = "Total Payment Methods") +
  theme_minimal()

# Model 2: Multiple regression
model2 <- lm(TotalPayments ~ UsesDigital + UsesTraditional + Income + AgeGroup, data = data_clean)
print("Multiple Regression Results:")
summary(model2)

# PLOT 3: Residuals vs Fitted
plot(model2, which = 1, main = "Residuals vs Fitted Values")

# PLOT 4: Q-Q Plot
plot(model2, which = 2, main = "Q-Q Plot of Residuals")

# Model diagnostics
print("Model Diagnostics:")
cooksd <- cooks.distance(model2)
influential <- sum(cooksd > 4/nrow(data_clean))
print(paste("Influential observations:", influential))

print("Heteroscedasticity Test:")
bptest(model2)

print("Multicollinearity Check:")
vif(model2)

# Robust standard errors
robust_summary <- coeftest(model2, vcov = vcovHC(model2, type = "HC1"))
print("Robust Standard Errors:")
print(robust_summary)

# Square root transformation
data_clean$TotalPayments_sqrt <- sqrt(data_clean$TotalPayments)
model_sqrt <- lm(TotalPayments_sqrt ~ UsesDigital + UsesTraditional + Income + AgeGroup, data = data_clean)
print("Square Root Transformation Results:")
summary(model_sqrt)

# Business predictions
customer1 <- data.frame(
  UsesDigital = 1,
  UsesTraditional = 1,
  Income = "Between $50,000 and $74,999",
  AgeGroup = "25 to 34"
)
pred1 <- predict(model2, newdata = customer1)
print(paste("Digital adopter prediction:", round(pred1, 2), "payment methods"))

customer2 <- data.frame(
  UsesDigital = 0,
  UsesTraditional = 1,
  Income = "Between $25,000 and $49,999",
  AgeGroup = "65 or older"
)
pred2 <- predict(model2, newdata = customer2)
print(paste("Traditional user prediction:", round(pred2, 2), "payment methods"))

# Model comparison
print("MODEL COMPARISON:")
metrics <- data.frame(
  Metric = c("R-squared", "RSE", "AIC"),
  Model1 = c(round(summary(model1)$r.squared, 3), 
             round(sigma(model1), 3), 
             round(AIC(model1), 1)),
  Model2 = c(round(summary(model2)$r.squared, 3), 
             round(sigma(model2), 3), 
             round(AIC(model2), 1))
)
print(metrics)


print("=== ANALYSIS COMPLETE ===")

