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
*----	[ 1. Open the log file]----------------------------------------------------------------------------------*
*----	[ 2. Dependent Variable ]--------------------------------------------------------------------------------*
*----	[ 3. Independent Variables ]-----------------------------------------------------------------------------*
*----	[ 4. Control Variables ]---------------------------------------------------------------------------------*
*----	[ 5. Selection of Variables ]----------------------------------------------------------------------------*
*----	[ 6. Final Save ]----------------------------------------------------------------------------------------*

******************************************************************************************************************




*----	[ 1. Open the log file]----------------------------------------------------------------------------------*

*	Open the log file and the dataset
log using "$share_logfile/Data Cleaning.log", replace
use "$share_all_out/SHARE_LONG_6.1.1_v3.0.dta", clear 

*----	[ 2. Dependent Variable ]--------------------------------------------------------------------------------*

* I recode the variable, in accordance to Romero-Ortuno and Kenny (2012), and Stolz et al. (2017)
		// (All the variable that will compose the Frailty Index will have the "FI_" prefix)
recode srh (1=0) (2=0.25) (3=0.5) (4=0.75) (5=1), gen(FI_srh) 	// 	1.Excellent -> 0
																// 	2.Very good -> 0.25
																//	3.Good 		-> 0.5
																//	4.Fair 		-> 0.75
																//	5.Poor 		-> 1

*>> Engagement in activities requiring moderate or vigorous physical activity: hardly ever, or never
tab br015_, miss // Sports or activities that are vigorous
tab br016_, miss // Activities requiring a moderate level of energy
	// -> the above mentioned variables require a recode

*Sports or activities that are vigorous
ta br015_, miss
ta br015_, miss nola

*Activities requiring a moderate level of energy
ta br016_, miss
ta br016_, miss nola

*Recode -2 and -1 to Missing for both variables
recode br015_ br016_ (-2 -1 = .) 
ta br015_, miss // -> missing values = 0.67%
ta br016_, miss // -> missing values = 0.67%

*Generate a new variable in accordance to Romero-Ortuno and Kenny (2012)
gen FI_phactiv = 1
replace FI_phactiv = 0 if br015_<4 | br016_<4
replace FI_phactiv = . if br015_==. & br016_==.
label variable FI_phactiv "Engagement in activities requiring moderate or vigorous physical activity"

*>> Check
// list pid wave FI_phactiv br015_ br016_ in 50/100, sepby(pid)
tab FI_phactiv, miss // -> missing values = 0.65%


*>> ADL & IADL
tab1 ph049d1 ph049d2 ph049d3 ph049d4 ph049d5 ph049d6 ph049d8 ph049d9 ph049d10 ph049d11 ph049d12 ph049d13, miss 		// (49d*)
tab1 ph049d1 ph049d2 ph049d3 ph049d4 ph049d5 ph049d6 ph049d8 ph049d9 ph049d10 ph049d11 ph049d12 ph049d13, miss nola // (49d*)

* recode to missing
recode ph049d1 ph049d2 ph049d3 ph049d4 ph049d5 ph049d6 ph049d8 ph049d9 ph049d10 ph049d11 ph049d12 ph049d13 (-2 -1 = .)

tab1 ph049d1 ph049d2 ph049d3 ph049d4 ph049d5 ph049d6 ph049d8 ph049d9 ph049d10 ph049d11 ph049d12 ph049d13, miss
												// <- all of these variables have 0.35% missing values

tab1 ph048d1 ph048d3 ph048d5 ph048d7 ph048d9, miss 		// (48d*)
tab1 ph048d1 ph048d3 ph048d5 ph048d7 ph048d9, miss nola // (48d*)

* recode to missing
recode ph048d1 ph048d3 ph048d5 ph048d7 ph048d9  (-2 -1 = .)

tab1 ph048d1 ph048d3 ph048d5 ph048d7 ph048d9, miss // <-- 0.34% missing

*Rename new variables in accordance to Romero-Ortuno and Kenny (2012)
rename ph049d3 		FI_bathing  	// -> Difficulties: bathing or showering
rename ph048d5 		FI_stairs  		// -> Difficulties: climbing one flight of stairs
rename ph049d12 	FI_garden  		// -> Difficulties: doing work around the house or garden
rename ph049d1 		FI_dressing  	// -> Difficulties: dressing, including shoes and socks
rename ph049d4 		FI_eating  		// -> Difficulties: eating, cutting up food
rename ph049d5 		FI_bed  		// -> Difficulties: getting in or out of bed
rename ph048d3 		FI_chair  		// -> Difficulties: getting up from chair
rename ph048d9 		FI_lift5kg  	// -> Difficulties: lifting or carrying weights over 5 kilos
rename ph049d13 	FI_money  		// -> Difficulties: managing money
rename ph049d8 		FI_hotmeal  	// -> Difficulties: preparing a hot meal
rename ph048d7 		FI_arms  		// -> Difficulties: reaching or extending arms above shoulder
rename ph049d9 		FI_shopping  	// -> Difficulties: shopping for groceries
rename ph049d11 	FI_medications	// -> Difficulties: taking medications
rename ph049d6 		FI_toilet  		// -> Difficulties: using the toilet, incl getting up or down
rename ph048d1 		FI_walk100  	// -> Difficulties: walking 100 metres
rename ph049d2 		FI_walkRoom  	// -> Difficulties: walking across a room
rename ph049d10 	FI_phone		// -> Difficulties: telephone calls


*>> Diminution in the desire for food and/or eating less than usual
tab mh011_, miss 		// Appetite
tab mh011_, miss nola	// Appetite

tab mh012_, miss 		// Eating more or less
tab mh012_, miss nola 	// Eating more or less

recode mh011_ mh012_ (-2 -1 = .)
tab mh011_, miss 		// Appetite
tab mh012_, miss 		// Eating more or less

tab mh011_ mh012_, miss
tab mh011_ mh012_, miss nola

*Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
gen FI_appetite = 0
replace FI_appetite = 1 if mh011_==1 | mh012_==1 // Diminution in desire for food
replace FI_appetite = . if mh011_==. & mh012_==.

*>> Check
*	list pid wave FI_appetite mh011_ mh012_ in 1281/1509, sepby(pid)
*	list pid wave FI_appetite mh011_ mh012_ if mh012_!=. in 43000/45000, sepby(pid)

tab FI_appetite wave, miss col nofre // in wave 6 missing values are about 4.05%

