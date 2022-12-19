/*____/\\\\\\\\\\\___  __/\\\________/\\\_  _____/\\\\\\\\\____  ____/\\\\\\\\\_____  __/\\\\\\\\\\\\\\\_            
* ___/\\\/////////\\\_  _\/\\\_______\/\\\_  ___/\\\\\\\\\\\\\__  __/\\\///////\\\___  _\/\\\///////////__           
*  __\//\\\______\///__  _\/\\\_______\/\\\_  __/\\\/////////\\\_  _\/\\\_____\/\\\___  _\/\\\_____________          
*   ___\////\\\_________  _\/\\\\\\\\\\\\\\\_  _\/\\\_______\/\\\_  _\/\\\\\\\\\\\/____  _\/\\\\\\\\\\\_____         
*    ______\////\\\______  _\/\\\/////////\\\_  _\/\\\\\\\\\\\\\\\_  _\/\\\//////\\\____  _\/\\\///////______        
*     _________\////\\\___  _\/\\\_______\/\\\_  _\/\\\/////////\\\_  _\/\\\____\//\\\___  _\/\\\_____________       
*      __/\\\______\//\\\__  _\/\\\_______\/\\\_  _\/\\\_______\/\\\_  _\/\\\_____\//\\\__  _\/\\\_____________      
*       _\///\\\\\\\\\\\/___  _\/\\\_______\/\\\_  _\/\\\_______\/\\\_  _\/\\\______\//\\\_  _\/\\\\\\\\\\\\\\\_     
*        ___\///////////_____  _\///________\///__  _\///________\///__  _\///________\///__  _\///////////////__    
*                                       __                       _                            _  _           _       
*                                      (_     __    _  \/    _ _|_   |_| _  _  | _|_|_       |_|(_| _  o __ (_|      
*                                      __)|_| | \_/(/_ /    (_) |    | |(/_(_| |  |_| | /    | |__|(/_ | | |__|      
*                                                   _                                         __          _          
*                                       _ __  _|   |_) _ _|_ o  __ _ __  _ __ _|_    o __    |_     __ _ |_) _       
*                                      (_|| |(_|   | \(/_ |_ |  | (/_|||(/_| | |_    | | |   |__|_| | (_)|  (/_*/    
*                                                                                                                  
*                                                                                                                  
* SHARE Release 6.1.1
* Damiano Uccheddu - Netherlands Interdisciplinary Demographic Institute (NIDI-KNAW)
*                                                                                                                    
* Uccheddu, Damiano, Anne H. Gauthier, Nardi Steverink, and Tom Emery. "Gender and Socioeconomic Inequalities        
* in Health at Older Ages Across Different European Welfare Clusters: Evidence from SHARE Data, 2004–2015."        
* European Sociological Review (2019). https://doi.org/10.1093/esr/jcz007                                          
*

******************************************************************************************************************
    //Index\\
*---- [ 1. Preliminary settings & log file ]-------------------------------------------------------------------*
*---- [ 2. Descriptive Statistics ]----------------------------------------------------------------------------*
*---- [ 3. Regression analysis ]-------------------------------------------------------------------------------*
*---- [ 4. Supplementary analyses ]----------------------------------------------------------------------------*
*---- [ 5. Close ]---------------------------------------------------------------------------------------------*

******************************************************************************************************************




*---- [ 1. Preliminary settings & log file ]-------------------------------------------------------------------*

*>> Clear results window
capture log close
cls
clear
clear matrix
set max_memory .
set logtype text
set scheme s2mono
set more off

*>> Stata Version 
version 15.1

*>> Recording time Stata needs for running the do-file
display "$S_TIME  $S_DATE"
timer clear
timer on 1

log using "$share_logfile/Data Analysis.log", replace

use "$share_all_out/SHARE_ANALYSIS_6.1.1_v3.0.dta", clear

*>> Dataset panel settings: 
sort pid wave country 	// <- Sort the dataset by pid, wave, and country
xtset pid wave 			// <- Declare data to be panel data


*---- [ 2. Descriptive Statistics ]----------------------------------------------------------------------------*

*>> Missing cases
*	[text] page 351.
mdesc 		/// Missing values for each item were negligible: except for grip strength (8.58 per cent of missing), 
fi 			///	all items showed less than 4 per cent missing values.
FI* 		/// -> 	variable FI_osteopo~s was not used to create the dependent variable, 
age 		/// 	... hence it was not part of the analysis
dead 		///
sex 		///
country		///
marital 	///
nchild 		///
welfare 	///
isced 		/// 		
newincome 	///
newwealth 	///
wave		///
welfare     ///
pid 		

* 	[text] page 350.
ta dead if wave==1  // Out of the 21,407 respondents in the first wave of SHARE, 19,078 (89.1 per cent) provided valid information for the variables
                    // used in this study, and 13,955 of them (65.2 per cent) participated in at least one follow-up measurement.
                    // [...]
                    // Of the initial respondents, 18.4 per cent (3,939) died within 11 years of follow-up after the first interview.  

*>> Cronbach's alpha
*	[text] page 351.
alpha  			/// 	The reliability coefficient, Cronbach's alpha, for the 40 items, is 0.861, 
FI_bathing      /// 	which is commonly considered adequate to sum the items to a scale. 
FI_stairs       /// 
FI_garden       /// 
FI_dressing     /// 
FI_eating       /// 
FI_bed          /// 
FI_chair        /// 
FI_lift5kg      /// 
FI_money        /// 
FI_hotmeal      /// 
FI_arms         /// 
FI_shopping     /// 
FI_medications  /// 
FI_toilet       /// 
FI_walk100      /// 
FI_walkRoom     /// 
FI_arthritis    /// 
FI_cancer       /// 
FI_lungdisease  /// 
FI_diabetes     /// 
FI_heartattack  /// 
FI_hypertension /// 
FI_fracture     /// 
FI_stroke       /// 
FI_phactiv      /// 
FI_appetite     /// 
FI_bmi          /// 
FI_sad          /// 
FI_hopelessness /// 
FI_fatigue      /// 
FI_enjoyment    /// 
FI_orienti      /// 
FI_longtermill  /// 
FI_falling      /// 
FI_fearfall     /// 
FI_dizziness    /// 
FI_srh          /// 
FI_maxgrip      /// 
FI_phone        /// 
FI_parkinson, std casewise   


*>> Keep only the necessary variables
keep 		///
fi 			/// <- Dependent variable (frailty index)
age 		/// <- Demographic (x) variables
dead 		/// <- Respondent died before the last panel wave
sex 		/// <- Gender
country		/// <- Country of residence
marital 	/// <- Marital status
nchild 		/// <- Number of children 
welfare 	/// <- welfare clusters
isced 		/// <- SES variables
newincome 	/// <- Equivalized income
newwealth 	/// <- Equivalized wealth
wave		/// <- Time variable
pid 		//  <- personal ID (country and wave specific)


*	[text] page 350.
ta wave  // Out of the 21,407 respondents in the first wave of SHARE, 19,078 (89.1 per cent) provided valid information for the variables
         // used in this study, and 13,955 of them (65.2 per cent) participated in at least one follow-up measurement. 

*>> ISCED variable 
*	Education shouldn't change across waves, as mentioned by the SHARE_release_guide_6-1-1: 

*	Check:
sort pid wave
egen isced_change = sd(isced), by(pid)
tab  isced_change

*	List of ISCED values that vary within individuals across waves (the same is valid with non imputed values [(isced_f==3)])
// 	list pid wave isced isced_change if isced_change>0 & isced_change <. in 468/5378, sepby(pid)
count if isced_change>0 & isced_change <. // 551 individuals with varying ISCED across waves

*	Recode to missing the ISCED variable 
replace isced = -99 if isced_change > 0 & isced_change < . 
drop 	isced_change // drop the variable 
recode  isced (-99=.)  // (!) <-- isced re-coded as missing when it changes between waves (4149 changes made in the SHARE v6.1.0, here 551). 

*	Describe the missing cases in the dataset
mdesc 

*>> Drop missing cases 
drop if age 		== .
drop if sex 		== .
drop if fi 			== .
drop if isced 		== .
drop if newincome 	== .
drop if newwealth 	== .
drop if marital 	== .
drop if nchild 		== .
drop if wave 		== .
drop if country 	== .

*	Describe the missing cases in the dataset
mdesc

*	[text] page 350
ta wave                 // Out of the 21,407 respondents in the first wave of SHARE, 19,078 (89.1 per cent) provided valid information for the variables
di	(100*19078)/21407   // used in this study, and 13,955 of them (65.2 per cent) participated in at least one follow-up measurement. 


*>> Keep only the 'longitudinal' sample 
*	(those who were present in the wave 1 with at least one more valid observation in the subsequent waves)
xtpatternvar, gen(pattern) 	// generate a variable that contain the panel pattern
tab pattern 				// Let's see what it contains

* 	Describe the pattern of participation 
xtdes, pattern(200)

*>> Restriction of the sample to individuals who participate in the baseline year 
*	with at least two valid observations across the panel
bys pid: drop if pattern == "...1."
bys pid: drop if pattern == "..1.."
bys pid: drop if pattern == "....1"
bys pid: drop if pattern == ".1..."
bys pid: drop if pattern == "...11"
bys pid: drop if pattern == "..1.1"
bys pid: drop if pattern == "..11."
bys pid: drop if pattern == "..111"
bys pid: drop if pattern == ".1..1"
bys pid: drop if pattern == ".1.1."
bys pid: drop if pattern == ".1.11"
bys pid: drop if pattern == ".11.."
bys pid: drop if pattern == ".11.1"
bys pid: drop if pattern == ".111."
bys pid: drop if pattern == ".1111"

*	[text] 
xtdes, pattern(200)     // Out of the 21,407 respondents in the first wave of SHARE, 19,078
di  (100*13955)/21407   // (89.1 per cent) provided valid information for the variables
                        // used in this study, and 13,955 of them (65.2 per
                        // cent) participated in at least one follow-up measurement.


*>> Attrition description (Reviewer 3, Point 4.7, Tables S1-S5 Appendix 2 “Attrition Analysis” in the response letter)

*>> Generate a variable that identify the participation of interviewed in at least two waves
bys pid: gen nyear=[_N]
sort pid wave 
ta pattern nyear

*	Check when respondent left the panel before the end of the observation period
ta wave, miss

*>> Generate retention variable
gen 	stayed = . 
replace stayed = 0 if pattern == "1...." & dead != 1
replace stayed = 1 if pattern == "1...1" & dead != 1
replace stayed = 1 if pattern == "1..1." & dead != 1
replace stayed = 1 if pattern == "1..11" & dead != 1
replace stayed = 1 if pattern == "1.1.." & dead != 1
replace stayed = 1 if pattern == "1.1.1" & dead != 1
replace stayed = 1 if pattern == "1.11." & dead != 1
replace stayed = 1 if pattern == "1.111" & dead != 1
replace stayed = 1 if pattern == "11..." & dead != 1
replace stayed = 1 if pattern == "11..1" & dead != 1
replace stayed = 1 if pattern == "11.1." & dead != 1
replace stayed = 1 if pattern == "11.11" & dead != 1
replace stayed = 1 if pattern == "111.." & dead != 1
replace stayed = 1 if pattern == "111.1" & dead != 1
replace stayed = 1 if pattern == "1111." & dead != 1
replace stayed = 1 if pattern == "11111" & dead != 1

*>> Generate attrition variable
gen attrition = . 
replace attrition = 0 if stayed == 1 // "Stayed"
replace attrition = 1 if stayed	== 0 // "Left"
replace attrition = 2 if dead 	== 1 // "Died"

*>> Label the variable
lab var attrition "Attrition"
label define lab_attrition 	///
	0 "Stayed"				/// 
	1 "Left"				///
	2 "Died"				//
label values attrition lab_attrition

*	Check
ta attrition if wave==1

*>> Generating economic measures for attrition analysis
*	Equivalized income: (Quartiles, country- and wave-specific)
egen attrition_income = xtile(newincome), by(wave country) nq(4) // <- Quartiles
label variable attrition_income "Total HH income (Quartiles)"

