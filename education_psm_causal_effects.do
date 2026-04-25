****************************************************
* Propensity Score Matching baseline
* Dataset: SOEP-style panel
****************************************************

clear all
set more off

* 1. Load data
use "soep_lebensz_en.dta", clear

* 2. Inspect structure
describe
summarize
tab year
tab sex
tab no_kids
tab education

* 3. Define treatment: high education
* Adjust threshold if education coding is different
summarize education, detail
gen high_educ = education >= r(p50) if !missing(education)

label define high_educ_lbl 0 "Low / medium education" 1 "High education"
label values high_educ high_educ_lbl

tab high_educ

* 4. Define outcome
* Example outcome: life satisfaction
global outcome satisfaction

* 5. Keep complete cases for baseline matching
keep if !missing($outcome, high_educ, sex, age, health, year, no_kids)

* If age does not exist in your dataset, use this instead:
* keep if !missing($outcome, high_educ, sex, health, year, no_kids)

* 6. Estimate propensity score model
logit high_educ i.sex c.health i.year i.no_kids

predict pscore, pr

summarize pscore if high_educ == 1
summarize pscore if high_educ == 0

* 7. Check common support visually
twoway ///
    (kdensity pscore if high_educ == 1) ///
    (kdensity pscore if high_educ == 0), ///
    legend(label(1 "High education") label(2 "Low / medium education")) ///
    title("Propensity Score Common Support")

* 8. Install psmatch2 if needed
cap which psmatch2
if _rc ssc install psmatch2

* 9. Nearest-neighbor propensity score matching
psmatch2 high_educ i.sex c.health i.year i.no_kids, ///
    outcome($outcome) ///
    neighbor(1) ///
    common ///
    caliper(0.05)

* 10. Balance diagnostics
pstest i.sex c.health i.year i.no_kids, both graph

* 11. Alternative: kernel matching
psmatch2 high_educ i.sex c.health i.year i.no_kids, ///
    outcome($outcome) ///
    kernel ///
    common

pstest i.sex c.health i.year i.no_kids, both graph

****************************************************
* Interpretation:
* ATT = estimated effect of high education on life satisfaction
* among individuals with high education, after matching on observables.
****************************************************
