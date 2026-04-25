# Microeconometrics: Discrete Choice and Causal Inference

This repository contains applied microeconometric analyses using panel data, focusing on discrete choice models and causal inference techniques.

## Objective

To study the relationship between education, fertility outcomes, and life satisfaction using modern econometric methods.

## Data

Panel dataset (2000–2004) with individual-level information:

- Education (years)
- Number of children
- Life satisfaction (standardized)
- Health (standardized)
- Gender
- Year

## Projects

### 1. Discrete Choice Models (Fertility Outcomes)

- Multinomial Logit estimation
- Relative risk ratios
- Marginal effects
- Ordered Probit comparison
- Model interpretation

### 2. Causal Inference using Propensity Score Matching

- Treatment definition: high vs low education
- Logistic regression for propensity score estimation
- Nearest neighbor matching
- Kernel matching
- Balance diagnostics (pstest)
- ATT estimation

## Key Results

- Fertility outcomes are strongly associated with education levels
- Raw differences in life satisfaction by education are positive
- After matching, the effect becomes small and statistically insignificant
- Matching significantly improves covariate balance

## Methods

- Multinomial logit
- Ordered probit
- Propensity score matching
- Balance diagnostics
- Panel data analysis

## Tools

- Stata

## Repository Structure

```text
data/
stata/