*>> Long term-illness
tab ph004_, miss
tab ph004_, miss nola

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode ph004_ (-2 -1 = .) (5=0), gen(FI_longtermill)

tab FI_longtermill, miss // -> missing 0.32%

*>> Fatigue
tab mh013_, miss
tab mh013_, miss nola

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode mh013_ (-2 -1 = .) (5=0), gen(FI_fatigue)

tab FI_fatigue, miss // missing 2.33%

*>> Sad or depressed
tab mh002_, miss 		// <-- Sad or depressed last month
tab mh002_, miss nola

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode mh002_ (-2 -1 = .) (5=0), gen(FI_sad)

tab FI_sad, miss // missing 2.29%

*>> Lack of enjoyment
tab mh016, miss 		// <-- Sad or depressed last month
tab mh016, miss nola

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode mh016 (-2 -1 = .) (2=0), gen(FI_enjoyment)

tab FI_enjoyment, miss // missing 2.39%

*>> Hopelessness
tab mh003_, miss 		// <-- Hopes for the future
tab mh003_, miss nola

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode mh003_ (-2 -1 = .) (1=0) (2=1), gen(FI_hopelessness)

tab FI_hopelessness, miss // missing 2.39%

*>> Doctor told you had: [Condition]
tab ph006d1,  miss 			//<-- Doctor told you had: heart attack
tab ph006d1,  miss nola
tab ph006d2,  miss 			//<-- Doctor told you had: high blood pressure or hypertension
tab ph006d2,  miss nola
tab ph006d4,  miss 			//<-- Doctor told you had: stroke
tab ph006d4,  miss nola
tab ph006d5,  miss 			//<-- Doctor told you had: diabetes or high blood sugar
tab ph006d5,  miss nola
tab ph006d6,  miss 			//<-- Doctor told you had: chronic lung disease
tab ph006d6,  miss nola
tab ph006d8,  miss 			//<-- Doctor told you had: arthritis
tab ph006d8,  miss nola
tab ph006d9,  miss 			//<-- Doctor told you had: osteoporosis (Remember that you have a problem with this variable: 
tab ph006d9,  miss nola		// 	  see the "Dataset Creation" do-file)
tab ph006d10, miss 			//<-- Doctor told you had: cancer
tab ph006d10, miss nola
tab ph006d14, miss 			//<-- Doctor told you had: hip fracture or femoral fracture
tab ph006d14, miss nola
tab ph006d12, miss 			//<-- Doctor told you had: Parkinson disease
tab ph006d12, miss nola

* 	Recode the variables 
recode 	ph006d1		/// Doctor told you had: heart attack
		ph006d2		/// Doctor told you had: high blood pressure or hypertension
		ph006d4		/// Doctor told you had: stroke
		ph006d5		/// Doctor told you had: diabetes or high blood sugar
		ph006d6		/// Doctor told you had: chronic lung disease
		ph006d8		/// Doctor told you had: arthritis
		ph006d9		/// Doctor told you had: osteoporosis
		ph006d10	/// Doctor told you had: cancer
		ph006d14	/// Doctor told you had: hip fracture or femoral fracture
		ph006d12 	/// Doctor told you had: Parkinson disease
		(-2 -1 = .)

*>> Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
rename ph006d1	FI_heartattack	// Doctor told you had: heart attack
rename ph006d2	FI_hypertension	// Doctor told you had: high blood pressure or hypertension
rename ph006d4	FI_stroke		// Doctor told you had: stroke
rename ph006d5	FI_diabetes		// Doctor told you had: diabetes or high blood sugar
rename ph006d6	FI_lungdisease	// Doctor told you had: chronic lung disease
rename ph006d8	FI_arthritis	// Doctor told you had: arthritis
rename ph006d9	FI_osteoporosis	// Doctor told you had: osteoporosis
rename ph006d10 FI_cancer		// Doctor told you had: cancer
rename ph006d14 FI_fracture		// Doctor told you had: hip fracture or femoral fracture
rename ph006d12 FI_parkinson 	// Doctor told you had: Parkinson disease

tab FI_heartattack, miss 	// Doctor told you had: heart attack
tab FI_hypertension, miss 	// Doctor told you had: high blood pressure or hypertension
tab FI_stroke, miss 		// Doctor told you had: stroke
tab FI_diabetes, miss 		// Doctor told you had: diabetes or high blood sugar
tab FI_lungdisease, miss 	// Doctor told you had: chronic lung disease
tab FI_arthritis, miss 		// Doctor told you had: arthritis
tab FI_osteoporosis, miss 	// Doctor told you had: osteoporosis
tab FI_cancer, miss 		// Doctor told you had: cancer
tab FI_fracture, miss 		// Doctor told you had: hip fracture or femoral fracture
					// <-- All the missing values are <0.42

*>> Impaired orientation to date, month, year, and day of the week (i.e. less than good)
tab orienti, miss 		// <-- Score of orientation in time test
tab orienti, miss nola

*>> We keep only non-imputed values 
tab orienti_f, miss 
tab orienti_f, miss nola
replace orienti = . if orienti_f==14

*>> Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode orienti (-2 -1 = .) (0/3=1) (4=0), gen(FI_orienti)

tab FI_orienti, miss // missing 2.75%
tab orienti FI_orienti, miss

*>> BMI
sum bmi	// <-- Body Mass Index
tab bmi_f
tab bmi_f, nola
replace bmi = . if bmi_f==14

*>> Generating a new BMI categorical variable
*	Check also -> http://apps.who.int/bmi/?introPage=intro_3.html (WHO)
recode bmi 	(00.00 / 18.5 =	1 "Underweight") 	///
			(18.50 / 25.0 =	0 "Normal weight")	///
			(25.00 / 30.0 =	2 "Overweight") 	///
			(30.00 / 9999 =	3 "Obese"), 		///
gen(bmi_cat)

*>> Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
gen FI_bmi = . 
replace FI_bmi = 0 	 if bmi_cat == 0 
replace FI_bmi = 0.5 if bmi_cat == 2 
replace FI_bmi = 1 	 if bmi_cat == 1 | bmi_cat == 3

*	Check
ta bmi_cat FI_bmi, miss

*>> Bothered by: Condition
tab ph010d3, miss 		// 	Bothered by: breathlessness (missing values 51.87%)
tab ph010d3 wave, miss	//	Question not asked in wave 5 and 6

tab ph010d7, miss // Bothered by: falling down
tab ph010d8, miss // Bothered by: fear of falling down
tab ph010d9, miss // Bothered by: dizziness, faints or blackouts

