# TexasNameCleaning

## Texas Marriage/DUI Data
This project is a work in progress, so much of the code is incomplete. Additionally, it is a collaborative effort. 

**last update: Wed. Feb 15, 2022

Cleaning Texas Marriage Records and merging them to DUI Records.

View in Google Docs at: https://docs.google.com/document/d/1azZlNd1R7mp8FjCdaeEJUYuKG8x7aVoW0Vq4er_M80I/edit?usp=sharing

This repository includes 6 main .do files (Stata files) and 1 .ipynb file (python file) that accomplish the cleaning and merging tasks. This process occurs over the course of 2 steps. The cleaning process mirrors the processes found in the Texas birth record cleaning code and the Texas DUI name cleaning code. These steps (and their associated .do files) are as follows: 

STEP x.1: Clean Marriage data
Step x.1 cleans the raw Texas marriage data. The purpose of this step is to set up the primary dataset for Texas Marriage records that will be used in the regression and analysis for this research project. This step is composed of 5 .do files and 1 .ipynb file, listed below in the order they should be run.
latin_surnames.do
scrape_txcountycodes.do
marriage_append.do
marriage_cleaning_tx_v6.do
Note: this file was originally named: STEP_read_marriagedivorce.do
genderByName.ipynb
marriage_gender_merge.do

STEP x.2: Merge Marriage, DUI data
Step x.2 merges the cleaned marriage data with DUI data from Step x.1. The marriage record data allows us to have the marriage data for more robust matching purposes; the purpose of this step is to create independent outcomes on marriage variables when looking at the effects of a DUI from the result of the merge. This step is composed of 1 .do file, listed below. 
STEP_ merge_dui_marriage.do
Note: this file was originally named: STEP_merge_dui_marriagedivorce.do

Each of these files will be explained in detail in the sections that follow (as well as their input, intermediary, and output files). Please note that the pathing of each file’s save location is based on the Box setup for DUIAshlyn>texas and then divided into our three directories: raw_data, intermediate_data, clean_data.

STEP x.1: Clean Marriage data
latin_surnames.do
In this file, we read in the latin surnames data retrieved from Jacob Kaplan’s Github, https://rdrr.io/github/jacobkap/predictrace/. The purpose of this step is to prepare the latin surname database for merging with our marriage records data in “marriage_cleaning_tx_v4.do”. We drop several variables, keeping only the name variable, and then merge in the latin first names data retrieved from the same location. After this merge, we keep only the surnames that did not merge with any first names. We do this to ensure that we don’t include any names that could be first names. We include this step in order to have more robust name cleaning for latin names so that we don’t systematically add bias against hispanic people re: the observations that match later on (thanks to sufficient name cleaning in marriage_cleaning_tx_v4.do). 
Note: BEFORE fixing how we matched first and last names in this file, in the marriage texas record .do file there were 722 obs with 3 words where all m*==1 (all marked as last names) whereas AFTER fixing how we matched first and last names in this file, in the marriage texas record .do file there were 385 obs with those same parameters.
INPUT:
surnames_race.csv
	>"$raw_dir/race_prediction/surnames_race.csv"
first_names_race.csv
	>"$raw_dir/race_prediction/first_names_race.csv"
INTERMEDIARY: 
latin_names.dta
	>$int_dir/latin_names.dta
OUTPUT: 
latin_names.dta
>$int_dir/latin_names.dta

scrape_txcountycodes.do
This file reads in county and their associated codes for each county in Texas scraped from http://onlinemanuals.txdot.gov/txdotmanuals/tri/texas_counties_and_code_numbers.htm. This data will allow us to create a marriage county code variable for the years in which this variable is missing (namely, 1998 and 2000 in append_marriage.do). 
The file is broken into two phases: webscraping (Phase 1) and data cleaning (Phase 2). The data webscrape is done in Stata with a package from SSCC. Further information about this package can be found at https://sscc.wisc.edu/sscc/pubs/readhtml.htm. The data cleaning is as it sounds. Specifics about how we cleaned the data can be found in the file itself. 
INPUT: N/A
INTERMEDIARY: N/A
OUTPUT:
tx_county_code.dta
>$int_dir/tx_county_code.dta