*	Equivalized wealth: (Quartiles, country- and wave-specific)
egen attrition_wealth = xtile(newwealth), by(wave country) nq(4) // <- Quartiles
label variable attrition_wealth "Total HH wealth (Quartiles)"

*	Label both income and wealth
label define lab_quartile_number 	///
  1 "1st"							///
  2 "2nd"							///
  3 "3rd"							///
  4 "4th"
label values attrition_income attrition_wealth lab_quartile_number


*>> Attrition analysis, descriptive statistics
* 	General 
tablecol 	attrition sex country 				if wave==1, colpct
table 		attrition sex country 				if wave==1, c(mean fi sd fi) format(%9.2f)

* 	By sex and SES
tablecol 	attrition isced country 			if wave==1 & sex==0, colpct
tablecol 	attrition isced country 			if wave==1 & sex==1, colpct

tablecol 	attrition attrition_income country 	if wave==1 & sex==0, colpct
tablecol 	attrition attrition_income country 	if wave==1 & sex==1, colpct

tablecol 	attrition attrition_wealth country 	if wave==1 & sex==0, colpct
tablecol 	attrition attrition_wealth country 	if wave==1 & sex==1, colpct

* 	Tabulate 
table 		attrition  isced country 			if wave==1 & sex==0, c(mean fi sd fi) format(%9.2f)
table 		attrition  isced country 			if wave==1 & sex==1, c(mean fi sd fi) format(%9.2f)
table 		attrition  attrition_income country if wave==1 & sex==0, c(mean fi sd fi) format(%9.2f)
table 		attrition  attrition_income country if wave==1 & sex==1, c(mean fi sd fi) format(%9.2f)
table 		attrition  attrition_wealth country if wave==1 & sex==0, c(mean fi sd fi) format(%9.2f)
table 		attrition  attrition_wealth country if wave==1 & sex==1, c(mean fi sd fi) format(%9.2f)

* 	Tabulate
tablecol 	attrition sex 						if wave==1, colpct
tablecol 	attrition isced 					if wave==1, colpct
tablecol 	attrition attrition_income 			if wave==1, colpct
tablecol 	attrition attrition_wealth 			if wave==1, colpct
tablecol 	attrition country 					if wave==1, colpct


*>> Generate monotonous attrition
gen 	dropout = . 
replace dropout = 1 if pattern == "1...."
replace dropout = 1 if pattern != "1...." & dead == 1
replace dropout = 0 if pattern == "1...1" & dead != 1
replace dropout = 0 if pattern == "1..1." & dead != 1
replace dropout = 0 if pattern == "1..11" & dead != 1
replace dropout = 0 if pattern == "1.1.." & dead != 1
replace dropout = 0 if pattern == "1.1.1" & dead != 1
replace dropout = 0 if pattern == "1.11." & dead != 1
replace dropout = 0 if pattern == "1.111" & dead != 1
replace dropout = 0 if pattern == "11..." & dead != 1
replace dropout = 0 if pattern == "11..1" & dead != 1
replace dropout = 0 if pattern == "11.1." & dead != 1
replace dropout = 0 if pattern == "11.11" & dead != 1
replace dropout = 0 if pattern == "111.." & dead != 1
replace dropout = 0 if pattern == "111.1" & dead != 1
replace dropout = 0 if pattern == "1111." & dead != 1
replace dropout = 0 if pattern == "11111" & dead != 1


*>> Keep only those with at least two valid observations
bys pid: drop if pattern == "1...." 

* 	Check
ta patter if wave==1 	// <- Describe the panel pattern...
xtdes, pattern(200) 	// ...and compare it with the usual 'xtdes' command (here and above)

*>> Generation of new variables 
* 	Age squared variable 
gen age2=(age^2) 
gen age3=(age^3) 

*>> Generating economic measures
* 	Equivalized income: (Quartiles, country- and wave-specific)
egen income = xtile(newincome), by(wave country) nq(4) // <- Quartiles
label variable income "Total HH income (Quartiles)"

* 	Equivalized wealth: (Quartiles, country- and wave-specific)
egen wealth = xtile(newwealth), by(wave country) nq(4)
label variable wealth "Total HH wealth (Quartiles)"

* 	Labels to both income and wealth
label define lab_quartile 	///
  1 "First quartile" 		///
  2 "Second quartile" 		///
  3 "Third quartile" 		///
  4 "Fourth quartile"
label values income wealth lab_quartile


*>> Descriptive statistics
*	[text] page 350.
fre wave  // In total, these respondents provided 50,459 observations across five waves of SHARE 
          // (n2004/2005 = 13,955, n2006/2007 = 12,157, n2011/2012 = 8,896, n2013 = 8,137, and n2015 = 7,314), 
xtreg fi  // which is an average of 3.6 observations per person.


* [Table 1] Descriptive statistics of variables in the analyses - page 350.

*	Whole Sample
sum age
tab sex
sum fi
tab isced
tab income 
tab wealth
tab marital
tab nchild
tab wave
tab country

*	Male
sum age 	if sex==0
tab sex 	if sex==0
sum fi 		if sex==0
tab isced 	if sex==0
tab income  if sex==0
tab wealth 	if sex==0
tab marital if sex==0
tab nchild 	if sex==0
tab wave 	if sex==0
tab country if sex==0

*	Female
sum age 	if sex==1
tab sex 	if sex==1
sum fi 		if sex==1
tab isced 	if sex==1
tab income  if sex==1
tab wealth 	if sex==1
tab marital if sex==1
tab nchild 	if sex==1
tab wave 	if sex==1
tab country if sex==1

*>> Generation of new variables
*	Dummy variables from categorical independent variables
tab income 	, gen(income)
tab wealth 	, gen(wealth)
tab marital	, gen(marital)
tab nchild 	, gen(nchild)
tab wave   	, gen(wave)
tab sex    	, gen(sex)       // <- this is necessary when creating the interactions
tab welfare , gen(welfare)
tab isced 	, gen(isced)


*---- [ 3. Regression analysis ]-------------------------------------------------------------------------------*

*>> Calculate person specific mean
*	Continuous variables
egen mean_age 		= mean(age)	, by(pid)
egen mean_age2 		= mean(age2), by(pid)
egen mean_age3 		= mean(age3), by(pid)

*	Categorical variables
egen mean_income1  	= mean(income1)	  , by(pid)
egen mean_income2  	= mean(income2)	  , by(pid)
egen mean_income3  	= mean(income3)	  , by(pid)
egen mean_income4  	= mean(income4)	  , by(pid)
egen mean_wealth1  	= mean(wealth1)	  , by(pid)
egen mean_wealth2  	= mean(wealth2)	  , by(pid)
egen mean_wealth3  	= mean(wealth3)	  , by(pid)
egen mean_wealth4  	= mean(wealth4)	  , by(pid)
egen mean_marital1 	= mean(marital1)  , by(pid)
egen mean_marital2 	= mean(marital2)  , by(pid)
egen mean_marital3 	= mean(marital3)  , by(pid)
egen mean_marital4 	= mean(marital4)  , by(pid)
egen mean_nchild1  	= mean(nchild1)	  , by(pid)
egen mean_nchild2  	= mean(nchild2)	  , by(pid)
egen mean_nchild3  	= mean(nchild3)	  , by(pid)
egen mean_nchild4  	= mean(nchild4)	  , by(pid)
egen mean_wave1    	= mean(wave1)	  , by(pid)
egen mean_wave2    	= mean(wave2)	  , by(pid)
egen mean_wave3    	= mean(wave3)	  , by(pid)
egen mean_wave4    	= mean(wave4)	  , by(pid)
egen mean_wave5    	= mean(wave5)	  , by(pid)
egen mean_welfare1 	= mean(welfare1)  , by(pid)
egen mean_welfare2 	= mean(welfare2)  , by(pid)
egen mean_welfare3 	= mean(welfare3)  , by(pid)

*>> Calculate "deviation" variables 
*	Continuous variables
gen diff_age 		= age 	- mean_age
gen diff_age2 		= age2 	- mean_age2
gen diff_age3 		= age3 	- mean_age3

*	Categorical variables
gen diff_income1	= income1	- mean_income1
gen diff_income2	= income2	- mean_income2
gen diff_income3	= income3	- mean_income3
gen diff_income4	= income4	- mean_income4
gen diff_wealth1	= wealth1	- mean_wealth1
gen diff_wealth2	= wealth2	- mean_wealth2
gen diff_wealth3	= wealth3	- mean_wealth3
gen diff_wealth4	= wealth4	- mean_wealth4
gen diff_marital1	= marital1	- mean_marital1   	
gen diff_marital2	= marital2	- mean_marital2   	
gen diff_marital3	= marital3	- mean_marital3   	
gen diff_marital4	= marital4	- mean_marital4   	
gen diff_nchild1	= nchild1	- mean_nchild1    	
gen diff_nchild2	= nchild2	- mean_nchild2    	
gen diff_nchild3	= nchild3	- mean_nchild3    	
gen diff_nchild4	= nchild4	- mean_nchild4
gen diff_wave1		= wave1		- mean_wave1      	
gen diff_wave2		= wave2		- mean_wave2      	
gen diff_wave3		= wave3		- mean_wave3      	
gen diff_wave4		= wave4		- mean_wave4      	
gen diff_wave5		= wave5		- mean_wave5  
gen diff_welfare1	= welfare1	- mean_welfare1
gen diff_welfare2	= welfare2	- mean_welfare2
gen diff_welfare3	= welfare3	- mean_welfare3


*>> Two-way interaction term variables (gender * SES)
gen sex1Xisced = sex1*isced
by pid, sort: center sex1Xisced, prefix(diff_) mean(mean_)

gen sex1Xincome1 = sex1*income1
by pid, sort: center sex1Xincome1, prefix(diff_) mean(mean_)

gen sex1Xincome2 = sex1*income2
by pid, sort: center sex1Xincome2, prefix(diff_) mean(mean_)

gen sex1Xincome3 = sex1*income3
by pid, sort: center sex1Xincome3, prefix(diff_) mean(mean_)

gen sex1Xincome4 = sex1*income4
by pid, sort: center sex1Xincome4, prefix(diff_) mean(mean_)

gen sex1Xwealth1 = sex1*wealth1
by pid, sort: center sex1Xwealth1, prefix(diff_) mean(mean_)

gen sex1Xwealth2 = sex1*wealth2
by pid, sort: center sex1Xwealth2, prefix(diff_) mean(mean_)

gen sex1Xwealth3 = sex1*wealth3
by pid, sort: center sex1Xwealth3, prefix(diff_) mean(mean_)

gen sex1Xwealth4 = sex1*wealth4
by pid, sort: center sex1Xwealth4, prefix(diff_) mean(mean_)

gen sex2Xisced = sex2*isced
by pid, sort: center sex2Xisced, prefix(diff_) mean(mean_)

gen sex2Xincome1 = sex2*income1
by pid, sort: center sex2Xincome1, prefix(diff_) mean(mean_)

gen sex2Xincome2 = sex2*income2
by pid, sort: center sex2Xincome2, prefix(diff_) mean(mean_)

gen sex2Xincome3 = sex2*income3
by pid, sort: center sex2Xincome3, prefix(diff_) mean(mean_)

gen sex2Xincome4 = sex2*income4
by pid, sort: center sex2Xincome4, prefix(diff_) mean(mean_)

gen sex2Xwealth1 = sex2*wealth1
by pid, sort: center sex2Xwealth1, prefix(diff_) mean(mean_)

gen sex2Xwealth2 = sex2*wealth2
by pid, sort: center sex2Xwealth2, prefix(diff_) mean(mean_)

gen sex2Xwealth3 = sex2*wealth3
by pid, sort: center sex2Xwealth3, prefix(diff_) mean(mean_)

gen sex2Xwealth4 = sex2*wealth4
by pid, sort: center sex2Xwealth4, prefix(diff_) mean(mean_)


