Package The folder `code/` contains all the code files
The folder `data/` contains all the data files
The folder `output/` contains all the .tex files for the tables


Personal identifiers like name, and an accurate address are not useful
for our analysis. It is also possible that people are more likely to fill an
anonymous survey. Thus, my baseline and endline survey collects only the
following information. 


### Baseline Survey 

* ID: 1-5000

* Gender: M/F

* Age: 15-85

* Home address pincode

* Education level: 
	+ below highschool
	+ highschool but no undergraduate degree
	+ undergraduate degree or higher

* On a scale of 1-5, with 5 being 100% certain, how likely are you to take the COVID-19 vaccine when it comes out next month?

I assume that the experiment is done before the COVID-19 vaccine comes out. If not, we can change to asking a two-part question
1. to whether they have taken it?
2. if not, what is the likelihood of them taking it? 

I assume that after collecting all the surveys, I assign them a unique ID. Let's assume that the income data was added from a different census data which contains information about median income for a pincode, and I already did a many-to-one merge to add income data to the baseline survey. 


`baseline.R` creates `baseline_data.csv` 

It contains the variables `id, age, income, educ, gender, vacc_b`.


### Assign treatment


`assign_treatment.R` uses `baseline_data.csv`, stratifies by education level and creates `treat_data.csv` 

It creates the new variable `treat` which takes three values.
1. Control
2. Treatment 1
3. Treatment 2

### Endline Survey 

* ID: 1-5000

* Gender: M/F

* Age: 15-85

* Home address pincode

* Education level: 
	+ below highschool
	+ highschool but no undergraduate degree
	+ undergraduate degree or higher

* On a scale of 1-5, with 5 being 100% certain, how likely are you to take the COVID-19 vaccine when it comes out next month?

I randomly assign `missing` status to 500 respondents. This step is important. 

`endline.R` uses `treat_data.csv`, and creates `endline_data.csv` 

I assume that

`vacc_e` = round(`vacc_b` + epsilon<sub>i</sub>)

epsilon<sub>0</sub> is drawn from normal with mean 0.4 and sd 1.
epsilon<sub>1</sub> is drawn from normal with mean 0.8 and sd 0.5.
epsilon<sub>2</sub> is drawn from normal with mean 0.5 and sd 0.9.

Thus, I assumed that there is a positive trend in the control group too, and that treatment 1 is mean 0.8 and treatment 2 is mean 0.5 which means it is not much better than the control.

I store the data in `.dta` format in both long and short formats. In the long format, `vacc_b` and `vacc_e` are in the same column and a new variable called `time` is the indicator variable for endline status.

I switch to Stata from R as sometimes doing t-tests is easier in Stata.

`estout` is needed