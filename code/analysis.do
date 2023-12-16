clear all

cd "/home/sahil/Downloads/song"

use data/total_data_short, clear

* label the variables
label var id "Unique ID"
label var age "Age"
label var educ "Education level"
label var gender "Gender"
label var income "Income category"
label var vacc_b "Vaccine likelihood baseline"
label var vacc_e "Vaccine likelihood endline"
label var missing "Missing status for endline survey"
label var treat "Treatment status"

global baseline_vars age educ gender income 

* generate treatment dummies 
tab treat, gen(treat)

label var treat1 "Control"
label var treat2 "Treatment 1"
label var treat3 "Treatment 2"

eststo clear
eststo: estpost ttest $baseline_vars treat1 treat2 treat3, by(missing) unequal
esttab using "output/balance_miss.tex", cells("mu_1(fmt(%9.3f)) N_1(fmt(%9.0f)) mu_2(fmt(%9.3f)) N_2(fmt(%9.0f)) t(fmt(%9.3f)) p(star fmt(%9.3f))") ///
collabels("Mean 1" "N1" "Mean 2" "N2" "t-statistic" "p-value") ///
title("Balance by missing status") label replace

drop if missing == 1

eststo clear 
eststo: estpost summ $baseline_vars if treat==0
eststo: estpost summ $baseline_vars if treat==1
eststo: estpost summ $baseline_vars if treat==2
esttab using "output/summary.tex", cells("mean(fmt(%9.3f))" sd(par fmt(%9.3f))) /// 
title("Summary statistics for each group") ///
mtitle("Control" "Treatment 1" "Treatment 2") ///
collabels("Mean (SD)" "Mean (SD)" "Mean (SD)" "") label replace

eststo clear
eststo: estpost ttest $baseline_vars if treat3 == 0, by(treat2) unequal
esttab using "output/balance_treat1.tex", cells("mu_1(fmt(%9.3f)) N_1(fmt(%9.0f)) mu_2(fmt(%9.3f)) N_2(fmt(%9.0f)) t(fmt(%9.3f)) p(star fmt(%9.3f))") ///
collabels("Mean 1" "N1" "Mean 2" "N2" "t-statistic" "p-value") ///
title("Balance between control and treatment 1") label replace

eststo clear
eststo: estpost ttest $baseline_vars if treat2 == 0, by(treat3) unequal
esttab using "output/balance_treat2.tex", cells("mu_1(fmt(%9.3f)) N_1(fmt(%9.0f)) mu_2(fmt(%9.3f)) N_2(fmt(%9.0f)) t(fmt(%9.3f)) p(star fmt(%9.3f))") ///
collabels("Mean 1" "N1" "Mean 2" "N2" "t-statistic" "p-value") ///
title("Balance between control and treatment 2") label replace

eststo clear
use data/total_data_long, clear

label var id "Unique ID"
label var age "Age"
label var educ "Education level"
label var gender "Gender"
label var income "Income category"
label var vacc "Vaccine likelihood"
label var time "Endline"
label var missing "Missing status for endline survey"
label var treat "Treatment status"

global baseline_vars age educ gender income 

* generate treatment dummies 
tab treat, gen(treat)

label var treat1 "Control"
label var treat2 "Treatment1"
label var treat3 "Treatment2"

gen interact = treat*time
tab interact, gen(int_dum)

drop if missing == 1

label var int_dum2 "Treatment1 * Endline"
label var int_dum3 "Treatment2 * Endline"

eststo clear
eststo: reg vacc time treat2 treat3 int_dum2 int_dum3, robust
eststo: reg vacc time treat2 treat3 int_dum2 int_dum3 age gender i.educ i.income, robust
esttab using "output/reg1.tex", mtitle("Standard" "With demog. controls") title("Average treatment effects") ///
drop(age *.educ *.income gender) stats(r2 df_r) star label replace