*>> Three-way interaction term variables (welfare * gender * SES)
*	ISCED
gen welfare1Xsex1Xisced1 = welfare1*sex1*isced1
by pid, sort: center welfare1Xsex1Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xisced1 = welfare2*sex1*isced1
by pid, sort: center welfare2Xsex1Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xisced1 = welfare3*sex1*isced1
by pid, sort: center welfare3Xsex1Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xisced1 = welfare1*sex2*isced1
by pid, sort: center welfare1Xsex2Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xisced1 = welfare2*sex2*isced1
by pid, sort: center welfare2Xsex2Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xisced1 = welfare3*sex2*isced1
by pid, sort: center welfare3Xsex2Xisced1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xisced2 = welfare1*sex1*isced2
by pid, sort: center welfare1Xsex1Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xisced2 = welfare2*sex1*isced2
by pid, sort: center welfare2Xsex1Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xisced2 = welfare3*sex1*isced2
by pid, sort: center welfare3Xsex1Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xisced2 = welfare1*sex2*isced2
by pid, sort: center welfare1Xsex2Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xisced2 = welfare2*sex2*isced2
by pid, sort: center welfare2Xsex2Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xisced2 = welfare3*sex2*isced2
by pid, sort: center welfare3Xsex2Xisced2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xisced3 = welfare1*sex1*isced3
by pid, sort: center welfare1Xsex1Xisced3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xisced3 = welfare2*sex1*isced3
by pid, sort: center welfare2Xsex1Xisced3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xisced3 = welfare3*sex1*isced3
by pid, sort: center welfare3Xsex1Xisced3, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xisced3 = welfare1*sex2*isced3
by pid, sort: center welfare1Xsex2Xisced3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xisced3 = welfare2*sex2*isced3
by pid, sort: center welfare2Xsex2Xisced3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xisced3 = welfare3*sex2*isced3
by pid, sort: center welfare3Xsex2Xisced3, prefix(t3diff_) mean(t3mean_)


*	INCOME
gen welfare1Xsex1Xincome1 = welfare1*sex1*income1
by pid, sort: center welfare1Xsex1Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xincome1 = welfare2*sex1*income1
by pid, sort: center welfare2Xsex1Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xincome1 = welfare3*sex1*income1
by pid, sort: center welfare3Xsex1Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xincome1 = welfare1*sex2*income1
by pid, sort: center welfare1Xsex2Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xincome1 = welfare2*sex2*income1
by pid, sort: center welfare2Xsex2Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xincome1 = welfare3*sex2*income1
by pid, sort: center welfare3Xsex2Xincome1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xincome2 = welfare1*sex1*income2
by pid, sort: center welfare1Xsex1Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xincome2 = welfare2*sex1*income2
by pid, sort: center welfare2Xsex1Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xincome2 = welfare3*sex1*income2
by pid, sort: center welfare3Xsex1Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xincome2 = welfare1*sex2*income2
by pid, sort: center welfare1Xsex2Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xincome2 = welfare2*sex2*income2
by pid, sort: center welfare2Xsex2Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xincome2 = welfare3*sex2*income2
by pid, sort: center welfare3Xsex2Xincome2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xincome3 = welfare1*sex1*income3
by pid, sort: center welfare1Xsex1Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xincome3 = welfare2*sex1*income3
by pid, sort: center welfare2Xsex1Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xincome3 = welfare3*sex1*income3
by pid, sort: center welfare3Xsex1Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xincome3 = welfare1*sex2*income3
by pid, sort: center welfare1Xsex2Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xincome3 = welfare2*sex2*income3
by pid, sort: center welfare2Xsex2Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xincome3 = welfare3*sex2*income3
by pid, sort: center welfare3Xsex2Xincome3, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xincome4 = welfare1*sex1*income4
by pid, sort: center welfare1Xsex1Xincome4, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xincome4 = welfare2*sex1*income4
by pid, sort: center welfare2Xsex1Xincome4, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xincome4 = welfare3*sex1*income4
by pid, sort: center welfare3Xsex1Xincome4, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xincome4 = welfare1*sex2*income4
by pid, sort: center welfare1Xsex2Xincome4, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xincome4 = welfare2*sex2*income4
by pid, sort: center welfare2Xsex2Xincome4, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xincome4 = welfare3*sex2*income4
by pid, sort: center welfare3Xsex2Xincome4, prefix(t3diff_) mean(t3mean_)


*	WEALTH
gen welfare1Xsex1Xwealth1 = welfare1*sex1*wealth1
by pid, sort: center welfare1Xsex1Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xwealth1 = welfare2*sex1*wealth1
by pid, sort: center welfare2Xsex1Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xwealth1 = welfare3*sex1*wealth1
by pid, sort: center welfare3Xsex1Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xwealth1 = welfare1*sex2*wealth1
by pid, sort: center welfare1Xsex2Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xwealth1 = welfare2*sex2*wealth1
by pid, sort: center welfare2Xsex2Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xwealth1 = welfare3*sex2*wealth1
by pid, sort: center welfare3Xsex2Xwealth1, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xwealth2 = welfare1*sex1*wealth2
by pid, sort: center welfare1Xsex1Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xwealth2 = welfare2*sex1*wealth2
by pid, sort: center welfare2Xsex1Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xwealth2 = welfare3*sex1*wealth2
by pid, sort: center welfare3Xsex1Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xwealth2 = welfare1*sex2*wealth2
by pid, sort: center welfare1Xsex2Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xwealth2 = welfare2*sex2*wealth2
by pid, sort: center welfare2Xsex2Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xwealth2 = welfare3*sex2*wealth2
by pid, sort: center welfare3Xsex2Xwealth2, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xwealth3 = welfare1*sex1*wealth3
by pid, sort: center welfare1Xsex1Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xwealth3 = welfare2*sex1*wealth3
by pid, sort: center welfare2Xsex1Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xwealth3 = welfare3*sex1*wealth3
by pid, sort: center welfare3Xsex1Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xwealth3 = welfare1*sex2*wealth3
by pid, sort: center welfare1Xsex2Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xwealth3 = welfare2*sex2*wealth3
by pid, sort: center welfare2Xsex2Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xwealth3 = welfare3*sex2*wealth3
by pid, sort: center welfare3Xsex2Xwealth3, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex1Xwealth4 = welfare1*sex1*wealth4
by pid, sort: center welfare1Xsex1Xwealth4, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex1Xwealth4 = welfare2*sex1*wealth4
by pid, sort: center welfare2Xsex1Xwealth4, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex1Xwealth4 = welfare3*sex1*wealth4
by pid, sort: center welfare3Xsex1Xwealth4, prefix(t3diff_) mean(t3mean_)

gen welfare1Xsex2Xwealth4 = welfare1*sex2*wealth4
by pid, sort: center welfare1Xsex2Xwealth4, prefix(t3diff_) mean(t3mean_)

gen welfare2Xsex2Xwealth4 = welfare2*sex2*wealth4
by pid, sort: center welfare2Xsex2Xwealth4, prefix(t3diff_) mean(t3mean_)

gen welfare3Xsex2Xwealth4 = welfare3*sex2*wealth4
by pid, sort: center welfare3Xsex2Xwealth4, prefix(t3diff_) mean(t3mean_)


*>> Hybrid (between-within) regression models
* 	Store independent variables into a macro (HY1)
global xvarsHY1 				///
				diff_age 		/// <-- Within effects
				diff_age2 		/// 
				diff_age3 		/// 
				diff_marital2   ///
				diff_marital3   ///
				diff_marital4   ///
				diff_marital1   ///
				diff_nchild2    ///
				diff_nchild3    ///
				diff_nchild4    ///
				diff_nchild1    ///
				diff_wave2      ///
				diff_wave3      ///
				diff_wave4      ///
				diff_wave5      ///
				diff_wave1      ///
				///				///
				mean_age 		/// <-- Between effects
				mean_age2 		///
				mean_age3 		///
				mean_marital2   ///
				mean_marital3   ///
				mean_marital4   ///
				mean_marital1   ///
				mean_nchild2    ///
				mean_nchild3    ///
				mean_nchild4    ///
				mean_nchild1    ///
				mean_wave2      ///
				mean_wave3      ///
				mean_wave4      ///
				mean_wave5      ///
				mean_wave1  	/// 
				i.isced 		// <-- Time constant variable


* 	Store independent variables into a macro (HY2)
global xvarsHY2 				///
				diff_age 		/// <-- Within effects
				diff_age2 		/// 
				diff_age3 		/// 
				diff_income2	///
				diff_income3	///
				diff_income4	///
				diff_income1	///
				diff_marital2   ///
				diff_marital3   ///
				diff_marital4   ///
				diff_marital1   ///
				diff_nchild2    ///
				diff_nchild3    ///
				diff_nchild4    ///
				diff_nchild1    ///
				diff_wave2      ///
				diff_wave3      ///
				diff_wave4      ///
				diff_wave5      ///
				diff_wave1      ///
				///				///
				mean_age 		/// <-- Between effects
				mean_age2 		///
				mean_age3 		///
				mean_income2 	///
				mean_income3 	///
				mean_income4 	///
				mean_income1	///
				mean_marital2   ///
				mean_marital3   ///
				mean_marital4   ///
				mean_marital1   ///
				mean_nchild2    ///
				mean_nchild3    ///
				mean_nchild4    ///
				mean_nchild1    ///
				mean_wave2      ///
				mean_wave3      ///
				mean_wave4      ///
				mean_wave5      ///
				mean_wave1  	/// 
				i.isced 		// <-- Time constant variable


* 	Store independent variables into a macro (HY3)
global xvarsHY3 				///
				diff_age 		/// <-- Within effects
				diff_age2 		/// 
				diff_age3 		/// 
				diff_income2	///
				diff_income3	///
				diff_income4	///
				diff_income1	///
				diff_wealth2	///
				diff_wealth3	///
				diff_wealth4	///
				diff_wealth1	///
				diff_marital2   ///
				diff_marital3   ///
				diff_marital4   ///
				diff_marital1   ///
				diff_nchild2    ///
				diff_nchild3    ///
				diff_nchild4    ///
				diff_nchild1    ///
				diff_wave2      ///
				diff_wave3      ///
				diff_wave4      ///
				diff_wave5      ///
				diff_wave1      ///
				///				///
				mean_age 		/// <-- Between effects
				mean_age2 		///
				mean_age3 		///
				mean_income2 	///
				mean_income3 	///
				mean_income4 	///
				mean_income1	///
				mean_wealth2 	///
				mean_wealth3 	///
				mean_wealth4 	///
				mean_wealth1 	///
				mean_marital2   ///
				mean_marital3   ///
				mean_marital4   ///
				mean_marital1   ///
				mean_nchild2    ///
				mean_nchild3    ///
				mean_nchild4    ///
				mean_nchild1    ///
				mean_wave2      ///
				mean_wave3      ///
				mean_wave4      ///
				mean_wave5      ///
				mean_wave1  	/// 
				i.isced 		// <-- Time constant variable

* 	Store independent variables into a macro (Interactions)
global xvarsHYinteractions 			///
				diff_age 			/// <-- Within effects
				diff_age2			///
				diff_age3	 		/// 
				diff_income2		///
				diff_income3		///
				diff_income4		///
				diff_income1		///
				diff_wealth2		///
				diff_wealth3		///
				diff_wealth4		///
				diff_wealth1		///
				diff_marital2   	///
				diff_marital3   	///
				diff_marital4   	///
				diff_marital1   	///
				diff_nchild2    	///
				diff_nchild3    	///
				diff_nchild4    	///
				diff_nchild1    	///
				diff_wave2      	///
				diff_wave3      	///
				diff_wave4      	///
				diff_wave5      	///
				diff_wave1      	///
				diff_sex2Xincome2  	///
				diff_sex2Xincome3  	///
				diff_sex2Xincome4  	///
				diff_sex2Xwealth2  	///
				diff_sex2Xwealth3  	///
				diff_sex2Xwealth4  	///
				diff_sex1Xincome2  	///
				diff_sex1Xincome3  	///
				diff_sex1Xincome4  	///
				diff_sex1Xwealth2  	///
				diff_sex1Xwealth3  	///
				diff_sex1Xwealth4  	///
				///					/// 
				mean_age 			/// <-- Between effects
				mean_age2			///
				mean_age3	 		///
				mean_income2 		///
				mean_income3 		///
				mean_income4 		///
				mean_income1		///
				mean_wealth2 		///
				mean_wealth3 		///
				mean_wealth4 		///
				mean_wealth1 		///
				mean_marital2   	///
				mean_marital3   	///
				mean_marital4   	///
				mean_marital1   	///
				mean_nchild2    	///
				mean_nchild3    	///
				mean_nchild4    	///
				mean_nchild1    	///
				mean_wave2      	///
				mean_wave3      	///
				mean_wave4      	///
				mean_wave5      	///
				mean_wave1      	///
				mean_sex2Xincome2  	///
				mean_sex2Xincome3  	///
				mean_sex2Xincome4  	///
				mean_sex2Xwealth2  	///
				mean_sex2Xwealth3  	///
				mean_sex2Xwealth4  	///
				mean_sex1Xincome2  	///
				mean_sex1Xincome3  	///
				mean_sex1Xincome4  	///
				mean_sex1Xwealth2  	///
				mean_sex1Xwealth3  	///
				mean_sex1Xwealth4  	///
				i.sex 				/// <- Time constant variables
				i.isced 			///
				sex#isced 

