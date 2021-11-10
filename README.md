# SEISMIC WG1P6 Project Code
 Code for [SEISMIC Working Group 1 (Measurements) Project 6](https://www.seismicproject.org/working-groups/measurement/) : Equity Gaps in Upper Division Courses
 
 Created as part of the SEISMIC Summer Measurements Fellowship 2021 by Victoria Farrar
 (Mentor: Dr. Natalia Caporale)
 
#  Project Goal
 This project aims to examine equity gaps associated with race/ethnicity, gender, first-generation status, low income status, international and transfer student status on equity gaps in upper-division science courses at various institutions. Ideally, the code in this repository will be used to analyse data from a variety of courses and institutions. 
 
 The goal of this code repository is to provide code that returns summary statistics, demographic information and mixed model outputs for a variety of course datasets.  To run, this code requires the R Statistical language and a dataset formatted in the described SEISMIC format (see more below).
 
#  How to run Code 

## UMich specific instructions
To run this code with the UMich data, you will need to format the LARC data into something more useable. For that, Ben has provided scripts to do.

* For general formatting, see [Ben's LARC repo](https://github.com/bkoester/LARC)
* For SEISMIC formatting, see [Ben's WG1-P1 repo](https://github.com/seismic2020/WG1-P1/tree/master/UMICH) Note that this does not return all of the variables needed for this project. (mainly the uppr division specific).

* In this repo, Nick has added an  `wg1_p6_rename_umich_seismic` file that adds those other file names. After running the `simp_larc.reduction.pipeline` script in Ben's LARC repo, you can run this script to get all the necessary (and some extra) variables for wg1_p6.
	* The output of this script will return the student record and student course files separately and a third file which is the wg1_p6 formatted data.
	* Be warned that this process might take multiple hours if using the full LARC flat files.
	* You will need the student records, student course, and student term databases for the code to run correctly.
* Nick has also added a `Visualizing Results` script to make the plots for the `demographic_gaps_by_term` results.

For cleanness, the outputs will go to a results folder in the repo. Make sure you create one before running the code!

### Minor updates in this branch
There were some spelling errors in the main branch for variables names. Those changes are documented here
* data_filtering lines 39 & 40 have ethniccode_cat spelled wrong. Line 44 lowincomflag doesn't match github repo name, line 56 lowincom
* Gapsovertime: lowincom line 7, 47;adding mean_gpao to line 54 because line 57 needs it
* Outputs: line 9, 22. ethniccode_cat is spelled wrong line 9
* Advantages: all of line 7 groupings

Also note that in the outputs file, we have changed `map` to explicitly be from the `purrr` package. For some reason, R was pulling from a different package and throwing errors.
 
##  Dataset Preparation 
 
 Before running the code, ensure your data is formatted in the described SEISMIC format. Please reference this data dictionary for the correct variable names and minimum variables required: 
 
[DataDescription_ SEISMIC_ WG1P6-modifications.xlsx](https://docs.google.com/spreadsheets/d/1XcpZ3gNCmca7ECmhbUus-73b1mIsPE4w/edit?usp=sharing&ouid=101003818724972958035&rtpof=true&sd=true) (Google Drive link; open access) 
 
Course-level variables and student-level variables should be included in the same data table. Course-level variables should be present as separate columns. For instance, if students took multiple courses at an institution, there should be one row per student:course combination. Students that retook courses should thus have multiple rows for a single student:course combination that differ by term and grade. Student-level demographic data should be consistent across each student's rows. Note that this formatting differs from that of some other WG1 projects, where there are separate tables for course- and student-level variables. 

See the below example: 

<!-- example-table-LIST:START -->
| crs_name| crs_term | st_id | female| firstgen | numgrade | gpao | 
| :----| :---- | :---- | :---- | :---- | :---- |:---- |
| PHYS101 | 202101|123| 0 | 1 | 2.0| 2.74 |
| BIO101 | 202103|123| 0 | 1 | 3.3|3.38 |
| CHEM001 | 202010|123| 0 | 1 | 4.0|3.89 |
| CHEM001 | 202101|456| 1 | 0| 3.7|3.45 |

### Bare minimum variables for running code: 
✻ = variables specific to Project 6, not in original Working group 1 Data Description

Student-level variables

* st_id 
* firstgen
* ethniccode
* ethniccode_cat
* female
* lowincomflag
* transfer
* international
* grad_gpa ✻
* grad_major ✻
* grad_term ✻
* admit_term ✻
* time_ to_grad ✻

Course-level variables 

* crs_sbj
* crs_name
* numgrade
* numgrade_w
* is_dfw
* crs_retake
* crs_term
* summer_crs
* gpao
* crs_component
* current_major
* begin_ term_ cum_gpa 
* urm 
* cum_ prior_ gpa ✻
* prior_units ✻


## Running Code

1. Download/ copy all scripts to a directory/folder on your computer. Ensure the properly-formatted dataset is also stored in this folder as a .csv.
2. The `seismic_setup.R` will be the only script you need to edit. At the top of the script, change the working directory to point to the folder where your dataset is located. This is also the folder where output files will be saved to. 

	`setwd <- c("~/Documents/your-folder/subfolder/")`

3. Then choose your dataset as `dat`. This will be the file name of your dataset, which should end in .csv. Please include the command `na.strings = c("","NA"))` which ensures blank cells will be entered as NA. Please name this dataset `dat`, as it will be referenced by other scripts by this name. 

	`dat <- read.csv("YOUR-DATASET-NAME.csv", 
                na.strings=c("","NA"))`
                
4. Once these are entered correctly, select all the code in the `seismic_setup.R` script and press Run. (Command + Enter on Mac). This may take a few minutes, but it should output all files in your named folder. **Note:** This script will also install any package dependencies you do not already have installed. 


# Results Returned

* `demographic_gaps_by_term`
	* for each demographic group (female, firstgen, ethnicode_cat, transfer, lowincomeflag, international) it returns the mean and sem grade for each group for each term of each course, as well as the number of students in that group. 

* `mean_gpa_grade_difference_by_term` 
	* returns the mean and SEM difference between 0 and 1 for each demographic group in terms of prior gpa and grade for each offering of each course. 

* `mixed_model_outputs_main_effects` 
	* for each course, returns the beta estimates and SEM for a main effects only model 
	* numgrade ~ cum prior gpa + female + firstgen + ethnicode cat + transfer + international + lowincomeflag + (1|crs_term) 
	* note: There are two files for this. One codes URM as 0 or 1 (ethnicode cat == 1 or 3) and another shows the different values of ethnicode cat. 


* `n_excluded_by_filters` 
	* for each filtering criteria, gives the number of students that were excluded

* `n_missing_demographics` 
	* for each demographic group, lists how many students were missing information and were conservatively coded as 0. 
             