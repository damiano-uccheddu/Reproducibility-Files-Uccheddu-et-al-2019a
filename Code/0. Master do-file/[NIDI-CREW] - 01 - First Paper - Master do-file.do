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

*----	[ 0. Stata Version & Settings ]--------------------------------------------------------------------------*
*----	[ 1. Define paths ]--------------------------------------------------------------------------------------*
*----	[ 2. Execute do-files ]----------------------------------------------------------------------------------*
*----	[ 3. Close ]---------------------------------------------------------------------------------------------*


******************************************************************************************************************



*----	[ 0. Stata Version & Settings ]--------------------------------------------------------------------------*

*>> Stata Version 
version 15.1

*>> Close the log file 
capture log close

*>> Other settings
clear
clear matrix
set max_memory .
set logtype text
set more off

*----	[ 1. Define paths ]--------------------------------------------------------------------------------------*

*>> Do-files
* 	Define here the paths of the do-files: 
global dataset_creation "C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Code/1. Dataset Creation"
global dataset_cleaning "C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Code/2. Data Cleaning"
global dataset_analysis "C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Code/3. Data Analysis"

*>> Log-files 
* 	Define here the paths of the log files: 
global share_logfile 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Log folder"

*>> Dataset (input)
* 	Define here the paths of the original SHARE datasets: 
global share_w1_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew1_rel6-1-1_ALL_datasets_stata" 
global share_w2_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew2_rel6-1-1_ALL_datasets_stata"
global share_w3_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew3_rel6-1-1_ALL_datasets_stata"
global share_w4_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew4_rel6-1-1_ALL_datasets_stata" 
global share_w5_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew5_rel6-1-1_ALL_datasets_stata"
global share_w6_in  	"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharew6_rel6-1-1_ALL_datasets_stata"
global share_W_all 		"A:/Encrypted datasets/Source/SHARE/Release 6.1.1/sharewX_rel6-1-1_gv_allwaves_cv_r_stata"

*>> Dataset (output)
* 	Define here the paths of the new created datasets: 
global share_w1_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w1"
global share_w2_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w2"
global share_w3_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w3"
global share_w4_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w4"
global share_w5_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w5"
global share_w6_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/w6"
global share_all_out 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/W_All"

*>> Codebook 
global codebook 	"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/Codebook"

*>> Tables and Figures
* 	Define here the paths for the output folder for tables and figures: 
global tables_out  		"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/Tables"
global figure_out 		"C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Output folder/Figures"


*----	[ 2. Execute do-files ]----------------------------------------------------------------------------------*

*>> Dataset Creation
do "$dataset_creation/[NIDI-CREW] - 01 - First Paper - Dataset Creation.do"

*>> Data Cleaning
do "$dataset_cleaning/[NIDI-CREW] - 02 - First Paper - Data Cleaning.do"

*>> Data analysis
do "$dataset_analysis/[NIDI-CREW] - 03 - First Paper - Data Analysis.do"


*----	[ 3. Close ]---------------------------------------------------------------------------------------------*

capture log close