*>> Generate lagged variables 
sort pid wave
by pid: gen lag_diff_age 			=	diff_age[_n-1]
by pid: gen lag_diff_age2			=	diff_age2[_n-1]
by pid: gen lag_diff_age3	 		=	diff_age3[_n-1]
by pid: gen lag_diff_income2		=	diff_income2[_n-1]
by pid: gen lag_diff_income3		=	diff_income3[_n-1]
by pid: gen lag_diff_income4		=	diff_income4[_n-1]
by pid: gen lag_diff_income1		=	diff_income1[_n-1]
by pid: gen lag_diff_wealth2		=	diff_wealth2[_n-1]
by pid: gen lag_diff_wealth3		=	diff_wealth3[_n-1]
by pid: gen lag_diff_wealth4		=	diff_wealth4[_n-1]
by pid: gen lag_diff_wealth1		=	diff_wealth1[_n-1]
by pid: gen lag_diff_marital2   	=	diff_marital2[_n-1]
by pid: gen lag_diff_marital3   	=	diff_marital3[_n-1]
by pid: gen lag_diff_marital4   	=	diff_marital4[_n-1]
by pid: gen lag_diff_marital1   	=	diff_marital1[_n-1]
by pid: gen lag_diff_nchild2    	=	diff_nchild2[_n-1]
by pid: gen lag_diff_nchild3    	=	diff_nchild3[_n-1]
by pid: gen lag_diff_nchild4    	=	diff_nchild4[_n-1]
by pid: gen lag_diff_nchild1    	=	diff_nchild1[_n-1]
by pid: gen lag_diff_wave2      	=	diff_wave2[_n-1]
by pid: gen lag_diff_wave3      	=	diff_wave3[_n-1]
by pid: gen lag_diff_wave4      	=	diff_wave4[_n-1]
by pid: gen lag_diff_wave5      	=	diff_wave5[_n-1]
by pid: gen lag_diff_wave1      	=	diff_wave1[_n-1]
by pid: gen lag_diff_sex2Xincome2  	=	diff_sex2Xincome2[_n-1]
by pid: gen lag_diff_sex2Xincome3  	=	diff_sex2Xincome3[_n-1]
by pid: gen lag_diff_sex2Xincome4  	=	diff_sex2Xincome4[_n-1]
by pid: gen lag_diff_sex2Xwealth2  	=	diff_sex2Xwealth2[_n-1]
by pid: gen lag_diff_sex2Xwealth3  	=	diff_sex2Xwealth3[_n-1]
by pid: gen lag_diff_sex2Xwealth4  	=	diff_sex2Xwealth4[_n-1]
by pid: gen lag_diff_sex1Xincome2  	=	diff_sex1Xincome2[_n-1]
by pid: gen lag_diff_sex1Xincome3  	=	diff_sex1Xincome3[_n-1]
by pid: gen lag_diff_sex1Xincome4  	=	diff_sex1Xincome4[_n-1]
by pid: gen lag_diff_sex1Xwealth2  	=	diff_sex1Xwealth2[_n-1]
by pid: gen lag_diff_sex1Xwealth3  	=	diff_sex1Xwealth3[_n-1]
by pid: gen lag_diff_sex1Xwealth4  	=	diff_sex1Xwealth4[_n-1]
by pid: gen lag_mean_age 			=	mean_age[_n-1]
by pid: gen lag_mean_age2			=	mean_age2[_n-1]
by pid: gen lag_mean_age3	 		=	mean_age3[_n-1]
by pid: gen lag_mean_income2 		=	mean_income2[_n-1]
by pid: gen lag_mean_income3 		=	mean_income3[_n-1]
by pid: gen lag_mean_income4 		=	mean_income4[_n-1]
by pid: gen lag_mean_income1		=	mean_income1[_n-1]
by pid: gen lag_mean_wealth2 		=	mean_wealth2[_n-1]
by pid: gen lag_mean_wealth3 		=	mean_wealth3[_n-1]
by pid: gen lag_mean_wealth4 		=	mean_wealth4[_n-1]
by pid: gen lag_mean_wealth1 		=	mean_wealth1[_n-1]
by pid: gen lag_mean_marital2   	=	mean_marital2[_n-1]
by pid: gen lag_mean_marital3   	=	mean_marital3[_n-1]
by pid: gen lag_mean_marital4   	=	mean_marital4[_n-1]
by pid: gen lag_mean_marital1   	=	mean_marital1[_n-1]
by pid: gen lag_mean_nchild2    	=	mean_nchild2[_n-1]
by pid: gen lag_mean_nchild3    	=	mean_nchild3[_n-1]
by pid: gen lag_mean_nchild4    	=	mean_nchild4[_n-1]
by pid: gen lag_mean_nchild1    	=	mean_nchild1[_n-1]
by pid: gen lag_mean_wave2      	=	mean_wave2[_n-1]
by pid: gen lag_mean_wave3      	=	mean_wave3[_n-1]
by pid: gen lag_mean_wave4      	=	mean_wave4[_n-1]
by pid: gen lag_mean_wave5      	=	mean_wave5[_n-1]
by pid: gen lag_mean_wave1      	=	mean_wave1[_n-1]
by pid: gen lag_mean_sex2Xincome2  	=	mean_sex2Xincome2[_n-1]
by pid: gen lag_mean_sex2Xincome3  	=	mean_sex2Xincome3[_n-1]
by pid: gen lag_mean_sex2Xincome4  	=	mean_sex2Xincome4[_n-1]
by pid: gen lag_mean_sex2Xwealth2  	=	mean_sex2Xwealth2[_n-1]
by pid: gen lag_mean_sex2Xwealth3  	=	mean_sex2Xwealth3[_n-1]
by pid: gen lag_mean_sex2Xwealth4  	=	mean_sex2Xwealth4[_n-1]
by pid: gen lag_mean_sex1Xincome2  	=	mean_sex1Xincome2[_n-1]
by pid: gen lag_mean_sex1Xincome3  	=	mean_sex1Xincome3[_n-1]
by pid: gen lag_mean_sex1Xincome4  	=	mean_sex1Xincome4[_n-1]
by pid: gen lag_mean_sex1Xwealth2  	=	mean_sex1Xwealth2[_n-1]
by pid: gen lag_mean_sex1Xwealth3  	=	mean_sex1Xwealth3[_n-1]
by pid: gen lag_mean_sex1Xwealth4  	=	mean_sex1Xwealth4[_n-1]
by pid: gen lag_sex 				=	sex[_n-1]
by pid: gen lag_isced 				=	isced[_n-1]

* 	Store independent variables into a macro (HY3 lagged)
global xvarsHY3lag 					///
				lag_diff_age 		/// <-- Within effects
				lag_diff_age2 		/// 
				lag_diff_age3 		/// 
				lag_diff_income2	///
				lag_diff_income3	///
				lag_diff_income4	///
				lag_diff_income1	///
				lag_diff_wealth2	///
				lag_diff_wealth3	///
				lag_diff_wealth4	///
				lag_diff_wealth1	///
				lag_diff_marital2   ///
				lag_diff_marital3   ///
				lag_diff_marital4   ///
				lag_diff_marital1   ///
				lag_diff_nchild2    ///
				lag_diff_nchild3    ///
				lag_diff_nchild4    ///
				lag_diff_nchild1    ///
				lag_diff_wave2      ///
				lag_diff_wave3      ///
				lag_diff_wave4      ///
				lag_diff_wave5      ///
				lag_diff_wave1      ///
				///
				lag_mean_age 		/// <-- Between effects
				lag_mean_age2 		///
				lag_mean_age3 		///
				lag_mean_income2 	///
				lag_mean_income3 	///
				lag_mean_income4 	///
				lag_mean_income1	///
				lag_mean_wealth2 	///
				lag_mean_wealth3 	///
				lag_mean_wealth4 	///
				lag_mean_wealth1 	///
				lag_mean_marital2   ///
				lag_mean_marital3   ///
				lag_mean_marital4   ///
				lag_mean_marital1   ///
				lag_mean_nchild2    ///
				lag_mean_nchild3    ///
				lag_mean_nchild4    ///
				lag_mean_nchild1    ///
				lag_mean_wave2      ///
				lag_mean_wave3      ///
				lag_mean_wave4      ///
				lag_mean_wave5      ///
				lag_mean_wave1  	/// 
				i.lag_isced 		// <-- Time constant variable



* 	Store independent variables into a macro (HY3 lagged with interactions)
global xvarsHYinteractions_lag 			///
				lag_diff_age 			/// <-- Within effects
				lag_diff_age2			///
				lag_diff_age3	 		/// 
				lag_diff_income2		///
				lag_diff_income3		///
				lag_diff_income4		///
				lag_diff_income1		///
				lag_diff_wealth2		///
				lag_diff_wealth3		///
				lag_diff_wealth4		///
				lag_diff_wealth1		///
				lag_diff_marital2   	///
				lag_diff_marital3   	///
				lag_diff_marital4   	///
				lag_diff_marital1   	///
				lag_diff_nchild2    	///
				lag_diff_nchild3    	///
				lag_diff_nchild4    	///
				lag_diff_nchild1    	///
				lag_diff_wave2      	///
				lag_diff_wave3      	///
				lag_diff_wave4      	///
				lag_diff_wave5      	///
				lag_diff_wave1      	///
				lag_diff_sex2Xincome2  	///
				lag_diff_sex2Xincome3  	///
				lag_diff_sex2Xincome4  	///
				lag_diff_sex2Xwealth2  	///
				lag_diff_sex2Xwealth3  	///
				lag_diff_sex2Xwealth4  	///
				lag_diff_sex1Xincome2  	///
				lag_diff_sex1Xincome3  	///
				lag_diff_sex1Xincome4  	///
				lag_diff_sex1Xwealth2  	///
				lag_diff_sex1Xwealth3  	///
				lag_diff_sex1Xwealth4  	///
										/// 
				lag_mean_age 			/// <-- Between effects
				lag_mean_age2			///
				lag_mean_age3	 		///
				lag_mean_income2 		///
				lag_mean_income3 		///
				lag_mean_income4 		///
				lag_mean_income1		///
				lag_mean_wealth2 		///
				lag_mean_wealth3 		///
				lag_mean_wealth4 		///
				lag_mean_wealth1 		///
				lag_mean_marital2   	///
				lag_mean_marital3   	///
				lag_mean_marital4   	///
				lag_mean_marital1   	///
				lag_mean_nchild2    	///
				lag_mean_nchild3    	///
				lag_mean_nchild4    	///
				lag_mean_nchild1    	///
				lag_mean_wave2      	///
				lag_mean_wave3      	///
				lag_mean_wave4      	///
				lag_mean_wave5      	///
				lag_mean_wave1      	///
				lag_mean_sex2Xincome2  	///
				lag_mean_sex2Xincome3  	///
				lag_mean_sex2Xincome4  	///
				lag_mean_sex2Xwealth2  	///
				lag_mean_sex2Xwealth3  	///
				lag_mean_sex2Xwealth4  	///
				lag_mean_sex1Xincome2  	///
				lag_mean_sex1Xincome3  	///
				lag_mean_sex1Xincome4  	///
				lag_mean_sex1Xwealth2  	///
				lag_mean_sex1Xwealth3  	///
				lag_mean_sex1Xwealth4  	///
				i.lag_sex 				/// <- Time constant variables
				i.lag_isced 			///
				lag_sex#lag_isced 