tab ph010d7, miss nola // Bothered by: falling down
tab ph010d8, miss nola // Bothered by: fear of falling down
tab ph010d9, miss nola // Bothered by: dizziness, faints or blackouts

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
recode ph010d7 (-2 -1 = .), gen(FI_falling) 	// Bothered by: falling down
recode ph010d8 (-2 -1 = .), gen(FI_fearfall)	// Bothered by: fear of falling down
recode ph010d9 (-2 -1 = .), gen(FI_dizziness)	// Bothered by: dizziness, faints or blackouts

*>> Grip Strenght in KG (by Body Mass Index)
tab maxgrip, miss 		// Missing values are about 8.44%
tab maxgrip, miss nola
recode maxgrip (-99=.)

tab maxgrip_f, missing 	// + 0.13% missing values imputed
tab maxgrip_f, miss nola
replace maxgrip = . if maxgrip_f==-99 | maxgrip_f==14

* Create a new variable in accordance to Romero-Ortuno and Kenny (2012)
gen 	FI_maxgrip = 0
replace FI_maxgrip = . if maxgrip==.

replace	FI_maxgrip = 1 							                    	///
	if 											                    	///
	(                                                               	///
		sex == 0									                	/// <<< Male
		& 											                	///
		(                                                           	///
			(bmi <= 24 & maxgrip <= 29 & maxgrip !=.)					///		- For BMI <= 24, GS <= 29
			|					 					            		///
			(bmi >  24 & bmi 	 <= 28 & maxgrip <= 30 & maxgrip !=.)	///		- For BMI > 24 and <= 28, GS <= 30
			|					 					            		///
			(bmi >  28 & maxgrip <= 32 & maxgrip !=.)                	///		- For BMI > 28, GS <= 32
		)                                                           	///
	)											                    	///
												                    	///
	|											                    	///
												                    	///
	(                                                               	///
		sex == 1									                	/// <<< Female
		&											                	///
		(                                                           	///
			(bmi <= 23 & maxgrip <= 17 & maxgrip !=.)					///		- For BMI <= 23, GS <= 17
			|					 					           			///
			(bmi >  23 & bmi 	 <= 26 & maxgrip <= 17.3 & maxgrip !=.)	///		- For BMI > 23 and <= 26, GS <= 17.3
			|					 					           			///
			(bmi >  26 & bmi 	 <= 29 & maxgrip <= 18.0 & maxgrip !=.)	///		- For BMI > 26 and <= 29, GS <= 18
			|					 					           			///
			(bmi >  29 & maxgrip <= 21 & maxgrip !=.)                   ///		- For BMI > 29, GS <= 21
		)                                                         		///
	)	                                                          		///

ta FI_maxgrip, miss // Confirm missing values = 8.58%

*>> Impaired vision: distance
tab ph043_, miss 	// -> Eyesight distance: 	// How good is your eyesight for seeing things at a distance, 
													// like recognising a friend across the street [using glasses 
													// or contact lenses as usual]? Would you say it is ...
													// (1. Excellent 2. Very good 3. Good 4. Fair 5. Poor)
tab ph043_, miss nola

recode ph043_ (-2 -1 = .)

* Generating a new variable in accordance to Stolz et al. (2017)
recode ph043_ (1/3 = 0) (4/5 = 1) (else=.), gen(FI_EyesightDistance)

tab FI_EyesightDistance, miss nola 	// <- missing values 0.49%

*>> Impaired vision: closeness
tab eyesightr, miss // -> Eyesight closeness (e.g. reading): 	// How good is your eyesight for seeing things up close, 
																// like reading ordinary newspaper print[using glasses 
																// or contact lenses as usual]? Would you say it is...
																// (1. Excellent 2. Very good 3. Good 4. Fair 5. Poor)

					// We have no missing observations here, because we are using the imputed values by SHARE

tab eyesightr, miss nola

recode eyesightr (1/3 = 0) (4/5 = 1) (else=.), gen(FI_EyesightCloseness)
ta FI_EyesightCloseness

*>> Impaired hearing 
tab hearing, miss 	// -> Eyesight closeness (e.g. reading): 	// Is your hearing[using a hearing aid as usual]...
																// (1. Excellent 2. Very good 3. Good 4. Fair 5. Poor)

					// We have no missing observations here, because we are using the imputed values by SHARE

tab hearing, miss nola

recode hearing (1/3 = 0) (4/5 = 1) (else=.), gen(FI_hearing)
ta FI_hearing

* Store the variables in FrailtyVars (only orienti, bmi, and maxgrip -were- imputed)
global FrailtyVars 		///
			FI_bathing      	/// Difficulties: bathing or showering
			FI_stairs       	/// Difficulties: climbing one flight of stairs
			FI_garden       	/// Difficulties: doing work around the house or garden
			FI_dressing     	/// Difficulties: dressing, including shoes and socks
			FI_eating       	/// Difficulties: eating, cutting up food
			FI_bed          	/// Difficulties: getting in or out of bed
			FI_chair        	/// Difficulties: getting up from chair
			FI_lift5kg      	/// Difficulties: lifting or carrying weights over 5 kilos
			FI_money        	/// Difficulties: managing money
			FI_hotmeal      	/// Difficulties: preparing a hot meal
			FI_arms         	/// Difficulties: reaching or extending arms above shoulder
			FI_shopping     	/// Difficulties: shopping for groceries
			FI_medications  	/// Difficulties: taking medications
			FI_toilet       	/// Difficulties: using the toilet, incl getting up or down
			FI_walk100      	/// Difficulties: walking 100 metres
			FI_walkRoom     	/// Difficulties: walking across a room
			FI_arthritis    	/// Doctor told you had: arthritis
			FI_cancer       	/// Doctor told you had: cancer
			FI_lungdisease  	/// Doctor told you had: chronic lung disease
			FI_diabetes     	/// Doctor told you had: diabetes or high blood sugar
			FI_heartattack  	/// Doctor told you had: heart attack
			FI_hypertension 	/// Doctor told you had: high blood pressure or hypertension
			FI_fracture     	/// Doctor told you had: hip fracture or femoral fracture
			FI_stroke       	/// Doctor told you had: stroke
			FI_phactiv      	/// Engagement in activities requiring moderate or vigorous physical activity
			FI_appetite     	/// FI_appetite
			FI_bmi          	/// FI_bmi
			FI_sad          	/// RECODE of mh002_ (Sad or depressed last month)
			FI_hopelessness 	/// RECODE of mh003_ (Hopes for the future)
			FI_fatigue      	/// RECODE of mh013_ (Fatigue)
			FI_enjoyment    	/// RECODE of mh016_ (Enjoyment)
			FI_orienti      	/// RECODE of orienti (Score of orientation in time test)
			FI_longtermill  	/// RECODE of ph004_ (Long-term illness)
			FI_falling      	/// RECODE of ph010d7 (Bothered by: falling down)
			FI_fearfall     	/// RECODE of ph010d8 (Bothered by: fear of falling down)
			FI_dizziness    	/// RECODE of ph010d9 (Bothered by: dizziness, faints or blackouts)
			FI_srh          	/// RECODE of srh (Self-report of health)
			FI_maxgrip      	/// Grip strenght
			FI_phone 			/// Diffic, nola miss // ulties: telephone calls
			FI_parkinson 		 // Doctor told you had: Parkinson disease