marriage_append.do
This file reads in Texas marriage data from https://www.dshs.texas.gov/vs/marr-div/indexes.aspx, 
downloaded in February 2022. We then save this data into marriage files separated by year for 1977 through 2019. Finally, we append each of these files to create a master dataset that can be used for cleaning in further sets. Also it does tiny cleaning for each year as it’s pulled in and saved but we can explain that more eloquently. Basically we pull in each year, save as a .dta file, append all in a loop, and then save as the final output file.
	Note that for the years 1998 and 2000, the raw data did not include a variable for marriage county codes. We address this by merging the data from these years with the web scraped county codes output from the previous .do file. 
INPUT:
MARR`##’.txt
>$raw_dir/`####’/MARR`##’.txt 
for years 1977 - 2008, 2011, 2013
marr`##’.txt 
>$raw_dir/`####’/marr`##’.txt 
for years 2009, 2010, 2012
MARRIAGE_INDEX14_RUN07252016.TXT
> "$raw_dir\2014\MARRIAGE_INDEX14_RUN07252016.TXT"
for year 2014
MARRIAGE20`##’_INDEX.TXT
>$raw_dir\20`##’\MARRIAGE2015_INDEX.TXT 
for years 2015-2016
marrage20`##’_index.csv
>$raw_dir\2017\marrage2017_index.csv
for years 2017-2019
INTERMEDIARY: N/A
OUTPUT: 
marriage`####’.dta
>$int_dir/marriage`####’.dta
for years 1977-2019

marriage_cleaning_tx_v6.do
This file reads in Texas marriage data files from marriage_append.do into the intermediate directory for cleaning, with an outer loop pulling each year file for cleaning and an inner loop dividing each year into files by first letter of first name. Note that we wrote this .do file based on the 2019 dataset. 
	The outline of this file is as follows. We start with a big “outer loop” that extends through the majority of the .do file, reading in each marriage file by year for years 1977-2019. For each year, most of our cleaning is focused on standardizing the names of individuals to a format that can be merged with the voter + birth records + DUI merged datasets (previously merged). We expand on the name cleaning process below. We then create a birth date variable range (min and max) based upon age and marriage date, followed by renaming variables and adding labels to our final variables. We end the “outer loop” by working by first letter of the first name to read in each cleaned  marriage record file by year (resulting in letter by year marriage files). After the “outer loop”, we finish by appending each letter by year dataset to have a final output of marriage records by letter.
As a first step before name cleaning begins (after reading in a given year), we reformat the data. This is necessary because when we read the data in, it is formatted such that each marriage is an observation. We reformat it so that each individual is an observation. Thus, we create two observations for each marriage. 
Right before we clean names, we create a spouse name variable in preparation for the next .do file step where we merge likely gender into the marriage dataset. We’ll expand on why we did this in the next step.
Name cleaning can be divided into four “sections”: (1) suffixes, (2) compound last names, (3) cases for number of words in name (under general assumptions), and (4) cases for number of words in name (for last names flagged as Latin). These sections go as follows:
(1) For suffixes, we follow the general procedure used in Step_1 of the Ohio DUI name cleaning code, which is a modified version of the Texas DUI Step_1 name cleaning code. This starts with adjusting suffixes, such as “II” becoming “JR.” We then deviate from the Ohio DUI code, adjusting this code slightly in order to condense the name prefixes section into a loop rather than repeating the same code for each case. (For more info about local variables and usage in loop ranges, see page 3 of https://www.stata.com/manuals13/pforvalues.pdf). We don’t address the cases of V and VI because we found these suffixes to be rare in our data, and the use of such common letters was confounding our process. More details in the file itself.
(2) We then move on to compound last names. For this portion of name cleaning, we create a new num_split variable with two new local variables, m, k, and h,  where k is based on the number of total number of splits minus 1 (because for the two-word name loop, we need the number of words - 1 in order for the indexing of the loop to work), m is  based on just the regular number of words– like n– and h is the number of words in the name minus two (because for the following three-word name loop, we need the number of words -2  in order for the indexing of the loop to work). The purpose of this loop is to catch multi-word names, such as cases containing “mc” for two word names (e.g. McMurray) and “de la” for three word names (e.g. de la Cruz). Our loop goes through in the same way as the suffix loop in order to catch prefixes/prepositions in all name positions, updating each name split as adjustments are made (hence the sensitivity to indexing). More details in the file itself. 
Note: We approach cases with the prefix “O” (191 observations in 2019), “A” (89 observations in 2019) and “D” (831 observations in 2019) with special care because these letters may be abbreviations or name affixes (e.g. O. for Oscar or O+Connor for O’Connor, A. for Alice or A + bdullah for Abdullah, D. for Denise or D+angelo for D’angelo). We decided to exclude “O”, “A”, and “D” in order to audit each case for whether or not it was safe to generally include or exclude. For the “O” case, we opted to exclude “O” from the loop and instead add names to the loop such as “O’Neal” and “O’Leary”. For the “D” case, we opted to exclude “D” from the loop and instead add names to the loop such as “D’Andre” and “D’Ann”.  For the “A” case, we opted to exclude “A” from the loop because we couldn’t find any examples after several audits where the “A” seemed like an appropriate affix instead of an abbreviation.
(3) After now having cleaned name particles/definite articles/prefixes such as “de la”, “mc”, and “vom” in addition to suffixes such as “JR.”, we attempt to divide full names into first, middle, and last names. We are, however, unable to create all the same variables due to unclear parsing options. Specifically, the DUI data we mirrored was formatted “last, first middle”, whereas the marriage data contains no commas or other distinguishing separators between first, middle, and last. Instead, it is generally formatted as “last first middle”. We address this issue by separating names according to cases, where cases are differentiated by number of words in the adjusted names (where names such as “de la cruz” are now “delacruz”, a single word).
We approach the general problem of splitting our full name variable in 6 cases based on the number of words in the raw full name variable. For the two word case, there are 240,614 observations in 2019. Auditing a sample of these led us to assume the form “last first”, so we split the names accordingly in our generalized code. For the three word case, there are 213,723 observations in 2019. Auditing a sample of these led us to assume the form “last first middle”, so we split the names accordingly in our generalized code. For the four word case, there are 26,352 observations in 2019. Auditing a sample of these led us to assume the form “last last first middle”, so we split the names accordingly in our generalized code. For the five word case, there are 25 observations in 2019. A quick audit led us to assume that names are in the form “last last first middle middle”, so we split the names accordingly in our generalized code. For the six word case, there are 3 observations in 2019. After investigating name origin, we assume the form “last first middle middle middle middle” for this case and split the names accordingly  in our generalized code. For the 2019 marriage file, there are no names in the 7+ word cases, so we move on to testing this file on earlier marriage file years to see if our method of cleaning is generalizable, which we will expand upon shortly. Upon auditing 2019, we found that our code generally worked well for cleaning but about 10% of observations had words in their names that were not well-matched to the first/middle/last names variables, the majority of which were latin. We address this bias in our cleaning below. For 2019, we find that about 12.5% of observations fall in the 2-word case, about 78% fall in the 3-word case, about 9.5% fall in the 4-word case, and less than 1% in total fall under the 1-, 5-, 6-, 7-, and 8-word cases.
(4) Finally, we address cases for Latin last names. We address this in particular because after initially auditing the general cases defined above, we found that we had a likely bias in our cleaning algorithm against Latin names re: correct order of names. Specifically, the algorithm seemed to work for non-Latin names, but for many Latin-sounding names it was less clear. To flag a name as Latin, we merged on latin_names.dta (described earlier in this README). We then address two cases: 3-word names and 4-word names. Details found in the file itself. We make specific adjustments to some names. As an example, take the name “Gonzales Cruz Z”. By normal convention, we would assume this person is named Z Cruz Gonzales. However, this name would be unable to match with names from other data files (e.g. birth index, dui records, etc) because the matches occur on the basis of first and last name rather than first initial. This being the case, we change names such as this to the form of Cruz Z. Gonzales because even if it is incorrect, there’s a higher chance of it possibly matching (aka if var  “firstname” is an initial, it won’t match even if we correctly assigned the the initial to “firstname” for the irl person, so we may as well use a format that would match only if correct even if it is less likely, and only matches if it doesn’t mess up the other name cleaning that actually worked).
As for the date variables: for the marriage date variables, we assume the form DMY or YMD and work in cases across years to make a marriage date variable that fits the format that the raw data comes in. We also create a year variable to know where each observation comes from (in the future combined dataset) and in case the marriage date variable is empty. For the birthday variables, we estimate maximum and minimum possible birthdays for each observation based on the Texas DUI code (details in the Texas DUI README or within the .do file itself). 
Variable dropping is self-explanatory, but we decided to drop the vars that were only used for reshaping, loops, and creating other variables. Before adding variable labels, we rename variables to match the convention of “source_varname” in preparation for future merging (e.g. dui_middle_initial). The only variables that don’t receive a source prefix are “first_name” and “last_name”, the variables that we will be merging on.  Variable labeling is to add clarity to remaining variables that will be used in the merge. 
The last thing we do is create a spouse last name variable for each observation. We do this by taking our clean dataset and dropping everything except spouse name and full name, merging spouse name with the original clean dataset on fullname. Then we drop all the variables we don’t need except for spouse last name. Again, we’ll expand on why we do this in the next .do file step because this explanation is already very long lol.
INPUT:
marriage`####’.dta
>$int_dir/marriage`####’.dta
for years 1977-2019
INTERMEDIARY: 
marriage_`####’.dta
>$int_dir/clean_name_marr/marriage_`####’.dta
for years 1977-2019
marriage_`####’_`var’.dta
>$int_dir/clean_name_marr/year_first_init/marriage_`####’_`var’.dta
for years 1977-2019
OUTPUT (OLD): 
marriage_`var’.dta
>$int_dir/clean_name_marr/marriage_`var’.dta
for letter initials A-Z
OUTPUT: 
marriage_wspouse_`var’.dta
>$int_dir/clean_name_marr/marriage_wspouse_`var’.dta
for letter initials A-Z

