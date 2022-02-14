# SEISMIC WG1P6 Project 
 Code for [SEISMIC Working Group 1 (Measurements) Project 6](https://www.seismicproject.org/working-groups/measurement/) : Equity Gaps in Upper Division Courses
 
Code initially created as part of the SEISMIC Summer Measurements Fellowship 2021 by Victoria Farrar
 (Mentor: Dr. Natalia Caporale)
 
## SEISMIC Collaborators
| Name | Institution | Role |
| ----: |  ----: | :---- |
| [Victoria Farrar](mailto:vsfarrar@ucdavis.edu)| UC Davis | Analysis Lead, Graduate student |
[Natalia Caporale](mailto:ncaporale@ucdavis.edu)| UC Davis | Project Lead, Assistant Professor of Teaching|
[Montserrat Valdivia](mailto:mbvaldiv@indiana.edu) | Indiana University | Analysis Lead, Graduate student |
[Stefano Fiorini](sfiorini@indiana.edu)| Indiana University | Project Support |
[Nicholas Young](mailto:ntyoung@umich.edu)| University of Michigan | Analysis Lead|
[Becky Matz](mailto:rlmatz@umich.edu) | University of Michigan | Project Support |
[Ben Koester](mailto:bkoester@umich.edu) | University of Michigan | Project Support |
[Emily Bonem](mailto:ebonem@purdue.edu) | Purdue University | Analysis Lead | 
[Chantal Levesque-Bristol](mailto:cbristol@purdue.edu)| Purdue University| Project Support |

Working Group meeting notes can be found [here](https://docs.google.com/document/d/1VW4SUUVVpLWOKNFZiq5_D8Jlr0es731bYSH4elqOhn8/edit#).
(*permissions required*)
 
 
#  Project Goal
 This project aims to examine equity gaps associated with race/ethnicity, gender, first-generation status, low income status, international and transfer student status on equity gaps in upper-division science courses at various institutions. Ideally, the code in this repository will be used to analyse data from a variety of courses and institutions. We are beginning with two general, upper-division biology courses: Cell Biology and Genetics. 
 
 The goal of this code repository is to provide code that returns summary statistics, demographic information and mixed model outputs for a variety of course datasets.  To run, this code requires the R Statistical language and a dataset formatted in the described SEISMIC format (see more below).
 
#  How to run Code 
 
##  Dataset Preparation 

### Inclusion Criteria
For this project, we are currently using the following inclusion criteria: 
* Upper-division Cell Biology and Genetics 
	* ideally courses required by Biology majors; non-graduate level (though cross-listed is ok) 
	* Ex. from UC Davis: [BIS 104 and BIS 101](https://ucdavis.pubs.curricunet.com/Catalog/bis-courses-sc) 
	* Ex. from U Michigan: [MCDB 428](https://webapps.lsa.umich.edu/CrsMaint/Public/CB_PublicBulletin.aspx?crselevel=ug&DEPT=189100) and [BIOLOGY 305](https://webapps.lsa.umich.edu/CrsMaint/Public/CB_PublicBulletin.aspx?crselevel=ug&DEPT=189100)
* Date range: Fall 2009 - Spring 2019 
	* Excluding summers (semester system: Fall and Spring only, quarter system: Fall, Winter and Spring only) 
* Include transfer students 
	* (We are particularly interested in the impacts on transfer students!)
* First-time taking the course only
	* Please exclude students who are re-taking the course for a 2nd + time (i.e. include only their first attempt at the course) 
* Exclude Honors-only sections of the course
* Lecture courses only 
	* Please exclude lab and separate discussion sections of the course 
* Include numerical grades only
	* Please exclude students who took as Pass/No Pass (no letter grade)
	* Exclude students who dropped and withdrew
	* Include students who failed (D or F) 
* Include graduate students taking the course if they recieved a letter grade (see above point) 
* Include both full- and part-time students
* Include both degree-seeking and non-degree-seeking students (no filter on major either) 
* Include students even if they are missing some demographic data (our code will interpret these conservatively)

## Dataset Format and Variables 

Before running the code, ensure your data is formatted in the described SEISMIC format. Please reference this data dictionary for the correct variable names and minimum variables required: 
 
[DataDescription_ SEISMIC_ WG1P6.xlsx](https://docs.google.com/spreadsheets/d/1SJKqRIwwFkYRMk1GrEuAUOixMuZkXgmE/edit?usp=sharing&ouid=101003818724972958035&rtpof=true&sd=true) (Google Drive link; open access) 
 
Course-level variables and student-level variables should be included in the same data table. Course-level variables should be present as separate columns. For instance, if students took multiple courses at an institution, there should be one row per student:course combination. Students that retook courses should thus have multiple rows for a single student:course combination that differ by term and grade. Student-level demographic data should be consistent across each student's rows. Note that this formatting differs from that of some other WG1 projects, where there are separate tables for course- and student-level variables. 

See the below example: 

<!-- example-table-LIST:START -->
| crs_name| crs_term | st_id | female| firstgen | numgrade | gpao | 
| :----| :---- | :---- | :---- | :---- | :---- |:---- |
| PHYS101 | 202101|123| 0 | 1 | 2.0| 2.74 |
| BIO101 | 202103|123| 0 | 1 | 3.3|3.38 |
| CHEM001 | 202010|123| 0 | 1 | 4.0|3.89 |
| CHEM001 | 202101|456| 1 | 0| 3.7|3.45 |

For an example that includes all the "Bare Minimum" variables, see here: [Example dataset](https://docs.google.com/spreadsheets/d/14yD7tf09ZbpKUBF2KIkqPzPLpyKW9BeQyEd5zlR7EUM/edit?usp=sharing) (Google Doc; *open access*) 

### Bare minimum variables for running code:

Of the below required variables, this lists the *bare minimum* to run the code as it stands in this repository. Without these variables, the code will not run. 
Please refer to the DataDescription and Project meeting notes above for details of how these variables are defined. 

* st_id
* female
* ethniccode_cat
* urm 
* firstgen
* international
* transfer
* lowincomeflag
* numgrade
* cumpriorgpa
* gpao
* crs_name
* crs_term
* crs_retake
* summer_crs

### Required variables

✻ = variables specific to Project 6, not in original Working group 1 Data Description

Student-level variables

* st_id 
* firstgen
* ethniccode
* ethniccode_cat
* urm
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
* cum_ prior_ gpa ✻
* prior_units ✻



## Running Code

1. Download/ copy all scripts to a directory/folder on your computer. Ensure the properly-formatted dataset is also stored in this folder as a .csv.
2. The `seismic_setup.R` will be the only script you need to edit. At the top of the script, change the working directory to point to the folder where your dataset is located. This is also the folder where output files will be saved to. 

	`setwd <- c("~/Documents/your-folder/subfolder/")`

3. Then choose your dataset as `dat`. This will be the file name of your dataset, which should end in .csv. Please include the command `na.strings = c("","NA"))` which ensures blank cells will be entered as NA. Please name this dataset `dat`, as it will be referenced by other scripts by this name. 

	`dat <- read.csv("YOUR-DATASET-NAME.csv", 
                na.strings=c("","NA"))`

4. Define your institution name / abbreviation. For example, UC Davis could be entered as "UCD". Please use quotes. (This is used for file naming for outputs). 

	`institution <- "YOUR UNI"`    
                
4. Once these are entered correctly, select all the code in the `seismic_setup.R` script and press Run. (Command + Enter on Mac). This may take a few minutes, but it should output all files in your named folder. **Note:** This script will also *automatically* install any package dependencies you do not already have installed. 

**NOTE:** The robust models code may take > 30 minutes to run, depending on the RAM on your computer and the size of your course dataset at your institution. You can read more about this issue [here](https://github.com/vsfarrar/seismic_wg1p6/issues/1), and **if you are unable to get the robustlmm running, please [contact Victoria](mailto:vsfarrar@ucdavis.edu)**, who can help you try and run with pared-down code. 

5. Please upload your output .csv files to the [WG1P6 Output files Google Drive folder](https://drive.google.com/drive/folders/1JiFz9f0FdiU2dCpFRpXujOcm-TZZHSBP) (*access permissions required*). 


# Results Returned

* `demographic_gaps_by_term`
	* for each demographic group (female, firstgen, ethnicode_cat, transfer, lowincomeflag, international) it returns the mean and sem grade for each group for each term of each course, as well as the number of students in that group. 

* `mean_gpa_grade_difference_by_term` 
	* returns the mean and SEM difference between 0 and 1 for each demographic group in terms of prior gpa and grade for each offering of each course. 

* `mixed_model_outputs_main_effects` 
	* for each course, returns the beta estimates and SEM for a main effects only model 
	* numgrade ~ cum prior gpa + female + firstgen + ethnicode cat + transfer + international + lowincomeflag + (1|crs_term) 
	* note: There are two files for this. One codes URM as 0 or 1 (ethnicode cat == 1 or 3) and another shows the different values of ethnicode cat. 

* `mixed_model_outputs_main_effects_robust`
	* same as above, but using robust linear mixed models (robustlmm package) 
	
* `mixed_model_outputs_noGPAO_robust`
	* calculates the main effects using robust estimation but without controlling for GPAO 

* `n_excluded_by_filters` 
	* for each filtering criteria, gives the number of students that were excluded

* `n_missing_demographics` 
	* for each demographic group, lists how many students were missing information and were conservatively coded as 0. 

* `summary_stats_by_advantages`
	* parses out demographic variables into a set of "advantages", ranging from 1 - 4 advantages, and gives summary statistics for each advantages group 