*>> Creation of the index
*>> Generate the Frailty Index (No worries, you can do it now -> no differences if you want to create it before the sample selection)
gen fi = 		(	  					///
				(FI_bathing      )	+ 	/// Difficulties: bathing or showering
				(FI_stairs       )	+ 	/// Difficulties: climbing one flight of stairs
				(FI_garden       )	+ 	/// Difficulties: doing work around the house or garden
				(FI_dressing     )	+ 	/// Difficulties: dressing, including shoes and socks
				(FI_eating       )	+ 	/// Difficulties: eating, cutting up food
				(FI_bed          )	+ 	/// Difficulties: getting in or out of bed
				(FI_chair        )	+ 	/// Difficulties: getting up from chair
				(FI_lift5kg      )	+ 	/// Difficulties: lifting or carrying weights over 5 kilos
				(FI_money        )	+ 	/// Difficulties: managing money
				(FI_hotmeal      )	+ 	/// Difficulties: preparing a hot meal
				(FI_arms         )	+ 	/// Difficulties: reaching or extending arms above shoulder
				(FI_shopping     )	+ 	/// Difficulties: shopping for groceries
				(FI_medications  )	+ 	/// Difficulties: taking medications
				(FI_toilet       )	+ 	/// Difficulties: using the toilet, incl getting up or down
				(FI_walk100      )	+ 	/// Difficulties: walking 100 metres
				(FI_walkRoom     )	+ 	/// Difficulties: walking across a room
				(FI_arthritis    )	+ 	/// Doctor told you had: arthritis
				(FI_cancer       )	+ 	/// Doctor told you had: cancer
				(FI_lungdisease  )	+ 	/// Doctor told you had: chronic lung disease
				(FI_diabetes     )	+ 	/// Doctor told you had: diabetes or high blood sugar
				(FI_heartattack  )	+ 	/// Doctor told you had: heart attack
				(FI_hypertension )	+ 	/// Doctor told you had: high blood pressure or hypertension
				(FI_fracture     )	+ 	/// Doctor told you had: hip fracture or femoral fracture
				(FI_stroke       )	+ 	/// Doctor told you had: stroke
				(FI_phactiv      )	+ 	/// Engagement in activities requiring moderate or vigorous physical activity
				(FI_appetite     )	+ 	/// FI_appetite
				(FI_bmi          )	+ 	/// FI_bmi
				(FI_sad          )	+ 	/// RECODE of mh002_ (Sad or depressed last month)
				(FI_hopelessness )	+ 	/// RECODE of mh003_ (Hopes for the future)
				(FI_fatigue      )	+ 	/// RECODE of mh013_ (Fatigue)
				(FI_enjoyment    )	+ 	/// RECODE of mh016_ (Enjoyment)
				(FI_orienti      )	+ 	/// RECODE of orienti (Score of orientation in time test)
				(FI_longtermill  )	+ 	/// RECODE of ph004_ (Long-term illness)
				(FI_falling      )	+ 	/// RECODE of ph010d7 (Bothered by: falling down)
				(FI_fearfall     )	+ 	/// RECODE of ph010d8 (Bothered by: fear of falling down)
				(FI_dizziness    )	+ 	/// RECODE of ph010d9 (Bothered by: dizziness, faints or blackouts)
				(FI_srh          )	+ 	/// RECODE of srh (Self-report of health)
				(FI_maxgrip      )	+ 	/// Grip strenght
				(FI_phone 		 )	+ 	/// Diffic, nola miss // ulties: telephone calls
				(FI_parkinson 	 )	  	/// Doctor told you had: Parkinson disease
				) / 40

label variable fi "Frailty Index"

*>> Recode depression

recode eurod (0/3 = 0 "Not Depressed") (4/12 = 1 "Depressed"), gen(depression)

*>> Recode srh

recode srh (1/3 = 0 "Good Health") (4 5 = 1 "Poor Health"), gen(srh01)		// 1.Excellent	|| 
																			// 2.Very good	|| 
																			// 3.Good		|| __> Poor Health threshold
																			// 4.Fair 		|| 
																			// 5.Poor 		|| 


*----	[ 3. Independent Variables ]-----------------------------------------------------------------------------*

*>> Level of education recoding, ISCED
ta isced, miss 
ta isced, miss nola

recode isced (0 1 2 = 0 "Low") (3 4 = 1 "Medium") (5 6 = 2 "High"), gen(isced_new)

rename isced isced_old
rename isced_new isced
ta isced_old isced
drop isced_old

replace isced = . if isced_f == 14 // we exclude the imputed values



*----	[ 4. Control Variables ]---------------------------------------------------------------------------------*

*>> Age group
recode age											/// See G. Cesa-Bianchi and Cristini (2005, 151), and Cesa Bianchi (2004, 28)
					(50/59  = 0 "50-59")			/// 
					(60/79  = 1 "60-79")			/// 
					(80/200 = 2 "80+"), gen(agecat)

ta age agecat, miss

*>> Marital Status
ta mstat
ta mstat, nola

recode mstat 	(1 2 3 	= 0) 					/// "Married (living/not living with spouse) or Registered partnership"
				(4 		= 1) 					/// "Never married"
				(5 		= 2) 					/// "Divorced"
				(6 		= 3)			 		/// "Widowed"
							, gen(marital)

lab var marital "Marital Status"
label define lab_mstat 												///
	0 "Married/Registered partnership (living/not living w/ spouse"	/// 
	1 "Never married"												///
	2 "Divorced"													///
	3 "Widowed"
label values marital lab_mstat


replace marital = . if mstat_f == 14 // we exclude all the imputed values