genderByName.ipynb
This file reads in name gender data from https://archive.ics.uci.edu/ml/datasets/Gender+by+Name (a machine learning data repository from UCI) in order to prepare for the merge with the cleaned marriage data.
	Note that the raw name gender data, name_gender_dataset.csv, has four variables: name, gender, count, and probability. Each name occurs twice so (for example) James (male) lists the count of men named James and the probability of being named James given that you are a man, whereas James (female) lists the count of women named James and the probability of being named James given that you are a woman. Thus this python file cleans the raw data by keeping only the namexgender with the higher probability (e.g. James (female) is dropped so the cleaned name gender dataset will merge with “James” in the cleaned marriage dataset under the assumption that James is a male).
INPUT:
name_gender_dataset.csv
>$raw_dir/name_gender_dataset.csv
INTERMEDIARY: N/A
OUTPUT: 
cleanedNames.csv
>$raw_dir/cleanedNames.csv

marriage_gender_merge.do
This file reads in marriage with spouse name data from the cleaned marriage dataset, marriage_wspouse_’A-Z’.dta, in preparation to merge with the cleaned dataset from the previous step, cleanedNames.csv. We do this in order to add a gender variable to the marriage dataset. The goal is to merge the women to the DUI dataset twice; once with potential maiden names, once with potential married names (hence the focus on spouse name in marriage_cleaning_tx_v6.do). Having a gender variable in the marriage dataset will allow us to make the name split(s) for the women to be able to run the DUI/marriage merge twice. 
Note that we save over the previous “marriage_wspouse_’A-Z’.dta” files so as to not take up so much space in the Box. Also note that this output file is what we will use for the “baseline” merge to DUI data, namely men’s names and unchanged women’s names (so presumably maiden names). We also create another set of marriage files, women_married_names_’A-Z’.dta, where we replace last_name with spouse_last_name so as to have a file with changed women’s names (married last names) in preparation for the merge to DUI data in the next step. We also create an id variable before splitting into two datasets to be able to match the women married to maiden names after the DUI merge.
INPUT:
cleanedNames.csv
>$raw_dir/cleanedNames.csv
marriage_wspouse_`A-Z’.dta
>$int_dir/clean_name_marr/marriage_wspouse_`A-Z’.dta
INTERMEDIARY: N/A
OUTPUT: 
marriage_wspouse_`A-Z’.dta
>$int_dir/clean_name_marr/marriage_wspouse_`A-Z’.dta
women_married_names_`A-Z’.dta
>$int_dir/clean_name_marr/women_married_names_`A-Z’.dta

STEP x.2: Merge Marriage, DUI data
STEP_merge_dui_marriage.do
This file __________.
INPUT:	 
file.dta
>
INTERMEDIARY:
file_`A-Z’.dta
>
OUTPUT: 
 file_`A-Z’.dta
	>




