*******************************************************
* STATA 19 — Translation of your Python pipeline
* Data: soep_lebensz_en.dta
*******************************************************
cls
clear all
set more off

* -------------------------------
* 1) Load raw dataset + basic checks
* -------------------------------
use "/Users/carlosrubiano/Documents/DOCS_CARLOS/economía/MSc economics /2nd Term/Econometric Methods 2/Problem set1/soep_lebensz_en.dta", clear

xtset id year
sort id year


describe
summarize



* 2) Keep only needed vars + drop missing in key variables
keep id year no_kids education sex health_std satisf_std
drop if missing(no_kids, education)

* 3) Check support of the outcome
tab no_kids, missing


* ---------------------------------------------------
* MODEL CHOICE (for your written justification)
* ---------------------------------------------------
* Multinomial Logit (mlogit) is the right pick because education is
* individual-specific (does not vary across alternatives j).
* Conditional logit is designed for alternative-specific regressors
* (variables that vary by alternative), which we do not have here.
* MNL estimates relative log-odds of each outcome vs a base outcome.
* ---------------------------------------------------

mlogit no_kids c.education, baseoutcome(0) rrr
* Ratio P(2)/P(0) at education = 12
* Ratio P(2)/P(0) at education = 12
nlcom (ratio_2_vs_0_educ12: exp(_b[2:_cons] + 12*_b[2:education]))

* (Optional) Show the per-year multiplier in log terms
display "RRR (2 vs 0) per +1 year educ = " exp(_b[2:education])


*According to the multinomial logit model, an individual with 12 years of education has a relative likelihood of about 0.24 of having two children rather than zero children.
*In other words, having two children is still less likely than having none at 12 years of education, but education significantly increases this relative likelihood.

mlogit no_kids c.education, baseoutcome(0) rrr
* Average marginal effects of +1 year education on P(no_kids=j)
margins, dydx(education) predict(outcome(0))
matrix M0 = r(b)

margins, dydx(education) predict(outcome(1))
matrix M1 = r(b)

margins, dydx(education) predict(outcome(2))
matrix M2 = r(b)

margins, dydx(education) predict(outcome(3))
matrix M3 = r(b)

display "Average marginal effects of +1 year education"
display "--------------------------------------------"
display "P(no_kids = 0): " M0[1,1]
display "P(no_kids = 1): " M1[1,1]
display "P(no_kids = 2): " M2[1,1]
display "P(no_kids = 3): " M3[1,1]
display "--------------------------------------------"
display "Sum of AMEs:   " M0[1,1] + M1[1,1] + M2[1,1] + M3[1,1]

*A one-year increase in education reduces the probability of having no children by about 1.1 pp.

*It increases the probability of having one child by about 0.27 pp.

*It increases the probability of having two children by about 0.88 pp.

*It has no statistically significant effect on the probability of having three children.

*These effects exactly offset each other (They all sum up to 0 which must be true), so total probability remains one.


*(c) Would ordered probit be better? Why?

*Maybe, but only if the ordering is substantively meaningful. Here the outcome is no_kids ∈ {0,1,2,3} and it is naturally ordered. An Ordered Probit imposes: a single slope for education (same direction across all cutoffs), and that education shifts the latent index monotonically, affecting the probabilities in a structured way.

*So compared to multinomial logit, ordered probit is more parsimonious and can be more efficient if the restriction is reasonable.
*But it can be worse if:mthe effect of education is not monotone across categories (e.g., education raises 2 vs 1 but lowers 3 vs 2), or the "distance" between categories isn't captured well by a single latent index model.

*Ordered probit can be better if you believe the choices are ordinal and education moves people smoothly along an underlying "fertility propensity" index; otherwise MNL is safer.

* Ordered probit: no_kids treated as ordered outcome 0<1<2<3
oprobit no_kids c.education
margins, dydx(education) predict(outcome(2)) at(education=12)

*Interpretation:
*cut1 (0.6306264): latent-index threshold separating "0 children" from "at least 1 child".
*cut2(1.130783): threshold separating "at most 1 child" from "at least 2 children".
*cut3(1.927281): threshold separating "at most 2 children" from "3 children".

* Education has a positive and statistically significant effect on the latent fertility index.

* Therefore, higher education reduces the probability of low outcomes (0,1) and increases the probability of higher outcomes (2,3) in a monotone way.

*For an individual with 12 years of education, an additional year of education increases the probability of having two children by about 0.45 percentage points.
