options(digits = 4)

# 1. Setup

packages <- c("ggplot2", "dplyr", "broom")

for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}

library(ggplot2)
library(dplyr)
library(broom)

# 2. Load and prepare data

data_file <- "diabetes.tab.txt"

if (!file.exists(data_file)) {
  data_file <- file.choose()
}

diabetes <- read.table(data_file, header = TRUE, sep = "\t")
names(diabetes) <- tolower(names(diabetes))

if ("y" %in% names(diabetes)) {
  names(diabetes)[names(diabetes) == "y"] <- "progression"
}

if (!"progression" %in% names(diabetes)) {
  stop("The dataset must contain the outcome column Y.")
}

diabetes$sex <- factor(diabetes$sex)

output_dir <- "diabetes_output"
figures_dir <- file.path(output_dir, "figures")
tables_dir <- file.path(output_dir, "tables")

dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)

# 3. Data inspection

print(head(diabetes))
print(dim(diabetes))
print(names(diabetes))
str(diabetes)

print(table(diabetes$sex))
print(colSums(is.na(diabetes)))
print(sum(is.na(diabetes)))
print(sum(duplicated(diabetes)))
print(summary(diabetes))

data_quality <- data.frame(
  variable = names(diabetes),
  type = sapply(diabetes, function(x) class(x)[1]),
  missing = sapply(diabetes, function(x) sum(is.na(x))),
  unique_values = sapply(diabetes, function(x) length(unique(x)))
)

write.csv(
  data_quality,
  file.path(tables_dir, "data_quality.csv"),
  row.names = FALSE
)

# 4. Descriptive analysis

describe_numeric <- function(x) {
  c(
    n = sum(!is.na(x)),
    mean = mean(x, na.rm = TRUE),
    median = median(x, na.rm = TRUE),
    sd = sd(x, na.rm = TRUE),
    min = min(x, na.rm = TRUE),
    q1 = quantile(x, 0.25, na.rm = TRUE),
    q3 = quantile(x, 0.75, na.rm = TRUE),
    max = max(x, na.rm = TRUE),
    iqr = IQR(x, na.rm = TRUE)
  )
}

numeric_data <- diabetes %>% select(where(is.numeric))

descriptive_table <- as.data.frame(
  t(sapply(numeric_data, describe_numeric))
)

descriptive_table$variable <- rownames(descriptive_table)
rownames(descriptive_table) <- NULL

descriptive_table <- descriptive_table %>%
  select(variable, everything())

print(descriptive_table)

write.csv(
  descriptive_table,
  file.path(tables_dir, "descriptive_statistics.csv"),
  row.names = FALSE
)

p1 <- ggplot(diabetes, aes(x = progression)) +
  geom_histogram(bins = 25, colour = "white") +
  labs(
    title = "Distribution of Diabetes Progression",
    x = "Progression measure",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "01_progression_histogram.png"),
       p1, width = 8, height = 5.5, dpi = 300)

p2 <- ggplot(diabetes, aes(x = bmi)) +
  geom_histogram(bins = 25, colour = "white") +
  labs(
    title = "Distribution of BMI",
    x = "BMI",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "02_bmi_histogram.png"),
       p2, width = 8, height = 5.5, dpi = 300)

p3 <- ggplot(diabetes, aes(y = progression)) +
  geom_boxplot() +
  labs(
    title = "Diabetes Progression",
    y = "Progression measure",
    x = NULL
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "03_progression_boxplot.png"),
       p3, width = 8, height = 5.5, dpi = 300)

p4 <- ggplot(diabetes, aes(x = age)) +
  geom_histogram(bins = 25, colour = "white") +
  labs(
    title = "Distribution of Age",
    x = "Age",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "04_age_histogram.png"),
       p4, width = 8, height = 5.5, dpi = 300)

# 5. Correlation analysis

cor_matrix <- cor(
  numeric_data,
  use = "complete.obs",
  method = "pearson"
)

print(round(cor_matrix, 3))

progression_correlations <- sort(
  cor_matrix[, "progression"],
  decreasing = TRUE
)

print(progression_correlations)