*>> Number of living sons and daughters 
ta nchild
recode nchild (3/100 = 3)

label define lab_nchild	///
	0 "Childless"		///
	1 "1"				///
	2 "2"				///
	3 "3+"
label values nchild lab_nchild

replace nchild = . if nchild_f == 14 // we exclude all the imputed values 

*>> Subjective assessments of economic strain - how difficult they find it to make ends meet
recode fdistress (-99 = .) // Thinking of your household's total monthly income, would you say that your household is able to make ends meet ...


rename fdistress fdistress_old
recode fdistress_old 										/// 
						(1 2 = 1 "With difficulty") 		///	"with difficulty" (some difficulty/great difficulty
						(3 4 = 0 "Easily"), gen(fdistress) 	//	"easily" (fairly easily/easily) 

*>> Employment status
ta cjs, miss
ta cjs sex, miss col nofre			/// The categories "unemployed", "sick/disabled" and "homemakers" differentiates by sex, 
									// 	(e.g. including mostly homemakers among females and unemployed, sick and disabled 
									// among males).
ta cjs, miss nola
recode cjs (-99 97 = .) (3 4 5 = 3) // Employment status has three groups:
									// retired, employed and non-employed (i.e. unemployed, sick/disabled and homemakers). 
 
label define lab_cjs				///
	1 "Retired"						///											
	2 "Employed or self-employed"	///									
	3 "Non-employed"
label values cjs lab_cjs

*>> Other control variables
ta wave, miss
ta sex, miss
ta partnerinhh, miss
ta nchild, miss
ta thospital, miss
ta doctor, miss
ta esmoked, miss

*>> Drinking
ta br010_ wave, miss // (missing in the 6th wave)
ta br010_, miss
ta br010_, miss nola

recode br010_ 	(-2 -1 	= .						) 	/// (missing)
				(1 		= 1 "Almost every day"	) 	/// Daily or almost daily
				(2 		= 2 "5–6 days/week"		) 	/// Five or six days a week
				(3 		= 3 "3–4 days/week"		)	/// Three or four days a week
				(4 		= 4 "1–2 days/week"		) 	/// Once or twice a week
				(5 6 7 	= 5 "<1–2 days/month"	)	/// -> 	5. Once or twice a month
				, gen(drink_a)						//	 	6. Less than once a month
													//	 	7. Not at all in the last 6 months


*>> Ever drinks alcohol
*	Last 7 days
* 	Wave 1-5 respondent ever drinks alcohol
gen rdrink =.
replace rdrink = 0 if inlist(br010_,5,6,7)
replace rdrink = 1 if inlist(br010_,1,2,3,4)

**change to last 7 days
*wave 6 respondent ever drinks alcohol
replace rdrink = 0 if br039_ == 5
replace rdrink = 1 if br039_ == 1

* 	Label define "Ever drinks"
label define ever_drink 			///
 		 						0 "No"  ///
  		 						1 "Yes"
label values rdrink ever_drink
label variable rdrink "Ever drinks any alcohol"


*>> Smoking 
*	Starting in wave 6, respondents who had been previously interviewed are not asked about smoking at the present time
tab br001_ br002_
tab br001_ br002_, nola

recode br001 br002 (-2 -1 = .)


*list pid wave br001 br002, sepby(pid)

*wave 1 respondent ever smoked cigarettes/pipe/cigar
gen smokev =.
replace smokev = 0 if br001_ == 5 & wave==1
replace smokev = 1 if br001_ == 1 & wave==1
label variable smokev "Smoke ever"
*list pid wave br001 br002 smokev, sepby(pid) // We have replaced only in wave 1

*wave 1 respondent smokes cigarettes/pipe/cigar now
gen smoken =.
replace smoken = 0 if (br001_ == 5 | br002_ == 5) & wave==1
replace smoken = 1 if br002_ == 1 & wave==1
label variable smoken "Smokes now"
*list pid wave br001 br002 smokev smoken if wave==1, sepby(pid) // We have replaced only in wave 1

*wave 2 respondent ever smoked cigarettes
sort pid wave 
xtset pid wave 
replace smokev = L.smokev if !mi(L.smokev) & wave == 2 & br001_ == .
replace smokev = 0 if br001_ == 5  & wave == 2
replace smokev = 1 if (br001_ == 1 | br002_ == 1)  & wave == 2
*list pid wave br001 br002 smokev smoken if wave==1 | wave==2, sepby(pid) // We have replaced only in wave 2

*wave 2 respondent smokes cigarettes now
***check br022_ 
replace smoken = 0 if (br001_ == 5 | (br002_ == 5 & br022_ != 3)) & wave==2
replace smoken = 1 if (br002_ == 1 | br022_ == 3) & wave==2
*list pid wave br001 br002 smokev smoken if wave==1 | wave==2, sepby(pid) // We have replaced only in wave 2

*wave 4 respondent ever smoked cigarettes
replace smokev = L.smokev if !mi(L.smokev) & wave == 3 & br001_ == .
replace smokev = L2.smokev if !mi(L2.smokev) & wave == 3 & L.smokev  == .
replace smokev = 0 if (br001_ == 5) & wave == 3
replace smokev = 1 if (br001_ == 1 | br002_ == 1) & wave == 3

*list pid wave br001 br002 smokev smoken if wave==1 | wave==2 | wave==3, sepby(pid) // We have replaced only in wave 3

*wave 4 respondent smokes cigarettes now
***check br022_ 
replace smoken = 0 if (br001_ == 5 | (br002_ == 5 & br022_ != 3)) & wave==3
replace smoken = 1 if (br002_ == 1 | br022_ == 3) & wave==3

*list pid wave br001 br002 smokev smoken if wave==1 | wave==2 | wave==3, sepby(pid) // We have replaced only in wave 3

*wave 5 respondent ever smoked cigarettes 
replace smokev = L.smokev 	if !mi(L.smokev)  & wave == 4 & br001_ == .
replace smokev = L2.smokev 	if !mi(L2.smokev) & wave == 4 & L.smokev  == .
replace smokev = L3.smokev 	if !mi(L3.smokev) & wave == 4 & L2.smokev == .
replace smokev = 0 if (br001_ == 5) & wave == 4
replace smokev = 1 if (br001_ == 1 | br002_ == 1) & wave == 4

*list pid wave br001 br002 smokev smoken if (wave==1 | wave==2 | wave==3 | wave==4) & pid==130, sepby(pid) // check the case of pid==130

