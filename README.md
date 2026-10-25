# Understanding Diabetes Progression: An Exploratory and Regression Analysis

## Project Overview

This project was completed for the course **Data Analytics and Statistics with Applications**. I selected **Option 1: Understanding Diabetes Progression** to investigate how patient characteristics and clinical measurements are associated with diabetes progression.

I used R to perform exploratory data analysis, examine correlations, fit and compare linear regression models, and assess model diagnostics and limitations. The project focuses on interpreting statistical evidence clearly and communicating the findings to both technical and non-technical audiences.

## Research Question

How are patient characteristics and clinical measurements associated with diabetes progression, and does a multiple regression model explain more variation in progression than a model using body mass index (BMI) alone?

## Dataset

The dataset contains **442 observations**, 10 predictor variables and one quantitative outcome measuring diabetes disease progression.

The analysis includes descriptive statistics, correlation analysis, simple linear regression using BMI, and multiple linear regression using BMI, blood pressure and the S5 measurement.

## Key Findings

- BMI showed a positive correlation with diabetes progression (r = 0.586).
- The S5 measurement also showed a positive correlation with progression (r = 0.566).
- Blood pressure had a positive correlation with progression (r = 0.441).
- The BMI-only regression model explained approximately **34.4%** of the observed variation in progression.
- The multiple regression model using BMI, blood pressure and S5 explained approximately **48.0%** of the observed variation.
- The findings indicate that the selected predictors jointly explained more variation than BMI alone in this dataset.

These results describe statistical associations and do not establish causation. The models also have limitations and should not be used as stand-alone diagnostic or treatment tools.

## Analysis and Reproducibility

I used R to:

1. Inspect and prepare the dataset.
2. Examine data quality and calculate descriptive statistics.
3. Explore distributions and relationships using visualisations.
4. Calculate correlations between the outcome and predictor variables.
5. Fit and compare simple and multiple linear regression models.
6. Evaluate regression assumptions, multicollinearity and residual diagnostics.
7. Interpret the findings, uncertainty and limitations.

The commented R script documents the analytical workflow and is intended to support reproducibility.

## Project Deliverables

- **R Analysis Script:** Commented R code containing the statistical analysis.
- **Analytical Report:** A detailed PDF report presenting the research question, methods, results, visualisations, interpretation and limitations.
- **Decision-Maker Presentation:** A PDF presentation communicating the main findings and practical implications to a non-specialist healthcare audience.
- **Technical-Team Presentation:** A separate PDF presentation for a technically oriented audience.
- **Figures Folder:** The visualisations generated for the analysis and report.

## Limitations

The analysis identifies associations rather than causal relationships. The models use a limited selection of predictors, and some variation in progression remains unexplained. Diagnostic testing also identified a statistically detectable departure from residual normality. Further validation, including evaluation on independent data, would be needed before considering practical predictive use.

## Reflection

Through this project, I applied exploratory data analysis, correlation analysis, linear regression and diagnostic techniques to a health-related dataset. I also learned the importance of comparing models, checking assumptions, communicating uncertainty and adapting statistical findings to different audiences.

With more time, I would investigate additional predictors, conduct further validation and assess how well the models perform on independent data.

## Conclusion

This project demonstrates how statistical analysis can help explore relationships between patient measurements and diabetes progression. The comparison of regression models showed that including additional predictors improved the amount of variation explained in the analysed dataset. The findings should nevertheless be interpreted cautiously, with appropriate attention to uncertainty, limitations and the distinction between association and causation.
