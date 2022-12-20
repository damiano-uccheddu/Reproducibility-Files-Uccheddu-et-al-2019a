# Reproducibility Files

### Uccheddu, Damiano, Anne H. Gauthier, Nardi Steverink, and Tom Emery. ‘Gender and Socioeconomic Inequalities in Health at Older Ages Across Different European Welfare Clusters: Evidence from SHARE Data, 2004–2015’. *European Sociological Review* 35, no. 3 (2019a): 346–62. https://doi.org/10.1093/esr/jcz007.



# Instructions: 

1. Download the data (SHARE Release 6.1.1) from this link: https://releases.sharedataportal.eu/users/login 
2. Unzip the downloaded compressed (zipped) folders in the path "C:/Users/[your_username]/Documents/Dataset/SHARE/Release 6.1.1"
3. Open the master do-file "[NIDI-CREW] - 01 - First Paper - Master do-file.do"
4. Change all the paths to match your own computer's paths (rows from 58 to 92 in the Master do-file). For instance, if you are using Microsoft Windows, change the path from "C:/Users/Damiano/Dropbox/NIDI/01 - First Paper/Reproducibility Files/Code/1. Dataset Creation" to "C:/Users/[your_username]/[your_path/Data Analysis/Code/1. Dataset Creation" and create the appropriate folders if necessary. 
5. Run the do-file "[NIDI-CREW] - 01 - First Paper - Master do-file.do" to perform the data analysis.



# Notes:
- The do-file "[NIDI-CREW] - 01 - First Paper - Dataset Creation.do" merges and appends all the necessary modules and waves of SHARE, creating a dataset in long format
- The do-file "[NIDI-CREW] - 02 - First Paper - Data Cleaning.do" cleans the dataset, harmonizes some variables, creates the independent and dependent variables, and selects only the necessary variables that will be used in the main analysis. 
- The do-file "[NIDI-CREW] - 03 - First Paper - Data Analysis.do" performs the analyses included in the study and the robustness checks asked by the reviewers. It also includes the "results available upon request" mentioned in the paper. 
- The tables will be shown in the Excel file "Tables.xlsx" contained within the folder "C:/Users/[username]/[...]/Damiano Uccheddu - Publication Package (2019)/Data Analysis/Output folder/Tables/Excel Tables"
- The figures will be shown in the folder "C:/Users/[username]/[...]/Damiano Uccheddu - Publication Package (2019)/Data Analysis/Output folder/Figures"