*wave 5 respondent smokes cigarettes now
***check br022_ 
replace smoken = 0 if (br001_ == 5 | (br002_ == 5 & br022_ != 3)) & wave == 4
replace smoken = 1 if (br002_ == 1 | br022_ == 3) & wave == 4
*list pid wave br001 br002 smokev smoken if (wave==1 | wave==2 | wave==3 | wave==4) & pid==130, sepby(pid) // check the case of pid==130

*wave 6 respondent ever smoked cigarettes
replace smokev = L.smokev 	if !mi(L.smokev ) & wave == 5 & br001_ == . // r6smokev = r1smokev if !mi(r1smokev) & inw6 == 1
replace smokev = L2.smokev 	if !mi(L2.smokev) & wave == 5 & L.smokev  == . // r6smokev = r2smokev if !mi(r2smokev) & inw6 == 1
replace smokev = L3.smokev 	if !mi(L3.smokev) & wave == 5 & L2.smokev == . // r6smokev = r4smokev if !mi(r4smokev) & inw6 == 1
replace smokev = L4.smokev 	if !mi(L4.smokev) & wave == 5 & L3.smokev == . // r6smokev = r5smokev if !mi(r5smokev) & inw6 == 1
replace smokev = 0 if (br001_ == 5) & wave==5
replace smokev = 1 if (br001_ == 1 | br002_ == 1) & wave==5
*list pid wave br001 br002 smokev smoken if pid==130, sepby(pid) // check the case of pid==130

*wave 6 respondent smokes cigarettes now
***define same way at wave 1
replace smoken = 0 if (br001_ == 5 | br002_ == 5) & wave==5
replace smoken = 1 if (br002_ == 1) & wave==5
*list pid wave br001 br002 smokev smoken if pid==130, sepby(pid) // check the case of pid==130
*list pid wave br001 br002 smokev smoken if pid==55312, sepby(pid)
*list pid wave br001 br002 smokev smoken if  smokev==0 & smoken==1, sepby(pid)

replace smokev = smoken if (smokev==0 & smoken==1)

* Generate new variable with three categories 
gen smoke = .
replace smoke = 0 if smokev==0				// "Never smoked"
replace smoke = 1 if smokev==1 & smoken==0 	// "Former smoker"
replace smoke = 2 if smoken==1 				// "Current smoker"

*smoke -> lab definition*
lab var smoke "Smoke"
label define smoke_lab  		///
			0  "Never smoked" 		/// 
			1  "Former smoker"  	///
			2  "Current smoker"
label values smoke smoke_lab

ta smoke wave, col nofre miss

*list pid wave br001 br002 smokev smoken smoke if  smokev==0 & smoke!=0, sepby(pid)




*>> Generate other variables:
*	Welfare clusters
recode country 	(11 12 17 20 23 = 1 "Western EU") 	/// 11 Austria, 12 Germany, 17 France, 20 Switzerland, 23 Belgium
				(13 18 			= 2 "Northern EU")	/// 13 Sweden, 18 Denmark 
				(15 16 			= 0 "Southern EU") 	/// 15 Spain, 16 Italy 
				, gen(welfare)

*	Family-Service clusters (see Kaschowitz and Brandt (2017))
recode country 	(11 12 15 16 17 23 = 0 "Family-based Countries") 	///
				(13 18 20 = 1 "Service-based Countries") 			/// 
				, gen(cluster) 



*>> Caregiving variables 

** label other care variables (sp009_*)
	label define lab_ToWhomGiveHelp					///
	-2	"Refusal"									///
	-1	"Don't know"								///
	1	"Partner/Spouse"							///
	2	"Mother"									///
	3	"Father"									///
	4	"Mother-in-law"								///
	5	"Father-in-law"								///
	6	"Stepmother"								///
	7	"Stepfather"								///
	8	"Brother"									///
	9	"Sister"									///
	10	"Child 1"									///
	11	"Child 2"									///
	12	"Child 3"									///
	13	"Child 4"									///
	14	"Child 5"									///
	15	"Child 6"									///
	16	"Child 7"									///
	17	"Child 8"									///
	18	"Child 9"									///
	19	"Other child"								///
	20	"Son-in-law"								///
	21	"Daughter-in-law"							///
	22	"Grandchild"								///
	23	"Grandparent"								///
	24	"Aunt"										///
	25	"Uncle"										///
	26	"Niece"										///
	27	"Nephew"									///
	28	"Other relative"							///
	29	"Friend"									///
	30	"(Ex)Colleague/Co-worker"					///
	31	"Neighbour"									///
	32	"Ex-spouse/partner"							///
	33	"Other acquaintance"						///
	34	"Step-child/your current partner's child"	///
	35	"Minister, priest, or other clergy"			///
	36	"Therapist or other professional helper"	///
	37	"Housekeeper/Home health care provider"		///
	96	"None of these"								///
	101	"Social network person 1"					///
	102	"Social network person 2"					///
	103	"Social network person 3"					///
	104	"Social network person 4"					///
	105	"Social network person 5"					///
	106	"Social network person 6"					///
	107	"Social network person 7"					
label values sp009_1 sp009_2 sp009_3 lab_ToWhomGiveHelp


*generate partner care variable

*>> Informal Care
ta sp018_ wave, col nofre miss //  (inside the household) 
ta sp008_ wave, col nofre miss //  (outside the household) -> 	// note that in waves 4 and 5 in SHARE only the “family 
																// respondent” was asked about support given outside the household).

* "Given help to someone with personal care in the household" (yes/no) simple recode 
recode sp018_ (-2 -1 = .) (5=0), gen(carein) 

* "To whom given help in this household" (yes/no) simple recode 
recode 		sp019d1 sp019d2 sp019d3 sp019d4 sp019d5 sp019d6 sp019d7 sp019d8 sp019d9 sp019d10 sp019d11 	/// 
			sp019d12 sp019d13 sp019d14 sp019d15 sp019d16 sp019d17 										/// 
			sp019d18 sp019d19 sp019d20 sp019d21 sp019d22 sp019d23 sp019d24 sp019d25 sp019d26 sp019d27 	/// 
			sp019d28 sp019d29 sp019d30 sp019d31 sp019d32 sp019d33 										///
			sp019d1sn sp019d2sn sp019d3sn sp019d4sn sp019d5sn sp019d6sn sp019d7sn sp019d1sp sp019d2sp 	/// 
			sp019d3sp sp019d4sp sp019d5sp sp019d6sp sp019d7sp 											/// 
			sp019d8sp sp019d9sp sp019d19sp sp019d20sp sp019d21sp sp019d22sp sp019d23sp sp019d24sp 		/// 
			sp019d25sp sp019d26sp sp019d27sp sp019d28sp sp019d29sp 										/// 
			sp019d30sp sp019d31sp sp019d32sp sp019d34sp sp019d35sp sp019d36sp sp019d37sp sp019dno 		/// 
			sp019d35 sp019d36 sp019d37 																	///
