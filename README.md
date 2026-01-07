# 📊 Predicting Payment Diversity with R: A Regression & Behavioral Analytics Case Study

## 📌 Project Overview
This marketing analytics project uses **R** to analyze consumer payment behavior through linear regression modeling, identifying key behavioral predictors of payment method diversity for financial services segmentation.

**Sample:** 2,094 survey respondents | **Tools:** R, Linear Regression, ggplot2, dplyr

---

## 🔬 Hypotheses Tested
| Hypothesis | Description | Result |
|------------|-------------|---------|
| **H₁: Digital Impact** | Digital payment adoption increases payment diversity | ✅ Supported (+2.55 methods, p < 2e-16) |
| **H₂: Behavioral > Demographic** | Payment behavior explains more variance than demographics | ✅ Supported (R² = 0.423 vs. demographic models) |
| **H₃: Segment Differentiation** | Customer segments differ significantly in payment diversity | ✅ Supported (4 distinct segments identified) |

---

## 🛠️ Tools & Technologies
- **R Programming** (Linear Regression, Data Visualization)
- **Statistical Modeling** (Robust Standard Errors, Model Diagnostics)
- **Data Visualization** (ggplot2, Correlation Heatmaps)
- **Data Manipulation** (dplyr, tidyr)
- **Hypothesis Testing** (AIC Comparison, R-squared Validation)

---


---

## 📈 Key Findings
1. **Digital Adoption Impact:** Digital users employ 2.55 more payment methods on average (p < 0.001)
2. **Behavioral Primacy:** Payment behavior explains 42.3% of variance vs. <15% for demographics
3. **Segment Identification:** Four distinct customer segments with varying engagement levels
4. **Model Performance:** Multiple regression outperformed simple models (ΔAIC = -424.79)

---

## 🚀 Business Impact & Recommendations
### **Customer Segmentation Strategy:**
- **Digital Adopters** (6.65 avg methods): Target for premium products & innovation
- **Traditional Users** (3.64 avg methods): Gradual digital onboarding programs
- **Comprehensive Users** (7+ methods): High-value cross-selling opportunities
- **Minimal Users** (<3 methods): Basic financial education & simple solutions

### **Strategic Shifts:**
- **From demographics to behavior-based marketing**
- **Digital-first acquisition strategy** with traditional preservation
- **Resource reallocation** to high-impact behavioral analytics
- **Cross-selling frameworks** for comprehensive users

## 📊 Visualizations Included
- **Correlation heatmap** of payment behaviors vs. demographics
- **Residual plots** with heteroscedasticity diagnosis
- **Customer segment comparison** (box plots)
- **Model performance comparison** (AIC, R-squared)

## 👤 Contributor
**Parminder Kaur** (NFI030012) – Full analysis, modeling, and reporting

*Project for: Marketing Analytics (DAMO-520-21), University of Niagara Falls Canada*

## 📄 License
This project is for academic and portfolio purposes. All data is anonymized and simulated for analysis demonstration.
---


## 🎯 Technical Implementation Highlights
```r
# Key regression model with robust standard errors
library(sandwich)
library(lmtest)

final_model <- lm(TotalPayments ~ UsesDigital + UsesTraditional + 
                   Income + AgeGroup, data = survey_data)
coeftest(final_model, vcov = vcovHC(final_model, type = "HC1"))

# Model comparison
model_simple <- lm(TotalPayments ~ UsesDigital, data = survey_data)
anova(model_simple, final_model)  # F-test for improvement

# List of required R packages
packages <- c(
  "tidyverse",    # dplyr, ggplot2, tidyr
  "broom",        # Tidy model outputs
  "sandwich",     # Robust standard errors
  "lmtest",       # Hypothesis testing
  "corrplot",     # Correlation visualizations
  "knitr",        # Reporting
  "rmarkdown"     # Dynamic documents
)

# Installation check
lapply(packages, function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
})