* 	Store independent variables into a macro (robustness check without controls for number of children and marital status)
global xvarsHY3chmarit 			///
				diff_age 		/// <-- Within effects
				diff_age2 		/// 
				diff_age3 		/// 
				diff_income2	///
				diff_income3	///
				diff_income4	///
				diff_income1	///
				diff_wealth2	///
				diff_wealth3	///
				diff_wealth4	///
				diff_wealth1	///
				diff_wave2      ///
				diff_wave3      ///
				diff_wave4      ///
				diff_wave5      ///
				diff_wave1      ///
				///				///
				mean_age 		/// <-- Between effects
				mean_age2 		///
				mean_age3 		///
				mean_income2 	///
				mean_income3 	///
				mean_income4 	///
				mean_income1	///
				mean_wealth2 	///
				mean_wealth3 	///
				mean_wealth4 	///
				mean_wealth1 	///
				mean_wave2      ///
				mean_wave3      ///
				mean_wave4      ///
				mean_wave5      ///
				mean_wave1  	/// 
				i.isced 		// <-- Time constant variable


* 	Store independent variables into a macro 
*	(robustness check without controls for number of children and marital status [Interaction terms])
global xvarsHYinteractions_chmarit 	///
				diff_age 			/// <-- Within effects
				diff_age2			///
				diff_age3	 		/// 
				diff_income2		///
				diff_income3		///
				diff_income4		///
				diff_income1		///
				diff_wealth2		///
				diff_wealth3		///
				diff_wealth4		///
				diff_wealth1		///
				diff_wave2      	///
				diff_wave3      	///
				diff_wave4      	///
				diff_wave5      	///
				diff_wave1      	///
				diff_sex2Xincome2  	///
				diff_sex2Xincome3  	///
				diff_sex2Xincome4  	///
				diff_sex2Xwealth2  	///
				diff_sex2Xwealth3  	///
				diff_sex2Xwealth4  	///
				diff_sex1Xincome2  	///
				diff_sex1Xincome3  	///
				diff_sex1Xincome4  	///
				diff_sex1Xwealth2  	///
				diff_sex1Xwealth3  	///
				diff_sex1Xwealth4  	///
									/// 
				mean_age 			/// <-- Between effects
				mean_age2			///
				mean_age3	 		///
				mean_income2 		///
				mean_income3 		///
				mean_income4 		///
				mean_income1		///
				mean_wealth2 		///
				mean_wealth3 		///
				mean_wealth4 		///
				mean_wealth1 		///
				mean_wave2      	///
				mean_wave3      	///
				mean_wave4      	///
				mean_wave5      	///
				mean_wave1      	///
				mean_sex2Xincome2  	///
				mean_sex2Xincome3  	///
				mean_sex2Xincome4  	///
				mean_sex2Xwealth2  	///
				mean_sex2Xwealth3  	///
				mean_sex2Xwealth4  	///
				mean_sex1Xincome2  	///
				mean_sex1Xincome3  	///
				mean_sex1Xincome4  	///
				mean_sex1Xwealth2  	///
				mean_sex1Xwealth3  	///
				mean_sex1Xwealth4  	///
				i.sex 				/// <- Time constant variables
				i.isced 			///
				sex#isced 

* 	Store independent variables into a macro (Three-way interaction term variables (welfare * gender * SES))
global xvarsHYt3interactions			///
	diff_age						/// <-- Within effects
	diff_age2						///
	diff_age3						/// 
	diff_income2					///
	diff_income3					///
	diff_income4					///
	diff_income1					///
	diff_wealth2					///
	diff_wealth3					///
	diff_wealth4					///
	diff_wealth1					///
	diff_marital2					///
	diff_marital3					///
	diff_marital4					///
	diff_marital1					///
	diff_nchild2					///
	diff_nchild3					///
	diff_nchild4					///
	diff_nchild1					///
	diff_wave2						///
	diff_wave3						///
	diff_wave4						///
	diff_wave5						///
	diff_wave1						///
	t3diff_welfare2Xsex2Xincome2	///
	t3diff_welfare3Xsex2Xincome2	///
	t3diff_welfare2Xsex2Xincome3	///
	t3diff_welfare3Xsex2Xincome3	///
	t3diff_welfare2Xsex2Xincome4	///
	t3diff_welfare3Xsex2Xincome4	///
	t3diff_welfare2Xsex2Xwealth2	///
	t3diff_welfare3Xsex2Xwealth2	///
	t3diff_welfare2Xsex2Xwealth3	///
	t3diff_welfare3Xsex2Xwealth3	///
	t3diff_welfare2Xsex2Xwealth4	///
	t3diff_welfare3Xsex2Xwealth4	///
	///								/// 
	mean_age						/// <-- Between effects
	mean_age2						///
	mean_age3						///
	mean_income2					///
	mean_income3					///
	mean_income4					///
	mean_income1					///
	mean_wealth2					///
	mean_wealth3					///
	mean_wealth4					///
	mean_wealth1					///
	mean_marital2					///
	mean_marital3					///
	mean_marital4					///
	mean_marital1					///
	mean_nchild2					///
	mean_nchild3					///
	mean_nchild4					///
	mean_nchild1					///
	mean_wave2						///
	mean_wave3						///
	mean_wave4						///
	mean_wave5						///
	mean_wave1						///
	t3mean_welfare2Xsex2Xincome2	///
	t3mean_welfare3Xsex2Xincome2	///
	t3mean_welfare2Xsex2Xincome3	///
	t3mean_welfare3Xsex2Xincome3	///
	t3mean_welfare2Xsex2Xincome4	///
	t3mean_welfare3Xsex2Xincome4	///
	t3mean_welfare2Xsex2Xwealth2	///
	t3mean_welfare3Xsex2Xwealth2	///
	t3mean_welfare2Xsex2Xwealth3	///
	t3mean_welfare3Xsex2Xwealth3	///
	t3mean_welfare2Xsex2Xwealth4	///
	t3mean_welfare3Xsex2Xwealth4	///
	i.sex							/// <- Time constant variables
	i.isced							///
	i.welfare						/// 
	i.country						/// 
	welfare#sex#isced


*-----------------------------------------------------------------------------------------------* 
*>> Random-effects (RE) models 
*-----------------------------------------------------------------------------------------------* 

*>> Store independent variables (to be used in the regression models) into a macro
global xvarsRE 							/// (independent variables for the RE models)
				i.sex 		  			///
				age 		  			///
				c.age#c.age   			///
				c.age#c.age#c.age   	///
				i.isced 	  			///
				i.income 	  			///
				i.wealth 	  			///
				i.marital 	  			///
				i.nchild 	  			///
				i.wave

*>> Store independent variables (to be used in the regression models) into a macro
global xvarsREinteractions 			/// (independent variables for the RE (random effects) models with interactions)
				i.sex 				///
				sex#isced 			///
				sex#income 			///
				sex#wealth 			///
				age 				///
				c.age#c.age   		///
				c.age#c.age#c.age 	///
				i.isced 			/// 
				i.income 			///
				i.wealth 			///
				i.marital 			///
				i.nchild 			///
				i.wave


*>> Number of groups in estadd 
*>> Pull the single element of the matrix into a local and estadd it
global estadd_part1 	matrix N_g = e(N_g)
global estadd_part2 	local groups = N_g[1,1]
global estadd_part3 	estadd local groups `groups'
global estadd_Ngroups 	`"`estadd_part1' `estadd_part2' `estadd_part3'"'

global Wald_part1 		`"test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)"'
global Wald_part2 		`"test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)"'
global Wald_part3 		`"test (0.isced=0) (1.isced=0) (2.isced=0)"'
global Wald_part4 		`"test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)"'
global Wald_part5 		`"test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0)"'
global Wald_test 		`"`Wald_part1' `Wald_part2' `Wald_part3' `Wald_part4' `Wald_part5'"'


*>> Margins
global mar_isced1 		`"margins, dydx(sex) over(isced)"'
global mar_isced2 		`"margins isced#sex, at(age=(65) marital=(0) nchild=(1)) atmeans"'
global mar_isced 		`"`$mar_isced1' `$mar_isced2'"'

global mar_income1 		`"margins, dydx(sex) over(income) "'
global mar_income2 		`"margins income#sex, at(age=(65) marital=(0) nchild=(1)) atmeans"'
global mar_income 		`"`mar_income1' `mar_income2'"'

global mar_wealth1 		`"margins, dydx(sex) over(wealth)"'
global mar_wealth2 		`"margins wealth#sex, at(age=(65) marital=(0) nchild=(1)) atmeans"'
global mar_wealth 		`"`mar_wealth1' `mar_wealth2'"'


*-----------------------------------------------------------------------------------------------* 
*>> Inverse probability weighting (IPW)
*-----------------------------------------------------------------------------------------------* 

*>> Create an indicator of whether an observation is in the estimation sample for the model (or not) at time t
*	Check also https://www.stata.com/support/faqs/data-management/identifying-runs-of-consecutive-observations/

*>> Runs of consecutive observations
gen runs = . 
by pid: replace runs = cond(L.runs == ., 1, L.runs + 1)
by pid: egen maxrun = max(runs)

*>> Individual is in the sample 
*	Generate the variable 
gen inthesamp = . 
by pid: replace inthesamp = 1 if f.runs-runs==1
by pid: replace inthesamp = 0 if pattern=="1...1" & wave==1
by pid: replace inthesamp = 0 if pattern=="1..1." & wave==1
by pid: replace inthesamp = 0 if pattern=="1..11" & wave==1
by pid: replace inthesamp = 0 if pattern=="1.1.." & wave==1
by pid: replace inthesamp = 0 if pattern=="1.1.1" & wave==1
by pid: replace inthesamp = 0 if pattern=="1.11." & wave==1
by pid: replace inthesamp = 0 if pattern=="1.111" & wave==1
by pid: replace inthesamp = 0 if pattern=="11..." & wave==2
by pid: replace inthesamp = 0 if pattern=="11..1" & wave==2
by pid: replace inthesamp = 0 if pattern=="11.1." & wave==2
by pid: replace inthesamp = 0 if pattern=="11.11" & wave==2
by pid: replace inthesamp = 0 if pattern=="1.1.." & wave==3
by pid: replace inthesamp = 0 if pattern=="1.1.1" & wave==3
by pid: replace inthesamp = 0 if pattern=="111.." & wave==3
by pid: replace inthesamp = 0 if pattern=="111.1" & wave==3
by pid: replace inthesamp = 0 if pattern=="1..1." & wave==4
by pid: replace inthesamp = 0 if pattern=="1.11." & wave==4
by pid: replace inthesamp = 0 if pattern=="11.1." & wave==4
by pid: replace inthesamp = 0 if pattern=="1111." & wave==4
by pid: replace inthesamp = 0 if pattern=="1..1." & wave==5

*	Check 1
list pid wave inthesamp pattern if pattern=="1...1", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1..1.", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1..11", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1.1..", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1.1.1", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1.11.", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1.111", sepby(pid) 
list pid wave inthesamp pattern if pattern=="11...", sepby(pid) 
list pid wave inthesamp pattern if pattern=="11..1", sepby(pid) 
list pid wave inthesamp pattern if pattern=="11.1.", sepby(pid) 
list pid wave inthesamp pattern if pattern=="11.11", sepby(pid) 
list pid wave inthesamp pattern if pattern=="111..", sepby(pid) 
list pid wave inthesamp pattern if pattern=="111.1", sepby(pid) 
list pid wave inthesamp pattern if pattern=="1111.", sepby(pid) 
list pid wave inthesamp pattern if pattern=="11111", sepby(pid) 