(-1 = .)


*>> Generate new carein variable (distinguishing the care receivers)
gen carewhom = .
replace carewhom = 0 if carein==0 									 // no care 
replace carewhom = 1 if carein==1 & ((	sp019d1 	== 1 |			/// care for: (ex) spouse or partner
									 	sp019d32 	== 1 |			///
									 	sp019d1sp 	== 1 |			///
									 	sp019d32sp 	== 1 )			///
									 	|							///
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 1 | sn005_1 == 24)) | 	///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 1 | sn005_2 == 24)) | 	///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 1 | sn005_3 == 24)) | 	///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 1 | sn005_4 == 24)) | 	///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 1 | sn005_5 == 24)) | 	///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 1 | sn005_6 == 24)) | 	///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 1 | sn005_7 == 24)))


replace carewhom = 2 if carein==1 & ((	sp019d2		== 1 | 			/// care for: mother, father, stepmother, stepfather
									 	sp019d6		== 1 |			///
									 	sp019d2sp	== 1 |			///
									 	sp019d6sp	== 1 |			///
									 	sp019d3		== 1 |			///
									 	sp019d7		== 1 |			///
									 	sp019d3sp	== 1 |			///
									 	sp019d7sp	== 1 )			///
									 	|							///
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 2 | sn005_1 == 3 | sn005_1 == 6 | sn005_1 == 7)) | 		///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 2 | sn005_2 == 3 | sn005_2 == 6 | sn005_2 == 7)) | 		///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 2 | sn005_3 == 3 | sn005_3 == 6 | sn005_3 == 7)) | 		///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 2 | sn005_4 == 3 | sn005_4 == 6 | sn005_4 == 7)) | 		///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 2 | sn005_5 == 3 | sn005_5 == 6 | sn005_5 == 7)) | 		///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 2 | sn005_6 == 3 | sn005_6 == 6 | sn005_6 == 7)) | 		///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 2 | sn005_7 == 3 | sn005_7 == 6 | sn005_7 == 7)))

replace carewhom = 3 if carein==1 & ((	sp019d4		== 1 | 			/// care for: mother-in-law, father-in-law
									 	sp019d5		== 1 |			/// 
									 	sp019d4sp	== 1 |			/// 
									 	sp019d5sp	== 1 )			/// 
									 	|							/// 
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 4 | sn005_1 == 5)) |				///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 4 | sn005_2 == 5)) |				///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 4 | sn005_3 == 5)) |				///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 4 | sn005_4 == 5)) |				///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 4 | sn005_5 == 5)) |				///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 4 | sn005_6 == 5)) |				///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 4 | sn005_7 == 5)))

replace carewhom = 4 if carein==1 & ((	sp019d10	== 1 | 			/// care for: child(ren), child(ren)-in-law
									 	sp019d11	== 1 |			/// 
									 	sp019d12	== 1 |			/// 
									 	sp019d13	== 1 |			/// 
									 	sp019d14	== 1 |			/// 
									 	sp019d15	== 1 |			/// 
									 	sp019d16	== 1 |			/// 
									 	sp019d17	== 1 |			/// 
									 	sp019d18	== 1 |			/// 
									 	sp019d19	== 1 |			/// 
									 	sp019d19sp	== 1 |			/// 
									 	sp019d34sp	== 1 |			/// 
									 	sp019d20	== 1 |			/// 
									 	sp019d21	== 1 |			/// 
									 	sp019d20sp	== 1 |			/// 
									 	sp019d21sp	== 1 )			/// 
									 	|							/// 
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 10 | sn005_1 == 11 | sn005_1 == 12 | sn005_1 == 13)) |		///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 10 | sn005_2 == 11 | sn005_2 == 12 | sn005_2 == 13)) |		///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 10 | sn005_3 == 11 | sn005_3 == 12 | sn005_3 == 13)) |		///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 10 | sn005_4 == 11 | sn005_4 == 12 | sn005_4 == 13)) |		///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 10 | sn005_5 == 11 | sn005_5 == 12 | sn005_5 == 13)) |		///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 10 | sn005_6 == 11 | sn005_6 == 12 | sn005_6 == 13)) |		///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 10 | sn005_7 == 11 | sn005_7 == 12 | sn005_7 == 13)))

replace carewhom = 5 if carein==1 & ((	sp019d8 	== 1 | 			/// other relatives 
									 	sp019d9 	== 1 |			/// 
									 	sp019d22 	== 1 |			/// 
									 	sp019d23 	== 1 |			/// 
									 	sp019d24 	== 1 |			/// 
									 	sp019d25 	== 1 |			/// 
									 	sp019d26 	== 1 |			/// 
									 	sp019d27 	== 1 |			/// 
									 	sp019d28 	== 1 |			/// 
									 	sp019d8sp 	== 1 |			/// 
									 	sp019d9sp 	== 1 |			/// 
									 	sp019d22sp 	== 1 |			/// 
									 	sp019d23sp 	== 1 |			/// 
									 	sp019d24sp 	== 1 |			/// 
									 	sp019d25sp 	== 1 |			/// 
									 	sp019d26sp 	== 1 |			/// 
									 	sp019d27sp 	== 1 |			/// 
									 	sp019d28sp 	== 1 )			/// 
									 	|							/// 
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 8 | sn005_1 == 9 | sn005_1 == 14 | sn005_1 == 15 | sn005_1 == 16 | sn005_1 == 17 | sn005_1 == 18 | sn005_1 == 19 | sn005_1 == 20)) |  	///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 8 | sn005_2 == 9 | sn005_2 == 14 | sn005_2 == 15 | sn005_2 == 16 | sn005_2 == 17 | sn005_2 == 18 | sn005_2 == 19 | sn005_2 == 20)) |  	///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 8 | sn005_3 == 9 | sn005_3 == 14 | sn005_3 == 15 | sn005_3 == 16 | sn005_3 == 17 | sn005_3 == 18 | sn005_3 == 19 | sn005_3 == 20)) |  	///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 8 | sn005_4 == 9 | sn005_4 == 14 | sn005_4 == 15 | sn005_4 == 16 | sn005_4 == 17 | sn005_4 == 18 | sn005_4 == 19 | sn005_4 == 20)) |  	///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 8 | sn005_5 == 9 | sn005_5 == 14 | sn005_5 == 15 | sn005_5 == 16 | sn005_5 == 17 | sn005_5 == 18 | sn005_5 == 19 | sn005_5 == 20)) |  	///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 8 | sn005_6 == 9 | sn005_6 == 14 | sn005_6 == 15 | sn005_6 == 16 | sn005_6 == 17 | sn005_6 == 18 | sn005_6 == 19 | sn005_6 == 20)) |  	///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 8 | sn005_7 == 9 | sn005_7 == 14 | sn005_7 == 15 | sn005_7 == 16 | sn005_7 == 17 | sn005_7 == 18 | sn005_7 == 19 | sn005_7 == 20)))

