*BIO536 Final Project_codes


*1. transformation of covariates*********************************************************

*1.1 SEX-->>recode sex-->>1=male, 0=female------sex
recode sex 2=0


*1.2 BMI-->>dummy variable-----bmicat
codebook bmi
gen bmicat = bmi
replace bmicat=0 if bmi>=18.5 & bmi<25
replace bmicat=1 if bmi<18.5
replace bmicat=2 if bmi>=25 & bmi<30
replace bmicat=3 if bmi>=30 & bmi~=.
tab bmi bmicat

lab var bmicat "BMI group"
lab def l_bmicat 0 "normal" 1 "underweight" 2 "overweight" 3 "obese"
lab val bmicat l_bmicat


*1.3.1 AGE-->>linear splines(50, 60, 70)-------s1-s4
mkspline s1 50 s2 60 s3 70 s4= age, marginal
*1.3.2 AGE-->>dummy variabls(<50, 50-59, 60-69, 70+)------for table1-----agecat
codebook age
gen agecat=.
replace agecat=1 if age<50
replace agecat=2 if age>=50& age<=59
replace agecat=3 if age>=60& age<=69
replace agecat=4 if age>=70& age~=.
tab agecat


*1.4 updated_Total cholesterol--->>dummy variables(<200,200-240,240+)------for table1------totcholcat2

gen totcholcat2=.
replace totcholcat2=1 if totchol<200
replace totcholcat2=2 if totchol>=200 & totchol<=240
replace totcholcat2=3 if totchol>240 & totchol~=.
tab totcholcat2, missing



*1.5 systolic BP--->dummy variables(>=140,<140)-----for table1-----sysbpcat
codebook sysbp
gen sysbpcat=.
replace sysbpcat=1 if sysbp>=140&sysbp~=.
replace sysbpcat=2 if sysbp<140
tab sysbpcat


*1.6 diastolic BP--->dummy variables(>=90, <90)-----for table1-----diabpcat
codebook diabp
gen diabpcat=.
replace diabpcat=1 if diabp>=90 &diabp~=.
replace diabpcat=2 if diabp<90
tab diabpcat

*1.7 cigs/day---->dummy variables(<20,20-40,40+)---for table1---cigcat
codebook cigpday
gen cigcat=.
replace cigcat=1 if cigpday<20
replace cigcat=2 if cigpday>=20&cigpday<40
replace cigcat=3 if cigpday>=40
tab cigcat

*1.8 heart rate---->dummy variables(<60,60-100,100+)---for table1--hrtcat
codebook heartrte
gen hrtcat=.
replace hrtcat=1 if heartrte<60
replace hrtcat=2 if heartrte>=60&heartrte<=100
replace hrtcat=3 if heartrte>100
tab hrtcat

*2. Analysis
*2.1 Table 1 *************************************************************************
bysort case: tab sex 
bysort case: tab agecat
bysort case: tab bmicat  
bysort case: tab sysbpcat 
bysort case: tab diabpcat 
bysort case: tab cursmoke
bysort case: tab cigcat 
bysort case: tab diabetes 
bysort case: tab bpmed
bysort case: tab hrtcat
bysort case: tab prevchd 
bysort case: tab totcholcat2, missing
bysort case: tab educ, missing

*2.2 Table 2 *************************************************************************

* Model includes interaction between sex and BMI
logistic case time s1-s4 i.educ i.cursmoke c.cigpday##c.cigpday i.sex##i.bmicat

**OR comparing underweight to normal, among males with same age, cigs per day, smoking status, educational attainment
lincom 1.bmicat+1.sex#1.bmicat

**OR comparing underweight to normal, among females with same age, cigs per day, smoking status, educational attainment
lincom 1.bmicat

**OR comparing overweight to normal, among males with same age, cigs per day, smoking status, educational attainment
lincom 2.bmicat+1.sex#2.bmicat
**OR comparing overweight to normal, among females with same age, cigs per day, smoking status, educational attainment
lincom 2.bmicat
**OR comparing obese to normal, among males with same age, cigs per day, smoking status, educational attainment
lincom 3.bmicat+1.sex#3.bmicat
**OR comparing obese to normal, among females with same age, cigs per day, smoking status, educational attainment
lincom 3.bmicat


bysort sex: tab case bmicat
///very few subjects in underweight stratum


*2.3 Trend test, bmi group is included as a grouped linear term

gen bmicat2=bmicat
recode bmicat2 0=5 1=7 
recode bmicat2 5=1 7=0
///now 0 underweight 1 normal 2 overweight 3 obese
tab bmicat bmicat2
logistic case time s1-s4 i.educ i.cursmoke c.cigpday##c.cigpday i.sex##c.bmicat2

testparm bmicat2