*	Check 2
ta pattern inthesamp if wave==2 // The N of pattern == "11111" must be equal to the N of pattern == "11111" in the following command
xtdes 

*>> Include the predictors of the variable "inthesamp" in a global variable list
global z1 "fi i.sex age i.isced i.income i.wealth i.marital i.nchild i.country" 

*	These variables are used in a sequence of probit [logit] models (for Wooldridge there's not a difference)
*	for response versus non-response: 
	*	The dependent variable is "inthesamp", which indicates whether an observation is in the 
	*	estimation sample in the subsequent wave. The logit models are estimated at each wave of the panel, 
	*	from wave 2 to wave 6, using the full sample of individuals who are observed at wave 1. 
	*	The whole loop is executed quietly as its purpose is just to create the new variable "ipw": 
	*	the inverse of the fitted probability of responding. As an illustration, I also show how the 
	*	inverse Mills ratios ("imr") could also be created and saved if this 
	*	procedure was being used to do Heckman-type sample selection correction.

forvalues j=1(1)4 {
	logit inthesamp $z1 if (wave==`j')
	predict p`j', p 
	predict lc`j', xb
	gen imr`j'=normalden(lc`j')/normprob(lc`j')
	gen ipw`j'=1/p`j'
}

gen imr=0
forvalues k=1(1)4 {
	replace imr=imr`k' if wave== `k'
}

gen ipw =1
forvalues k=1(1)4 {
	replace ipw=ipw`k' if wave==`k'
}

*>> Check
sum ipw imr 
sum ipw imr if wave==5 
bys pattern:sum ipw
sort pid wave 
list pid wave inthesamp pattern ipw, sepby(pid)



*-----------------------------------------------------------------------------------------------* 
*>> Hausman tests
*-----------------------------------------------------------------------------------------------* 

qui xtreg fi $xvarsRE i.country if sex==0, fe 
estimate store fixedM

qui xtreg fi $xvarsRE i.country if sex==1, fe 
estimate store fixedF

qui xtreg fi $xvarsRE i.country if sex==0, re
estimate store randomM

qui xtreg fi $xvarsRE i.country if sex==1, re
estimate store randomF

hausman fixedM randomM, sigmamore 
hausman fixedF randomF, sigmamore 

// A significant Hausman test is often taken to mean that the random-intercept model should be abandoned in favor of a fixed-effects model 
// that only uses within information. However, if there are covariates having the same within and between effects, we obtain more precise 
// estimates of these coefficients by exploiting both within- and between-cluster information. The fixed-effects estimators are particularly 
// imprecise if the covariates have little within-cluster variation. If the (true) between and within effects differ by a small amount, it 
// may still be advisable to use the random-effects es- timator because it may have a smaller mean squared error (some bias but considerably 
// smaller variance) than the fixed-effects estimator.



*>> Labels for the graphs

label variable diff_income2 "Second quartile"
label variable mean_income2 "Second quartile"
label variable diff_wealth2 "Second quartile"
label variable mean_wealth2 "Second quartile"

label variable diff_income3 "Third quartile"
label variable mean_income3 "Third quartile"
label variable diff_wealth3 "Third quartile"
label variable mean_wealth3 "Third quartile"

label variable diff_income4 "Fourth quartile"
label variable mean_income4 "Fourth quartile"
label variable diff_wealth4 "Fourth quartile"
label variable mean_wealth4 "Fourth quartile"


*-----------------------------------------------------------------------------------------------* 
*>> Between-within variance 
*-----------------------------------------------------------------------------------------------* 

*>> [text] Table 2. Variance composition for Frailty Index
xtsum fi // (page 353 in the published article)

*>> [text] Table 3. Variance composition for level of education, income, and wealth
xttab isced
xttab income
xttab wealth


*-----------------------------------------------------------------------------------------------* 
*>> Hybrid (within-between) regression models 
*-----------------------------------------------------------------------------------------------* 

*>> Hybrid Regression models (separately by welfare cluster)
eststo clear


*>> Southern 
*	Men 

* Southern_Male
eststo Southern_Male1: 	mixed fi $xvarsHY1 ib15.country || pid: [pw=ipw] if welfare==0 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Southern_Male2: 	mixed fi $xvarsHY2 ib15.country || pid: [pw=ipw] if welfare==0 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Southern_Male3: 	mixed fi $xvarsHY3 ib15.country || pid: [pw=ipw] if welfare==0 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)


*	Women 
* Southern_Female
eststo Southern_Female1: mixed fi $xvarsHY1 ib15.country || pid: [pw=ipw] if welfare==0 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Southern_Female2: mixed fi $xvarsHY2 ib15.country || pid: [pw=ipw] if welfare==0 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Southern_Female3: mixed fi $xvarsHY3 ib15.country || pid: [pw=ipw] if welfare==0 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)
test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0) 


* Interactions (Table 4)
eststo SouthernINTER: mixed fi $xvarsHYinteractions ib15.country || pid: [pw=ipw] if welfare==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_sex2Xincome2=0) (diff_sex2Xincome3=0) (diff_sex2Xincome4=0)
test (diff_sex2Xwealth2=0) (diff_sex2Xwealth3=0) (diff_sex2Xwealth4=0)
test (mean_sex2Xincome2=0) (mean_sex2Xincome3=0) (mean_sex2Xincome4=0)
test (mean_sex2Xwealth2=0) (mean_sex2Xwealth3=0) (mean_sex2Xwealth4=0)
test (0.isced#1.sex=0) (1.isced#1.sex=0) (2.isced#1.sex=0)


*>> Western  
*	Men 

* Western_Male
eststo Western_Male1:	mixed fi $xvarsHY1 ib11.country || pid: [pw=ipw] if welfare==1 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Western_Male2:	mixed fi $xvarsHY2 ib11.country || pid: [pw=ipw] if welfare==1 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Western_Male3:	mixed fi $xvarsHY3 ib11.country || pid: [pw=ipw] if welfare==1 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)
test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0)


*	Women 
* Western_Female
eststo Western_Female1:	mixed fi $xvarsHY1 ib11.country || pid: [pw=ipw] if welfare==1 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Western_Female2:	mixed fi $xvarsHY2 ib11.country || pid: [pw=ipw] if welfare==1 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Western_Female3:	mixed fi $xvarsHY3 ib11.country || pid: [pw=ipw] if welfare==1 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)
test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0)

* Interactions  (Table 4)
eststo WesternINTER:	 mixed fi $xvarsHYinteractions ib11.country || pid: [pw=ipw] if welfare==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_sex2Xincome2=0) (diff_sex2Xincome3=0) (diff_sex2Xincome4=0)
test (diff_sex2Xwealth2=0) (diff_sex2Xwealth3=0) (diff_sex2Xwealth4=0)
test (mean_sex2Xincome2=0) (mean_sex2Xincome3=0) (mean_sex2Xincome4=0)
test (mean_sex2Xwealth2=0) (mean_sex2Xwealth3=0) (mean_sex2Xwealth4=0)
test (0.isced#1.sex=0) (1.isced#1.sex=0) (2.isced#1.sex=0)



*>> Northern  
*	Men 

* Northern_Male
eststo Northern_Male1: 	mixed fi $xvarsHY1 ib13.country || pid: [pw=ipw] if welfare==2 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Northern_Male2: 	mixed fi $xvarsHY2 ib13.country || pid: [pw=ipw] if welfare==2 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Northern_Male3: 	mixed fi $xvarsHY3 ib13.country || pid: [pw=ipw] if welfare==2 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)
test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0)


*	Women 
* Northern_Female
eststo Northern_Female1: mixed fi $xvarsHY1 ib13.country || pid: [pw=ipw] if welfare==2 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Northern_Female2: mixed fi $xvarsHY2 ib13.country || pid: [pw=ipw] if welfare==2 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)

eststo Northern_Female3: mixed fi $xvarsHY3 ib13.country || pid: [pw=ipw] if welfare==2 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_income1=0) (diff_income2=0) (diff_income3=0) (diff_income4=0)
test (diff_wealth1=0) (diff_wealth2=0) (diff_wealth3=0) (diff_wealth4=0)
test (0.isced=0) (1.isced=0) (2.isced=0)
test (mean_income1=0) (mean_income2=0) (mean_income3=0) (mean_income4=0)
test (mean_wealth1=0) (mean_wealth2=0) (mean_wealth3=0) (mean_wealth4=0)

* Interactions  (Table 4)
eststo NorthernINTER: mixed fi $xvarsHYinteractions ib13.country || pid: [pw=ipw] if welfare==2, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