write.csv(
  round(cor_matrix, 4),
  file.path(tables_dir, "correlation_matrix.csv")
)

png(
  file.path(figures_dir, "05_correlation_heatmap.png"),
  width = 1800,
  height = 1500,
  res = 200
)

heatmap(
  cor_matrix,
  Rowv = NA,
  Colv = NA,
  scale = "none",
  symm = TRUE,
  margins = c(7, 7),
  main = "Correlation Heatmap"
)

dev.off()

p5 <- ggplot(diabetes, aes(x = bmi, y = progression)) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Diabetes Progression and BMI",
    x = "BMI",
    y = "Progression measure"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "06_progression_vs_bmi.png"),
       p5, width = 8, height = 5.5, dpi = 300)

p6 <- ggplot(diabetes, aes(x = bp, y = progression)) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Diabetes Progression and Blood Pressure",
    x = "Blood pressure",
    y = "Progression measure"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "07_progression_vs_bp.png"),
       p6, width = 8, height = 5.5, dpi = 300)

p7 <- ggplot(diabetes, aes(x = s5, y = progression)) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Diabetes Progression and S5",
    x = "S5 measurement",
    y = "Progression measure"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "08_progression_vs_s5.png"),
       p7, width = 8, height = 5.5, dpi = 300)

# 6. Regression models

simple_model <- lm(progression ~ bmi, data = diabetes)

print(summary(simple_model))
print(tidy(simple_model, conf.int = TRUE))
print(glance(simple_model))
print(coef(simple_model))

multiple_model <- lm(
  progression ~ bmi + bp + s5,
  data = diabetes
)

print(summary(multiple_model))
print(tidy(multiple_model, conf.int = TRUE))
print(glance(multiple_model))
print(confint(multiple_model))

model_comparison <- bind_rows(
  glance(simple_model) %>% mutate(model = "Simple: BMI"),
  glance(multiple_model) %>% mutate(model = "Multiple: BMI + BP + S5")
) %>%
  select(model, r.squared, adj.r.squared, sigma, AIC, BIC, p.value)

print(model_comparison)

write.csv(
  model_comparison,
  file.path(tables_dir, "model_comparison.csv"),
  row.names = FALSE
)

write.csv(
  tidy(multiple_model, conf.int = TRUE),
  file.path(tables_dir, "multiple_model_coefficients.csv"),
  row.names = FALSE
)

# 7. Model diagnostics

diagnostic_data <- augment(multiple_model)

p8 <- ggplot(diagnostic_data, aes(x = .fitted, y = .resid)) +
  geom_point(alpha = 0.65) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Residuals versus Fitted Values",
    x = "Fitted values",
    y = "Residuals"
  ) +
  theme_minimal()

ggsave(file.path(figures_dir, "09_residuals_vs_fitted.png"),
       p8, width = 8, height = 5.5, dpi = 300)

png(
  file.path(figures_dir, "10_regression_diagnostics.png"),
  width = 2000,
  height = 2000,
  res = 220
)

par(mfrow = c(2, 2))
plot(multiple_model)
dev.off()
par(mfrow = c(1, 1))

manual_vif <- function(model) {
  X <- model.matrix(model)[, -1, drop = FALSE]
  
  vif_values <- sapply(seq_len(ncol(X)), function(i) {
    target <- X[, i]
    others <- X[, -i, drop = FALSE]
    
    r_squared <- summary(lm(target ~ others))$r.squared
    1 / (1 - r_squared)
  })
  
  setNames(vif_values, colnames(X))
}

vif_values <- manual_vif(multiple_model)
print(vif_values)

write.csv(
  data.frame(
    variable = names(vif_values),
    VIF = as.numeric(vif_values)
  ),
  file.path(tables_dir, "vif_values.csv"),
  row.names = FALSE
)

print(shapiro.test(residuals(multiple_model)))

capture.output(
  summary(simple_model),
  summary(multiple_model),
  confint(multiple_model),
  file = file.path(output_dir, "model_details.txt")
)

cat("Analysis completed successfully.\n")
cat("Output folder:", normalizePath(output_dir), "\n")