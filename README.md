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
[Chris Mead](mailto:cjmead1@asu.edu) | Arizona State University | Analysis Lead | 

Working Group meeting notes can be found [here](https://docs.google.com/document/d/1VW4SUUVVpLWOKNFZiq5_D8Jlr0es731bYSH4elqOhn8/edit#).
(*permissions required*)

<h4>
<img src="https://user-images.githubusercontent.com/23200201/193341444-d3a9714d-49bd-4f17-9f62-b5e5b9b8b4f4.png" width="25" height="25" />
Communicate with the team on the <a href= "seismic-team.slack.com">SEISMIC Project Slack </a> Channel: #wg1-p6-upper-div </h4>

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

Before running the code, ensure your data is formatted in the described SEISMIC format. Please reference the Bare-Minimum required variables list below and the Data Dictionary below  for the correct variable names and minimum variables required: 
 
[DataDescription_ SEISMIC_ WG1P6.xlsx](https://docs.google.com/spreadsheets/d/1SJKqRIwwFkYRMk1GrEuAUOixMuZkXgmE/edit?usp=sharing&ouid=101003818724972958035&rtpof=true&sd=true) (Google Drive link; open access) 
 
Course-level variables and student-level variables should be included in the same data table. Course-level variables should be present as separate columns. For instance, if students took multiple courses at an institution, there should be one row per student:course combination. Students that retook courses should thus have multiple rows for a single student:course combination that differ by term and grade. Student-level demographic data should be consistent across each student's rows. Note that this formatting differs from that of some other WG1 projects, where there are separate tables for course- and student-level variables. 

See the below example: 

<!-- example-table-LIST:START -->
| crs_name| crs_term | crs_year | crs_semq| crs_section |st_id | female| firstgen | numgrade | gpao | 
| :----| :---- | :---- | :---- | :---- | :---- |:---- |
| BIO101 | 202101|2021 | 01| 01 |123| 0 | 1 | 2.0| 2.74 |
| GEN102 | 202103|2021 | 03| 01 |123| 0 | 1 | 3.3|3.38 |
| CHEM103 | 202010|2020 | 10| 01 |123| 0 | 1 | 4.0|3.89 |
| GEN102 | 202101|2021 | 01| 02 |456| 1 | 0| 3.7|3.45 |

For an example that includes all the "Bare Minimum" variables, see here: [Example dataset](https://docs.google.com/spreadsheets/d/14yD7tf09ZbpKUBF2KIkqPzPLpyKW9BeQyEd5zlR7EUM/edit?usp=sharing) (Google Doc; *open access*) 

### Bare-minimum required variables for running code:

Of the below required variables, this lists the *bare minimum* to run the code as it stands in this repository. Without these variables, the code will not run. 

**Data Dictionary for Bare-Minimum Require Variables**

| **Variable**   | **Level**  | **Description**                                              | **Accepted Values** <br />*(if defined)*                                                                                                                                                                                                                                                                                             | **Other notes**                                                                                                                                                                     |
|----------------|------------|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| st_id          | student    | Unique student identifier                                    |                                                                                                                                                                                                                                                                                                                                      |                                                                                                                                                                                     |
| female         | student    | Gender                                                       | 0: Student self-reports gender as man <br /> 1: Student self-reports gender as woman<br /> 2: other or third-category<br /> If unknown, set to NA                                                                                                                                                                                    |                                                                                                                                                                                     |
| ethniccode_cat | student    | Race/Ethnicity Category                                      | 0 = Student only self-identifies as White. <br /> 1 = Student's self-identity includes Latino or Hispanic, <br /> Black or African American, American Indian, Alaska Native, or Pacific Islander, <br /> 2 = Asian/Asian American only or Asian/Asian American and White only <br /> 3 = Two or more unresolvable/catch-all unknown. | If mixed race/ethnicities, note that the definition <br />for 1 is "includes" any of those categories.                                                                              |
| firstgen       | student    | First-Generation College Student <br /> (Parental Education) | 0: At least one parent/guardian holds a Bachelor's degree <br /> 1: Neither parent/guardian holds a Bachelor’s degree or higher <br />                                                                                                                                                                                               |                                                                                                                                                                                     |
| international  | student    | International Status                                         | 0: U.S. Citizen or Permanent Resident 1: Non-Resident Alien                                                                                                                                                                                                                                                                          |                                                                                                                                                                                     |
| transfer       | student    | Transfer Status from another institution                     | 0: Non-transfer; first-year or freshman start, previous institution was high school <br /> 1: Transfer student from another two-year or four-year institution <br />                                                                                                                                                                 | Many institutions have a "transfer flag" with admissions/applications. <br /> If no transfer flag, base upon number of prior college units.                                         |
| lowincomeflag  | student    | Low Socioeconomic Status                                     | 0: Student does not come from a low-income family/area <br /> 1: Student flagged as low-income based on family household income.<br /> Use Pell grant eligibility, if unavailable,use <br /> $25,100*1.85 = $46,435 (185% of U.S. poverty line for household size of 4; $25,100)                                                     |                                                                                                                                                                                     |
| numgrade       | course     | Course Final Grade                                           | Numeric, converted from letter grades <br /> (use your institition's conversion scale)                                                                                                                                                                                                                                               | should be first time course taken                                                                                                                                                   |
| cum_prior_gpa  | course     | Student Cumulative Prior GPA                                 | Numeric. <br /> Prior, cumulative GPA of the student <br />  at the beginning of the term listed in crs_term. <br /> (should differ with each term)                                                                                                                                                                                  | values should have same range as `numgrade`                                                                                                                                         |
| gpao           | course     | Grade Point Average Omitting the Course of Interest          | Numeric. <br/> GPA in all courses throught this term, excluding this class. <br /> Use the cumulative GPAO over all terms at the institution <br /> (i.e., don’t include community college credits/grades)                                                                                                                           |                                                                                                                                                                                     |
| crs_name       | course     | Course Name                                                  | Catalog code for course of interest. e.g. "BIOL101"                                                                                                                                                                                                                                                                                  |                                                                                                                                                                                     |
| crs_subject    | course     | Course Subject                                               | **Project-specific subject codes.** <br /> Allowed values: <br /> - Genetics <br /> - CellBio  <br /> (case-sensitive)                                                                                                                                                                                                               |                                                                                                                                                                                     |
| crs_term       | course     | Course Term                                                  | Categorical, year/term in which academic year the course took place;  <br />                                                                                                                                                                                                                                                         | Note: Can use whatever notation your institution uses, including unique identifiers. <br /> `crs_year`  and  `crs_semq`  have specific format requirements.                         |
| crs_year       | course     | Year of Course Term                                          | Numeric, YYYY format. (e.g. 2021). Year that the course term was offered.                                                                                                                                                                                                                                                            |                                                                                                                                                                                     |
| crs_semq       | course     | Semester or Quarter of Course Term                           | Numeric, ## format that denotes semester or quarter offered. <br /> Allowed values: <br /> 01: Winter quarter or Spring / Winter semester 03: Spring quarter 10: Fall quarter or Fall semester                                                                                                                                       |                                                                                                                                                                                     |
| crs_section    | course     | Course Section                                               | If more than one section offered per term, the section number. <br /> E.g. 001, 002, etc. <br /> If only one section offered per term, default to 1. <br />                                                                                                                                                                          |                                                                                                                                                                                     |
| crs_retake     | course     | Course Retaken                                               | 0: not a retake (first time taken) <br /> 1: retake (time retaken does not matter)                                                                                                                                                                                                                                                   | Note: given the inclusion criteria,  <br /> it is possible to only have crs_retaken == 0 in full dataset.  <br /> If missing, can create dummy variable of crs_retaken == 0. <br /> |
| summer_crs     | course     | Summer Course Offering?                                      | 0: offered during academic year (fall,winter,spring) <br /> 1: offered during summer <br />                                                                                                                                                                                                                                          | Note: given the inclusion criteria, <br /> it is possible to only have summer_crs == 0 in full dataset. <br /> If missing, can create dummy variable of summer_crs == 0.  <br />    |
| class_standing | course     | Student Class Standing                                       | Student class standing at term course was taken (`crs_term`) <br /> Allowed values: <br /> (case-sensitive,use all caps) <br /> FR:Freshman <br /> SO:Sophomore <br /> JR:Junior<br /> SR:Senior<br /> Please use your institution's unit cutoffs for these definitions.                                                             |                                                                                                                                                                                     |


You can refer to the DataDescription and Project meeting notes above for more details of how these variables are defined. 

## Running Code

1. Download/ copy all scripts to a directory/folder on your computer. Ensure the properly-formatted dataset is also stored in this folder as a .csv.

	To download without using GitHub locally or GitHub desktop, press the green "Code" button at the top left of this page and then select "Download Zip". 
	
	<img width="400" alt="Screen Shot 2022-09-12 at 12 15 02 PM" src="https://user-images.githubusercontent.com/23200201/189737474-4b583835-4522-46f5-b775-a4200d11eefb.png">

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

22 .csv files should be returned by the script: 

*  **\international-excluded**
	* creates a folder with all of the above figure analyses, but with international students completely excluded from the analysis. The number of international students excluded can be found in the `n_missing_demographics` file. 
	* should contain 10 .csv files with the suffix `_no-international`

* `advantages_by_offering`
	* parses out demographic variables into a set of "advantages", ranging from 1 - 4 advantages, and gives summary statistics for each advantages group 
	
* `demographic_gaps_by_offering`
	* for each demographic group (female, firstgen, ethnicode_cat, transfer, lowincomeflag, international) it returns the mean and sem grade for each group for each offering (term + section) of each course, as well as the number of students in that group. 

* `mean_gpa_grade_difference_by_offering` 
	* returns the mean and SEM difference between 0 and 1 for demographic groups (gender,firstgen, transfer, lowincomeflag) in terms of prior gpa, GPAO and grade for each offering of each course. 

* `mean_gpa_grade_diff_offering_ethniccode` 
	* returns the mean and SEM difference between each level of ethnicity categories for each offering of each course. 

* `mixed_model_outputs_main_effects_robust`
	* for each course, returns the beta estimates and SEM for a main effects only multilevel model using robust linear mixed models (robustlmm package) 
	* numgrade ~ GPAO + female + firstgen + ethnicode cat + transfer + lowincomeflag + (1|crs_offering) 
	
* `mixed_model_outputs_noGPAO_robust`
	* calculates the main effects above using robust estimation but without controlling for GPAO 

* `n_excluded_by_filters` 
	* for each filtering criteria, gives the number of students that were excluded

* `n_missing_demographics` 
	* for each demographic group, lists how many students were missing information and were conservatively coded as 0. 

* `sai_by_offering`
	* calculates Systemic Advantage Index (SAI; see Sarah Castle's work in WG1P1) and reports summary statistics for each group: n, mean + SEM course grades, GPAO, and grade anomaly for each offering of each course. 
	
* `sai_plot`
	* calculates SAI on average for each course overall for a general SAI plot comparing all courses across universities. 
	
* `sai_plot_by_gender`
	* same as sai_plot, but disaggregates advantages by gender 
	
* `sai_plot_by_transfer`
	* same as sai_plot, but disaggregates advantages by transfer status
	

# Workflow Diagram 
![seismic-wg1p6_workflow_diagram_2022-08-29](https://user-images.githubusercontent.com/23200201/187312805-b51f7dc0-68ee-401b-8f06-5ed4995a9fec.png)



	