* Test that coefficients on diff_wealth1, diff_wealth2, diff_wealth3, and diff_wealth4 are jointly equal to 0 (Reviewer 1)
test (diff_sex2Xincome2=0) (diff_sex2Xincome3=0) (diff_sex2Xincome4=0)
test (diff_sex2Xwealth2=0) (diff_sex2Xwealth3=0) (diff_sex2Xwealth4=0)
test (mean_sex2Xincome2=0) (mean_sex2Xincome3=0) (mean_sex2Xincome4=0)
test (mean_sex2Xwealth2=0) (mean_sex2Xwealth3=0) (mean_sex2Xwealth4=0)
test (0.isced#1.sex=0) (1.isced#1.sex=0) (2.isced#1.sex=0)

esttab using "$tables_out/HY_welfare_sex.txt", /// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes 	///
		label constant obslast stats(N groups aic bic)


*-----------------------------------------------------------------------------------------------* 
*>> Figures
*-----------------------------------------------------------------------------------------------* 

*>> [text] Page 354. Figure 1 
coefplot 	(Southern_Male1, 	label(Model 1))	 																		/// 
			(Southern_Male2, 	label(Model 2) ms(Dh)) 																	///
			(Southern_Male3, 	label(Model 3)), bylabel(Men)		||													/// 
			(Southern_Female1, 	label(Model 1))	 																		/// 
			(Southern_Female2, 	label(Model 2) ms(Dh))  																///
			(Southern_Female3, 	label(Model 3)), bylabel(Women)		||													///
																														/// 
			, drop(_cons diff_age* diff_marital2 																		///
			diff_marital3 diff_marital4 diff_nchild2 diff_nchild3 diff_nchild4 diff_wave2 diff_wave3 					/// 
			diff_wave4 diff_wave5 mean_age* mean_marital2 mean_marital3 mean_marital4 mean_nchild2 						/// 
			mean_nchild3 mean_nchild4 mean_wave2 mean_wave3 mean_wave4 mean_wave5 Medium High *country*)  				///
			xline(0) order(diff_income2 diff_income3 diff_income4 diff_wealth2 diff_wealth3								/// 
			diff_wealth4 1.isced 2.isced mean_income2 mean_income3 mean_income4 mean_wealth2 mean_wealth3 mean_wealth4) ///
			headings(diff_income2 = `""{bf:Within Variance}" "{it:Income}""' 											///
			mean_income2 = "{it:Income}" 																				/// 
			diff_wealth2 = "{it:Wealth}" 																				///
			mean_wealth2 = "{it:Wealth}" 																				/// 
			1.isced = `""{bf:Between Variance}" "{it:Education}""', labs(vsmall)) legend(col(3) size(vsmall)) 			/// 
			ylab(, labs(vsmall)) xlabel(-.1 -.05 0 .05) 																/// 
			grid(glpattern(dash)) byopts(title("Southern"))
*	graph save
graph save "$figure_out/coefplotSouth.gph",  replace

*>> [text] Page 355. Figure 2 
coefplot 	(Western_Male1, 	label(Model 1))	 																		/// 
			(Western_Male2, 	label(Model 2) ms(Dh)) 																	///
			(Western_Male3, 	label(Model 3)), bylabel(Men)		||													/// 
			(Western_Female1, 	label(Model 1))	 																		/// 
			(Western_Female2, 	label(Model 2) ms(Dh))  																///
			(Western_Female3, 	label(Model 3)), bylabel(Women)		||													///
																														/// 
			, drop(_cons diff_age* diff_marital2 																		///
			diff_marital3 diff_marital4 diff_nchild2 diff_nchild3 diff_nchild4 diff_wave2 diff_wave3 					/// 
			diff_wave4 diff_wave5 mean_age* mean_marital2 mean_marital3 mean_marital4 mean_nchild2 						/// 
			mean_nchild3 mean_nchild4 mean_wave2 mean_wave3 mean_wave4 mean_wave5 Medium High *country*)  				///
			xline(0) order(diff_income2 diff_income3 diff_income4 diff_wealth2 diff_wealth3 							/// 
			diff_wealth4 1.isced 2.isced mean_income2 mean_income3 mean_income4 mean_wealth2 mean_wealth3 mean_wealth4) ///
			headings(diff_income2 = `""{bf:Within Variance}" "{it:Income}""' 											///
			mean_income2 = "{it:Income}" 																				/// 
			diff_wealth2 = "{it:Wealth}" 																				///
			mean_wealth2 = "{it:Wealth}" 																				/// 
			1.isced = `""{bf:Between Variance}" "{it:Education}""', labs(vsmall)) legend(col(3) size(vsmall)) 			/// 
			ylab(, labs(vsmall)) xlabel(-.1 -.05 0 .05) 																/// 
			grid(glpattern(dash)) byopts(title("Western"))
*	graph save
graph save "$figure_out/coefplotWest.gph",  replace


*>> [text] Page 356. Figure 3 
coefplot 	(Northern_Male1, 	label(Model 1))	 																		/// 
			(Northern_Male2, 	label(Model 2) ms(Dh)) 																	///
			(Northern_Male3, 	label(Model 3)), bylabel(Men)		||													/// 
			(Northern_Female1, 	label(Model 1))	 																		/// 
			(Northern_Female2, 	label(Model 2) ms(Dh))  																///
			(Northern_Female3, 	label(Model 3)), bylabel(Women)	 	||													///
																														/// 
			, drop(_cons diff_age* diff_marital2 																		///
			diff_marital3 diff_marital4 diff_nchild2 diff_nchild3 diff_nchild4 diff_wave2 diff_wave3 					/// 
			diff_wave4 diff_wave5 mean_age* mean_marital2 mean_marital3 mean_marital4 mean_nchild2 						/// 
			mean_nchild3 mean_nchild4 mean_wave2 mean_wave3 mean_wave4 mean_wave5 Medium High *country*)  				///
			xline(0) order(diff_income2 diff_income3 diff_income4 diff_wealth2 diff_wealth3 							/// 
			diff_wealth4 1.isced 2.isced mean_income2 mean_income3 mean_income4 mean_wealth2 mean_wealth3 mean_wealth4) ///
			headings(diff_income2 = `""{bf:Within Variance}" "{it:Income}""'											///
			mean_income2 = "{it:Income}" 																				/// 
			diff_wealth2 = "{it:Wealth}" 																				///
			mean_wealth2 = "{it:Wealth}" 																				/// 
			1.isced = `""{bf:Between Variance}" "{it:Education}""', labs(vsmall)) legend(col(3) size(vsmall)) 			/// 
			ylab(, labs(vsmall)) xlabel(-.1 -.05 0 .05) 																/// 
			grid(glpattern(dash)) byopts(title("Northern"))  
*	graph save
graph save "$figure_out/coefplotNorth.gph",  replace


*>> Combine the graphs
graph combine 					///
"$figure_out/coefplotSouth"		///
"$figure_out/coefplotWest"		///
"$figure_out/coefplotNorth",	///
ysize(3) xsize(9) rows(1) ycommon altshrink imargin(tiny) 

*	Save the graphs
graph save "$figure_out/coefplotCombined.gph",  replace



*-----------------------------------------------------------------------------------------------* 
*>> Random-effects (RE) regression models, estimated separately by welfare group (Interactions)
*-----------------------------------------------------------------------------------------------* 

*	Clear stored results  
eststo clear

*>> Southern
eststo Southern: mixed fi $xvarsRE ib15.country || pid: [pw=ipw] if welfare==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo   Southern_interact: 	mixed fi $xvarsREinteractions ib15.country || pid: [pw=ipw] if welfare==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

estimate store SouthernEU

$mar_isced2
marginsplot, x(isced) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Southern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small))   
graph save "$figure_out/EduSouth.gph",  replace
graph export "$figure_out/EduSouth.tif", as(tif) width(4000) height(3200) replace

$mar_income2
marginsplot, x(income)  graphregion(color(none)) plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Southern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')  
graph save "$figure_out/IncSouth.gph",  replace
graph export "$figure_out/IncSouth.tif", as(tif) width(4000) height(3200) replace

$mar_wealth2
marginsplot, x(wealth) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Southern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')  
graph save "$figure_out/WeaSouth.gph",  replace
graph export "$figure_out/WeaSouth.tif", as(tif) width(4000) height(3200) replace

*>> Western
eststo Western:  mixed fi $xvarsRE ib11.country || pid: [pw=ipw] if welfare==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo   Western_interact: 	mixed fi $xvarsREinteractions ib11.country || pid: [pw=ipw] if welfare==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

estimate store WesternEU

$mar_isced2
marginsplot, x(isced) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Western EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small))   
graph save "$figure_out/EduWest.gph",  replace
graph export "$figure_out/EduWest.tif", as(tif) width(4000) height(3200) replace

$mar_income2
marginsplot, x(income)  graphregion(color(none)) plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Western EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')  
graph save "$figure_out/IncWest.gph",  replace
graph export "$figure_out/IncWest.tif", as(tif) width(4000) height(3200) replace

$mar_wealth2
marginsplot, x(wealth) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Western EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')  
graph save "$figure_out/WeaWest.gph",  replace
graph export "$figure_out/WeaWest.tif", as(tif) width(4000) height(3200) replace

*>> Northern
eststo Northern: mixed fi $xvarsRE ib13.country || pid: [pw=ipw] if welfare==2, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo   Northern_interact: 	mixed fi $xvarsREinteractions ib13.country || pid: [pw=ipw] if welfare==2, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

estimate store NorthernEU

$mar_isced2
marginsplot, x(isced) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Northern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small))   
graph save "$figure_out/EduNorth.gph",  replace
graph export "$figure_out/EduNorth.tif", as(tif) width(4000) height(3200) replace

$mar_income2
marginsplot, x(income)  graphregion(color(none)) plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Northern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')   
graph save "$figure_out/IncNorth.gph",  replace
graph export "$figure_out/IncNorth.tif", as(tif) width(4000) height(3200) replace

$mar_wealth2
marginsplot, x(wealth) graphregion(color(none))  plot1opts(msymbol(T) lpattern (shortdash)) title(`"{bf:Northern EU}"') ytitle("Frailty Index") xtitle(`"{bf:Gender}"', size(small)) xlabel(1 `""1st" "quartile""' 2 `""2nd" "quartile""' 3 `""3rd" "quartile""' 4 `""4th" "quartile""')  
graph save "$figure_out/WeaNorth.gph",  replace
graph export "$figure_out/WeaNorth.tif", as(tif) width(4000) height(3200) replace


*>> Combine the graphs
graph combine 			///
"$figure_out/EduSouth" 	///
"$figure_out/EduWest" 	///
"$figure_out/EduNorth", ///
ysize(3) xsize(9) rows(1) ycommon altshrink imargin(tiny) 
graph save "$figure_out/EduRE", replace

graph combine 			///
"$figure_out/IncSouth" 	///
"$figure_out/IncWest" 	///
"$figure_out/IncNorth", ///
ysize(3) xsize(9) rows(1) ycommon altshrink imargin(tiny) 
graph save "$figure_out/IncRE", replace

graph combine 			///
"$figure_out/WeaSouth" 	///
"$figure_out/WeaWest" 	///
"$figure_out/WeaNorth", ///
ysize(3) xsize(9) rows(1) ycommon altshrink imargin(tiny) 
graph save "$figure_out/WeaRE", replace


*>> Table 
esttab using "$tables_out/RE_welfare_sex.txt", 				///
		tab replace plain star(* 0.05  **  0.01 *** 0.001) 	/// 
		b(3) ci(3) wide not notes 							///
		label constant obslast stats(N groups aic bic)
estimate tab SouthernEU WesternEU NorthernEU, star


*-----------------------------------------------------------------------------------------------* 
*>> Random-effects (RE) regression models, estimated separately by country (Interactions)
*-----------------------------------------------------------------------------------------------* 

*	Clear the results 
eststo clear

*	Austria
eststo   Austria: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==11, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Austria

*	Germany
eststo   Germany: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==12, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Germany

*	Sweden
eststo   Sweden: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==13, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Sweden

*	Spain
eststo   Spain: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==15, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Spain

*	Italy
eststo   Italy: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==16, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Italy

*	France
eststo   France: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==17, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store France

*	Denmark
eststo   Denmark: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==18, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Denmark

*	Switzerland
eststo   Switzerland: 	mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==20, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Switzerland

*	Belgium
eststo   Belgium: 		mixed fi $xvarsREinteractions || pid: [pw=ipw] if country==23, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Belgium

*	Tabulate
estimate tab Austria Germany Sweden Spain Italy France Denmark Switzerland Belgium, star

esttab using "$tables_out/RE_country_sex_INTERACTIONS.txt",								/// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes	///
		label constant obslast  aic bic stats(N groups)


*---- [ 4. Supplementary analyses ]----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------------------------* 
*>> Hybrid (between-within) regression models estimated separately by country 
*-----------------------------------------------------------------------------------------------* 

*	Clear the results 
eststo clear

*>> Austria
eststo Austria_Male: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==11 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Austria_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==11 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Austria_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==11, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Germany
eststo Germany_Male: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==12 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Germany_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==12 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Germany_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==12, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Sweden
eststo Sweden_Male:			mixed fi $xvarsHY3 || pid: [pw=ipw] if country==13 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Sweden_Female:		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==13 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Sweden_INTERACT:	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==13, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Spain
eststo Spain_Male: 			mixed fi $xvarsHY3 || pid: [pw=ipw] if country==15 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Spain_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==15 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Spain_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==15, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Italy
eststo Italy_Male: 			mixed fi $xvarsHY3 || pid: [pw=ipw] if country==16 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Italy_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==16 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Italy_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==16, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> France
eststo France_Male: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==17 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo France_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==17 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo France_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==17, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Denmark
eststo Denmark_Male: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==18 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Denmark_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==18 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Denmark_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==18, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Switzerland
eststo Switzerlan_Male: 	mixed fi $xvarsHY3 || pid: [pw=ipw] if country==20 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Switzerlan_Female: 	mixed fi $xvarsHY3 || pid: [pw=ipw] if country==20 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Switzerlan_INTERACT: mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==20, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Belgium
eststo Belgium_Male: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==23 & sex==0, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Belgium_Female: 		mixed fi $xvarsHY3 || pid: [pw=ipw] if country==23 & sex==1, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

eststo Belgium_INTERACT: 	mixed fi $xvarsHYinteractions || pid: [pw=ipw] if country==23, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*>> Tabulate 
esttab using "$tables_out/HY_cntry_sex.txt", 				/// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) 	/// 
		b(3) ci(3) wide not notes 							///
		label constant obslast  aic bic stats(N groups)



*-----------------------------------------------------------------------------------------------* 
*>> Random Effects (RE) Regression Models (separately by country)
*-----------------------------------------------------------------------------------------------* 

*>> Clear the results 
eststo clear

*	Austria
eststo   Austria: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==11, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Austria

*	Germany
eststo   Germany: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==12, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Germany

*	Sweden
eststo   Sweden: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==13, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Sweden

*	Spain
eststo   Spain: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==15, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Spain

*	Italy
eststo   Italy: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==16, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Italy

*	France
eststo   France: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==17, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store France

*	Denmark
eststo   Denmark: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==18, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Denmark

*	Switzerland
eststo   Switzerland: 	mixed fi $xvarsRE || pid: [pw=ipw] if country==20, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Switzerland

*	Belgium
eststo   Belgium: 		mixed fi $xvarsRE || pid: [pw=ipw] if country==23, vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store Belgium