replace carewhom = 6 if carein==1 & ((	sp019d29 	== 1 |		/// non-relatives
									 	sp019d30 	== 1 |		///
									 	sp019d31 	== 1 |		///
									 	sp019d33 	== 1 |		///
									 	sp019d29sp 	== 1 |		///
									 	sp019d30sp 	== 1 |		///
									 	sp019d31sp 	== 1 |		///
									 	sp019d35sp 	== 1 |		///
									 	sp019d36sp 	== 1 |		///
									 	sp019d37sp 	== 1 |		///
									 	sp019d35 	== 1 |		///
									 	sp019d36 	== 1 |		///
									 	sp019d37 	== 1 ) 		/// 
									 	|						///
									 	(wave == 4 & sp019d1sn == 1 & (sn005_1 == 21 | sn005_1 == 22 | sn005_1 == 23 | sn005_1 == 25 | sn005_1 == 26 | sn005_1 == 27)) | 	///
									 	(wave == 4 & sp019d2sn == 1 & (sn005_2 == 21 | sn005_2 == 22 | sn005_2 == 23 | sn005_2 == 25 | sn005_2 == 26 | sn005_2 == 27)) | 	///
									 	(wave == 4 & sp019d3sn == 1 & (sn005_3 == 21 | sn005_3 == 22 | sn005_3 == 23 | sn005_3 == 25 | sn005_3 == 26 | sn005_3 == 27)) | 	///
									 	(wave == 4 & sp019d4sn == 1 & (sn005_4 == 21 | sn005_4 == 22 | sn005_4 == 23 | sn005_4 == 25 | sn005_4 == 26 | sn005_4 == 27)) | 	///
									 	(wave == 4 & sp019d5sn == 1 & (sn005_5 == 21 | sn005_5 == 22 | sn005_5 == 23 | sn005_5 == 25 | sn005_5 == 26 | sn005_5 == 27)) | 	///
									 	(wave == 4 & sp019d6sn == 1 & (sn005_6 == 21 | sn005_6 == 22 | sn005_6 == 23 | sn005_6 == 25 | sn005_6 == 26 | sn005_6 == 27)) | 	///
									 	(wave == 4 & sp019d7sn == 1 & (sn005_7 == 21 | sn005_7 == 22 | sn005_7 == 23 | sn005_7 == 25 | sn005_7 == 26 | sn005_7 == 27)))

*>> Define labels for informal care variables
lab define carewhom_lab  	0 "No care"                                  ///
							1 "(Ex) spouse or partner"                   ///
							2 "Mother, father, stepmother, stepfather"   ///
							3 "Mother-in-law, father-in-law"             ///
							4 "Child(ren), child(ren)-in-law"            ///
							5 "Other relatives"                          ///
							6 "Non-relatives"                            
					
lab val carewhom carewhom_lab

* other recode 
recode sp019d1 		(-1 = .) // R provided help with personal care to: spouse/partner
recode sp019d1sp 	(-1 = .) // R provided help with personal care to: spouse/partner

*>> Waves 4 and 5 (discrepancy bw/ waves)
desc sp010d1_1 	/// 
sp010d1_2		/// 
sp010d1_3		/// 
sp010d2_1		/// 
sp010d2_2		/// 
sp010d2_3

* Create the variable as in Kaschowitz and Brandt (2017)
gen careout = .
replace careout = 0 if sp008_ == 5 // no care 
replace careout = 0 if sp008_ == 1 & (sp010d1_1!=1 | sp010d1_2!=1 | sp010d1_3!=1 | sp010d2_1!=1 | sp010d2_2!=1 | sp010d2_3!=1) & (sp011_1!=1 | sp011_2!=1 | sp011_3!=1) // sp010d2_* is about practical hh help 
replace careout = 1 if sp008_ == 1 & (sp010d1_1==1 | sp010d1_2==1 | sp010d1_3==1 | sp010d2_1==1 | sp010d2_2==1 | sp010d2_3==1) & (sp011_1==1 | sp011_2==1 | sp011_3==1)
replace careout = 1 if sp008_ == 1 & (sp011_1==1 | sp011_2==1 | sp011_3==1) & (wave == 3 | wave == 4) // wave==3 = 4th wave, wave==4 = 5th wave

*general care variable 
gen care = .
replace care = 0 if carein==0 & careout == 0
replace care = 1 if carein==1 | careout == 1

*>> Define labels for informal care variables
lab define lab_yes_no  	0 "No"    	1 "Yes"
lab val carein careout care lab_yes_no
lab var carein "Informal care (In HH)"
lab var careout "Informal care (Out HH)"
lab var care "Informal care (Out+In HH)"



*----	[ 5. Selection of Variables ]----------------------------------------------------------------------------*

*>> Keep only the necessary variables
keep 					///
fi 						///
FI* 					///
cluster					///
carein* 				///
careout* 				///
care* 					///
sp020_ 					///
partnerinhh 			///
depression				///
srh01 					///
maxgrip 				///
age 					///
sex 					///
country					///
marital 				///
nchild 					///
welfare 				///
isced 					///
newincome 				///
newwealth 				///
wave					///
dead 					///
hhid 					///
mn005_ 					///
couplepid coupleid 		///
pid 					///
mergeid

*>> Recode the variable "single or couple interview"
recode mn005_ (2=1 "First respondent") (3=2 "Second respondent"), gen(interview) // 1=first respondent, 2=second respondent 
drop mn005_ 



*----	[ 6. Final Save ]----------------------------------------------------------------------------------------*

*>> Final save
save "$share_all_out/SHARE_ANALYSIS_6.1.1_v3.0.dta", replace

*>> Close the log
log close