*>> Tabulate 
estimate tab Austria Germany Sweden Spain Italy France Denmark Switzerland Belgium, star

esttab using "$tables_out/RE_country_sex.txt", 												/// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes 		///
		label constant obslast  aic bic stats(N groups aic bic)


*-----------------------------------------------------------------------------------------------* 
*>> RE and hybrid models (separately by welfare cluster) | three-way interaction terms 
*-----------------------------------------------------------------------------------------------* 

*>> Hybrid models 
*	Clear results 
eststo clear

* 	Estimate 
eststo   HYthreeway: mixed fi $xvarsHYt3interactions || pid: [pw=ipw], vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'

*	Tabulate 
estimate tab HYthreeway, star

*>> [text] Page 353.
    // As a robustness check, we estimated a fully interacted
    // hybrid model to examine whether SES-related
    // changes in the FI differed significantly by gender and
    // welfare cluster (results available on request), and then a
    // Wald test on the joint significance of all the interaction
    // terms between welfare cluster, gender and the three
    // measures of SES. The test rejects the null hypothesis of
    // equality of the coefficient for education only (P<0.001).


*	Tabulate 
esttab using "$tables_out/HYthreeway.txt", 												/// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes 	///
		label constant obslast   stats(N groups aic bic)
estimate tab HYthreeway, star   


*>> [text] Wald tests
test	(0.welfare#0.sex#0.isced=0) (0.welfare#0.sex#1.isced=0) (0.welfare#0.sex#2.isced=0) ///
		(1.welfare#0.sex#0.isced=0) (1.welfare#0.sex#1.isced=0) (1.welfare#0.sex#2.isced=0) ///
		(2.welfare#0.sex#0.isced=0) (2.welfare#0.sex#1.isced=0) (2.welfare#0.sex#2.isced=0) ///
		(0.welfare#1.sex#0.isced=0) (0.welfare#1.sex#1.isced=0) (0.welfare#1.sex#2.isced=0) ///
		(1.welfare#1.sex#0.isced=0) (1.welfare#1.sex#1.isced=0) (1.welfare#1.sex#2.isced=0) ///
		(2.welfare#1.sex#0.isced=0) (2.welfare#1.sex#1.isced=0) (2.welfare#1.sex#2.isced=0)

test  (t3mean_welfare2Xsex2Xincome2=0) ///
      (t3mean_welfare3Xsex2Xincome2=0) ///
      (t3mean_welfare2Xsex2Xincome3=0) ///
      (t3mean_welfare3Xsex2Xincome3=0) ///
      (t3mean_welfare2Xsex2Xincome4=0) ///
      (t3mean_welfare3Xsex2Xincome4=0)
      
test  (t3mean_welfare2Xsex2Xwealth2=0) /// 
      (t3mean_welfare3Xsex2Xwealth2=0) /// 
      (t3mean_welfare2Xsex2Xwealth3=0) /// 
      (t3mean_welfare3Xsex2Xwealth3=0) /// 
      (t3mean_welfare2Xsex2Xwealth4=0) /// 
      (t3mean_welfare3Xsex2Xwealth4=0)

test  (t3diff_welfare2Xsex2Xincome2=0) ///
      (t3diff_welfare3Xsex2Xincome2=0) ///
      (t3diff_welfare2Xsex2Xincome3=0) ///
      (t3diff_welfare3Xsex2Xincome3=0) ///
      (t3diff_welfare2Xsex2Xincome4=0) ///
      (t3diff_welfare3Xsex2Xincome4=0)
      
test  (t3diff_welfare2Xsex2Xwealth2=0) /// 
      (t3diff_welfare3Xsex2Xwealth2=0) /// 
      (t3diff_welfare2Xsex2Xwealth3=0) /// 
      (t3diff_welfare3Xsex2Xwealth3=0) /// 
      (t3diff_welfare2Xsex2Xwealth4=0) /// 
      (t3diff_welfare3Xsex2Xwealth4=0)


*>> Hybrid models 
*	Clear results 
eststo clear

* 	Estimate 
eststo   threeway: mixed fi welfare#sex#isced welfare#sex#income welfare#sex#wealth age c.age#c.age c.age#c.age#c.age i.marital i.nchild i.wave i.welfare i.sex i.isced i.income i.wealth || pid: [pw=ipw], vce(cluster pid)
matrix N_g = e(N_g)
local groups = N_g[1,1]
estadd local groups `groups'
estimate store threeway
estimate tab threeway, star

*	Tabulate 
esttab using "$tables_out/threeway.txt",                        /// 
    tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes  ///
    label constant obslast   stats(N groups aic bic)

estimate tab threeway, star



*>> Wald tests [text]
test  (0.welfare#0.sex#0.isced=0) (0.welfare#0.sex#1.isced=0) (0.welfare#0.sex#2.isced=0) ///
    (1.welfare#0.sex#0.isced=0) (1.welfare#0.sex#1.isced=0) (1.welfare#0.sex#2.isced=0) ///
    (2.welfare#0.sex#0.isced=0) (2.welfare#0.sex#1.isced=0) (2.welfare#0.sex#2.isced=0) ///
    (0.welfare#1.sex#0.isced=0) (0.welfare#1.sex#1.isced=0) (0.welfare#1.sex#2.isced=0) ///
    (1.welfare#1.sex#0.isced=0) (1.welfare#1.sex#1.isced=0) (1.welfare#1.sex#2.isced=0) ///
    (2.welfare#1.sex#0.isced=0) (2.welfare#1.sex#1.isced=0) (2.welfare#1.sex#2.isced=0) ///

test  (0.welfare#0.sex#1.income=0) (0.welfare#0.sex#2.income=0) (0.welfare#0.sex#3.income=0) (0.welfare#0.sex#4.income=0) ///
    (1.welfare#0.sex#1.income=0) (1.welfare#0.sex#2.income=0) (1.welfare#0.sex#3.income=0) (1.welfare#0.sex#4.income=0) ///
    (2.welfare#0.sex#1.income=0) (2.welfare#0.sex#2.income=0) (2.welfare#0.sex#3.income=0) (2.welfare#0.sex#4.income=0) ///
    (0.welfare#1.sex#1.income=0) (0.welfare#1.sex#2.income=0) (0.welfare#1.sex#3.income=0) (0.welfare#1.sex#4.income=0) ///
    (1.welfare#1.sex#1.income=0) (1.welfare#1.sex#2.income=0) (1.welfare#1.sex#3.income=0) (1.welfare#1.sex#4.income=0) ///
    (2.welfare#1.sex#1.income=0) (2.welfare#1.sex#2.income=0) (2.welfare#1.sex#3.income=0) (2.welfare#1.sex#4.income=0) 


test  (0.welfare#0.sex#1.wealth=0) (0.welfare#0.sex#2.wealth=0) (0.welfare#0.sex#3.wealth=0) (0.welfare#0.sex#4.wealth=0) ///
    (1.welfare#0.sex#1.wealth=0) (1.welfare#0.sex#2.wealth=0) (1.welfare#0.sex#3.wealth=0) (1.welfare#0.sex#4.wealth=0) ///
    (2.welfare#0.sex#1.wealth=0) (2.welfare#0.sex#2.wealth=0) (2.welfare#0.sex#3.wealth=0) (2.welfare#0.sex#4.wealth=0) ///
    (0.welfare#1.sex#1.wealth=0) (0.welfare#1.sex#2.wealth=0) (0.welfare#1.sex#3.wealth=0) (0.welfare#1.sex#4.wealth=0) ///
    (1.welfare#1.sex#1.wealth=0) (1.welfare#1.sex#2.wealth=0) (1.welfare#1.sex#3.wealth=0) (1.welfare#1.sex#4.wealth=0) ///
    (2.welfare#1.sex#1.wealth=0) (2.welfare#1.sex#2.wealth=0) (2.welfare#1.sex#3.wealth=0) (2.welfare#1.sex#4.wealth=0) 


*-----------------------------------------------------------------------------------------------* 
*>> Reviewer 3 
*-----------------------------------------------------------------------------------------------* 

*	"How do the results look without controls for marital status and the number of children? 
*	There was no justification provided for these controls." 


*>> Hybrid Regression models (separately by welfare cluster)

*	Clear the results
eststo clear

*	 Southern_Male
eststo Southern_Male3: 		mixed fi $xvarsHY3chmarit 				ib15.country || pid: [pw=ipw] if welfare==0 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Southern_Female
eststo Southern_Female3: 	mixed fi $xvarsHY3chmarit 				ib15.country || pid: [pw=ipw] if welfare==0 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Southern (interaction terms)
eststo SouthernINTER: 		mixed fi $xvarsHYinteractions_chmarit 	ib15.country || pid: [pw=ipw] if welfare==0			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western_Male
eststo Western_Male3:		mixed fi $xvarsHY3chmarit 				ib11.country || pid: [pw=ipw] if welfare==1 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western_Female
eststo Western_Female3:		mixed fi $xvarsHY3chmarit 				ib11.country || pid: [pw=ipw] if welfare==1 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western (interaction terms)
eststo WesternINTER:	 	mixed fi $xvarsHYinteractions_chmarit 	ib11.country || pid: [pw=ipw] if welfare==1			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern_Male
eststo Northern_Male3: 		mixed fi $xvarsHY3chmarit 				ib13.country || pid: [pw=ipw] if welfare==2 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern_Female
eststo Northern_Female3: 	mixed fi $xvarsHY3chmarit 				ib13.country || pid: [pw=ipw] if welfare==2 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern (interaction terms)
eststo NorthernINTER: 		mixed fi $xvarsHYinteractions_chmarit 	ib13.country || pid: [pw=ipw] if welfare==2			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*>> Tabulate
esttab using "$tables_out/HY_welfare_sex_CHMARIT.txt", /// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes 	///
		label constant obslast  aic bic stats(N groups)



*-----------------------------------------------------------------------------------------------* 
*>> Reviewer 2
*-----------------------------------------------------------------------------------------------* 

*-----------------------------------------------------------------------------------------------* 
*>> Hybrid regression models (separately by welfare cluster) with lagged independent variables 
*-----------------------------------------------------------------------------------------------* 


eststo clear


*	 Southern_Male
eststo Southern_Male3: 		mixed fi $xvarsHY3lag 				ib15.country || pid: [pw=ipw] if welfare==0 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Southern_Female
eststo Southern_Female3: 	mixed fi $xvarsHY3lag 				ib15.country || pid: [pw=ipw] if welfare==0 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Southern (interaction terms)
eststo SouthernINTER: 		mixed fi $xvarsHYinteractions_lag 	ib15.country || pid: [pw=ipw] if welfare==0			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western_Male
eststo Western_Male3:		mixed fi $xvarsHY3lag 				ib11.country || pid: [pw=ipw] if welfare==1 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western_Female
eststo Western_Female3:		mixed fi $xvarsHY3lag 				ib11.country || pid: [pw=ipw] if welfare==1 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Western (interaction terms)
eststo WesternINTER:	 	mixed fi $xvarsHYinteractions_lag 	ib11.country || pid: [pw=ipw] if welfare==1			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern_Male
eststo Northern_Male3: 		mixed fi $xvarsHY3lag 				ib13.country || pid: [pw=ipw] if welfare==2 & sex==0, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern_Female
eststo Northern_Female3: 	mixed fi $xvarsHY3lag 				ib13.country || pid: [pw=ipw] if welfare==2 & sex==1, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3

*	 Northern (interaction terms)
eststo NorthernINTER: 		mixed fi $xvarsHYinteractions_lag 	ib13.country || pid: [pw=ipw] if welfare==2			, vce(cluster pid)
$estadd_part1
$estadd_part2
$estadd_part3


*>> Tabulate 
esttab using "$tables_out/HY_welfare_sex_LAG.txt", /// 
		tab replace plain star(* 0.05  **  0.01 *** 0.001) b(3) ci(3) wide not notes 	///
		label constant obslast  aic bic stats(N groups)
display "$S_TIME  $S_DATE"



*---- [ 5. Close ]---------------------------------------------------------------------------------------------*

*>> Log close 
log close

