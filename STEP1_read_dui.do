************************************************************
**This file will read in and clean Texas DUI data

*TO DO:
* - Try to fix the few hundred obs that may be the same incident with typos fixed
* or may be different incidents (see note near bottom of do-file)
************************************************************

clear all
set more off
program drop _all



**Root directory
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
*global root_dir C:\Users\andersee\Box\DUI\texas
*global root_dir "C:\Users\jtd44\Box\DUI\texas"
global root_dir C:\Users\ashlyn04\Box\DUIAshlyn\texas


global raw_dir "$root_dir/raw_data"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"



*** Prep predicted race vars to merge onto breath tests ***
import delimited using "$raw_dir/race_prediction/first_names_race.csv", clear


drop v1

rename name first_name

foreach var in likely_race probability_american_indian probability_asian probability_black probability_hispanic probability_white probability_2race	{
	
	rename `var' f_`var'
	
}

//upper("x"") returns the uppercase version of "x": "X"
replace first_name = upper(first_name)

save "$int_dir/first_name_race", replace


import delimited using "$raw_dir/race_prediction/surnames_race.csv", clear

drop v1

rename name last_name

foreach var in likely_race probability_american_indian probability_asian probability_black probability_hispanic probability_white probability_2race	{
	
	rename `var' l_`var'
	
}

replace last_name = upper(last_name)

save "$int_dir/last_name_race", replace






*** Bring in raw data
import excel using "$raw_dir/breath_test_data/Texas BrAC data.xlsx", first clear

rename *, lower

exit

destring cage result, force replace


*** Some obs are not useful records
*Some obs appear to be duplicates
duplicates drop

drop if fname=="" // vast majority are clearly test/inspection runs

** Drop tests marked as not valid
//drop if vtest==0 // If we add this restriction back in, delete lines 138-140 and remove dui_all_tests_invalid from keep command near the bottom.

**Some records are there for administrative purposes and don't correspond to an individual
drop if substr(fname,1,1)=="." | substr(fname,1,1)=="0" | substr(fname,1,1)=="1" | substr(fname,1,1)=="2" | substr(fname,1,1)=="3" | substr(fname,1,1)=="4" | substr(fname,1,1)=="5" | substr(fname,1,1)=="6" | substr(fname,1,1)=="7" | substr(fname,1,1)=="8" | substr(fname,1,1)=="9" 

drop if regexm(lname,"(INSP TS|PRACTICE|DOES NOT EXIST|PRACTICE|LEFT BLANK)")
drop if lname==""


**Some tests are from certification exercises - show up as names with many dups, mostly
**happening in Sept and Oct
bys lname fname: gen n = _N
drop if n > 100 // This is arbitrary (and probably errs on the side of keeping some certification tests)
drop n



** Prep test date vars
gen dui_test_year = year(cdot)
gen dui_test_month = month(cdot)
gen dui_test_day=day(cdot)

rename cdot dui_test_date
rename cage dui_age
gen dui_male = sex=="M" | sex=="m"
	drop sex



** Create variables with earliest and latest possible birthdate
/*
If I'm tested on 2/10/2022 and my age is recorded as 30 years old, on one extreme, I turned 30 that very day, in which case bdate is 2/10/1992. On the other extreme, I turn 31 tomorrow, in which case my bdate is 2/11/1991.
*/
gen dui_bdate_max = mdy(dui_test_month,dui_test_day,dui_test_year-dui_age)
replace dui_bdate_max = mdy(dui_test_month,dui_test_day-1,dui_test_year-dui_age) if dui_bdate_max==. // takes care of leap years
format dui_bdate_max %td

gen dui_bdate_min = mdy(dui_test_month,dui_test_day+1,dui_test_year-dui_age-1)
replace dui_bdate_min = mdy(dui_test_month+1,1,dui_test_year-dui_age-1) if dui_bdate_min==. // takes care of the last day of the month for Jan-November
replace dui_bdate_min = mdy(1,1,dui_test_year-dui_age) if dui_bdate_min==. // takes care of 12/31 stops
format dui_bdate_min %td




***Merge on county FIPS codes
destring cnty, replace force

sort cnty

mmerge cnty using "$raw_dir/breath_test_data/county_key.dta"
**A few small counties had no reported DUI's
drop if _merge==2

drop _merge

rename fips dui_county_fips
rename cnty_name dui_county_name
	replace dui_county_name = upper(dui_county_name)



**Sometimes one person will have multiple tests back-to-back
/*
This seems to relate to retesting when first test result is marked as invalid. When there are multiple tests, 95.3% of first tests are invalid; when there is only one test, 10% are invalid.

Worth noting: Retesting does not appear to be more frequent when the first result is between .07 and .079.
*/
egen dui_incident_id = group(lname fname dui_test_date)

bys dui_incident_id: egen max_vtest = max(vtest)
bys dui_incident_id: egen min_vtest = min(vtest)
gen dui_all_tests_invalid = max_vtest==min_vtest & vtest==0


bys dui_incident_id: egen double dui_highest_result = max(result)
bys dui_incident_id: egen double dui_lowest_result = min(result)

gen temp = result if vtest==1
bys dui_incident_id: egen double dui_highest_vresult = max(temp)
bys dui_incident_id: egen double dui_lowest_vresult = min(temp)
drop temp

* Make var with highest measured BrAC
destring test*, replace force
egen double temp = rowmax(test1 test2)
bys dui_incident_id: egen dui_highest_test = max(temp)
drop temp

sort dui_incident_id time
bys dui_incident_id: gen double dui_first_result = result[1]
bys dui_incident_id: gen dui_first_test = _n==1
bys dui_incident_id: gen dui_first_cnty = cnty[1]
bys dui_incident_id: gen dui_first_cnty_fips = dui_county_fips[1]
bys dui_incident_id: gen dui_first_cnty_name = dui_county_name[1]

bys dui_incident_id: gen double dui_last_result = result[_N]
bys dui_incident_id: gen dui_last_test = _n==_N
bys dui_incident_id: gen dui_last_cnty = cnty[_N]
bys dui_incident_id: gen dui_last_cnty_fips = dui_county_fips[_N]
bys dui_incident_id: gen dui_last_cnty_name = dui_county_name[_N]



* Make sure all the BrAC readings have exactly 3 digits (numeric var formats have given us some trouble)
foreach var in dui_first_result dui_last_result dui_highest_result dui_lowest_result dui_highest_vresult dui_lowest_vresult	{
	
	replace `var' = round(`var',.001)
	
}


** Make rounded BrAC for binning
gen double rounded_lowest_result = floor(dui_lowest_vresult*100)/100


** Make vars for RD
gen index = dui_lowest_vresult - .08
gen above_limit = index>-.0001
gen interact = above_limit*index





***Clean names and construct name variables for merging with other files
rename lname last_name_raw
rename fname first_name_raw
rename mname dui_middle_initial

gen dui_fullname = first_name_raw + " " + dui_middle_initial + " " + last_name_raw
replace dui_fullname = stritrim(dui_fullname)

*Standardize case and remove punctuation + extra spaces
replace last_name_raw=upper(last_name_raw)
replace first_name_raw=upper(first_name_raw)
replace dui_middle_initial=upper(dui_middle_initial)
replace last_name_raw=subinstr(last_name_raw,"-"," ",.)
replace last_name_raw=subinstr(last_name_raw,".","",.)
replace last_name_raw=subinstr(last_name_raw,"  "," ",.)
replace last_name_raw=subinstr(last_name_raw,"'","",.)
replace last_name_raw=subinstr(last_name_raw,"?"," ",.)
replace last_name_raw=subinstr(last_name_raw,"*"," ",.)
replace last_name_raw=trim(last_name_raw)


replace first_name_raw=subinstr(first_name_raw,"-"," ",.)
replace first_name_raw=subinstr(first_name_raw,".","",.)
replace first_name_raw=subinstr(first_name_raw,"  "," ",.)
replace first_name_raw=subinstr(first_name_raw,"'","",.)
replace first_name_raw = trim(first_name_raw)



**Make first name vars (one with first word, one with all words)
split first_name_raw


*Pull out suffixes
gen dui_suffix=""

forvalues i=2/4 {
	replace dui_suffix="JR" if first_name_raw`i'=="JR"
	replace first_name_raw`i'="" if first_name_raw`i'=="JR"
	replace dui_suffix="JR" if first_name_raw`i'=="JR."
	replace first_name_raw`i'="" if first_name_raw`i'=="JR."
	replace dui_suffix="SR" if first_name_raw`i'=="SR"
	replace first_name_raw`i'="" if first_name_raw`i'=="SR"
	replace dui_suffix="II" if first_name_raw`i'=="II"
	replace first_name_raw`i'="" if first_name_raw`i'=="II"
	replace dui_suffix="III" if first_name_raw`i'=="III"
	replace first_name_raw`i'="" if first_name_raw`i'=="III"
	replace dui_suffix="IV" if first_name_raw`i'=="IIII"
	replace first_name_raw`i'="" if first_name_raw`i'=="IIII"
	replace dui_suffix="IV" if first_name_raw`i'=="IV"
	replace first_name_raw`i'="" if first_name_raw`i'=="IV"
	replace dui_suffix="V" if first_name_raw`i'=="V"
	replace first_name_raw`i'="" if first_name_raw`i'=="V"
	replace dui_suffix="VI" if first_name_raw`i'=="VI"
	replace first_name_raw`i'="" if first_name_raw`i'=="VI"
}

gen first_name=first_name_raw1

//gen first_name_second_word = first_name_raw2
gen dui_alt_first_name=first_name_raw1+first_name_raw2+first_name_raw3+first_name_raw4 if first_name_raw2~=""

gen f_first3 = substr(first_name,1,3)


drop first_name_raw*


**Make last name vars
split last_name_raw


*Pull out suffixes
	forval i=2/5 {
		capture replace dui_suffix="JR" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace dui_suffix="II" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace dui_suffix="SR" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace dui_suffix="III" if last_name_raw`i'=="III"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="III"
		capture replace dui_suffix="IV" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII"
		capture replace dui_suffix="V" if last_name_raw`i'=="V"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="V"
		capture replace dui_suffix="VI" if last_name_raw`i'=="VI"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="VI"
		}

**Get last word of name (excluding suffix)
gen temp = last_name_raw
foreach i in JR SR II III IV V VI	{

	replace temp = subinstr(temp," `i'","",.) if dui_suffix=="`i'"
	
}

* For merge with birth indexes
egen name_last_word = ends(temp), last
//gen last_name_2ndtolast_word = word(temp,-2)

drop temp*
	
	
**Finish last name cleaning (combine compound name phrases like "de la" into a single word, but not cases that look like multiple distinct surnames)
*One-word last names		
gen last_name=last_name_raw1 if last_name_raw2==""
gen dui_alt_last_name=""

*Two-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

*Last names that seem to be 2 different surnames
replace dui_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""


*Three-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name_raw4=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

*Three-word names that seem a compound of one two word name and another 1 word name
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

replace last_name=last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")


*Three-word names that seem a compound of 1 one-word name and another two-word name
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")

replace last_name=last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")


*The rest of the three-word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4==""
replace last_name=last_name_raw3 if last_name=="" & last_name_raw4==""


*Four-word names
*Names that include de los or van de
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

replace last_name=last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")


replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

replace last_name=last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

*Names that end with a two-word name like de santis
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")

replace last_name=last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")


*The rest of the 4 word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5==""
replace last_name=last_name_raw4 if last_name=="" & last_name_raw5==""


*Five-word names
*We're just going to work on the last parts of the names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

replace last_name=last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

*Names that end with a 2 word name like de santis
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")

replace last_name=last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")

*The rest of the 5 word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name==""
replace last_name=last_name_raw5 if last_name==""


	
gen l_first3 = substr(last_name,1,3)

drop last_name_raw*


*** Clear out unneeded vars
drop trecno circuit


*** Rename a few vars
rename time dui_test_time
rename zone dui_test_time_zone

foreach var in predict oprl oprf oprm ocert oagency aofficer aagency {
    
	rename `var' dui_`var'
	
}


***Merge on predicted race vars
merge m:1 first_name using "$int_dir/first_name_race"
drop if _m==2
drop _m

merge m:1 last_name using "$int_dir/last_name_race"
drop if _m==2
drop _m


compress

save "$int_dir/texas_breath_tests.dta", replace




** Make a version of the data with one obs per incident
use "$int_dir/texas_breath_tests.dta", clear


keep dui_test_date dui_test_time dui_test_time_zone dui_male dui_age dui_predict dui_test_year dui_test_month dui_test_day dui_bdate_max dui_bdate_min dui_incident_id dui_highest_result dui_lowest_result dui_first_result dui_last_result dui_first_cnty dui_last_cnty dui_first_cnty_fips dui_last_cnty_fips dui_first_cnty_name dui_last_cnty_name dui_fullname dui_middle_initial dui_suffix first_name dui_alt_first_name name_last_word last_name dui_alt_last_name f_* l_* dui_oprl dui_oprf dui_oprm dui_ocert dui_oagency dui_aofficer dui_aagency dui_all_tests_invalid dui_highest_test dui_highest_vresult dui_lowest_vresult

duplicates tag dui_incident_id, gen(dup)

sort dui_incident_id dui_test_time

bys dui_incident_id: drop if dup>0 & _n!=_N
	// Drops 1,301 obs. When we do this, we're keeping the officer information for the last recorded test.

drop dup


* Label vars
label var dui_test_date "Date of breath test"
label var dui_test_time "Time of breath test"
label var dui_test_time_zone "Time zone of breath test"
label var dui_middle_initial "Middle initial of breath tested person (administratively recorded, not constructed)"
label var dui_age "Age of breath tested person (administratively recorded, not constructed)"
label var dui_oprl "Last name of breath test operator"
label var dui_oprf "First initial of breath test operator"
label var dui_oprm "Middle initial of breath test operator"
label var dui_ocert "(?) Certification number of breath test operator"
label var dui_oagency "Agency of breath test operator"
label var dui_aofficer "Name of arresting officer"
label var dui_aagency "Agency of arresting officer"
label var dui_predict "(?) Value entered by operator"
label var dui_test_year "Year of breath test"
label var dui_test_month "Month of breath test"
label var dui_test_day "Day (of month) of breath test"
label var dui_male "Indicator for breath tested person being male"
label var dui_bdate_max "Latest possible birthdate given age at test and date of test"
label var dui_bdate_min "Earliest possible birthdate given age at test and date of test"
label var dui_incident_id "Unique indentifier for breath test encounter"
label var dui_all_tests_invalid "Indicator for all breath tests being flagged as invalid"
label var dui_highest_result "Highest recorded BrAC result (where result is the min of two samples taken within a test)"
label var dui_lowest_result "Lowest recorded BrAC result"
label var dui_highest_vresult "Highest recorded valid BrAC result (where result is the min of two samples taken within a test)"
label var dui_lowest_vresult "Lowest recorded valid BrAC result"
label var dui_highest_test "Highest recorded reading from any test"
label var dui_first_result "First recorded result (where result is the min of two samples taken within a test)"
label var dui_last_result "Last recorded result (where result is the min of two samples taken within a test)"
label var dui_first_cnty "County associated with first recorded result"
label var dui_first_cnty_fips "County FIPS associated with first recorded result"
label var dui_first_cnty_name "County name associated with first recorded result"
label var dui_last_cnty "County associated with last recorded result"
label var dui_last_cnty_fips "County FIPS associated with last recorded result"
label var dui_last_cnty_name "County name associated with last recorded result"
label var dui_fullname "Full name from breath test record"
label var dui_suffix "Suffix from breath test record"
label var first_name "First word of name"
label var dui_alt_first_name "All first name words, without suffixes or spaces"
label var f_first3 "First 3 letters of first name"
label var name_last_word "Last word of name"
label var last_name "Last listed last name, combining compound name and removing suffixes and spaces (e.g. VONLEHM not VON LEHM)"
label var dui_alt_last_name "All last name words, without suffixes or spaces"
label var l_first3 "First 3 letters of last name"
label var f_likely_race "Highest probability race, based on first_name"
label var f_probability_american_indian "Share of people with same first_name who are American Indian"
label var f_probability_asian "Share of people with same first_name who are Asian"
label var f_probability_black "Share of people with same first_name who are Black"
label var f_probability_hispanic "Share of people with same first_name who are Hispanic"
label var f_probability_white "Share of people with same first_name who are White"
label var f_probability_2race "Share of people with same first_name who are multi-racial"
label var l_likely_race "Highest probability race, based on last_name"
label var l_probability_american_indian "Share of people with same last_name who are American Indian"
label var l_probability_asian "Share of people with same last_name who are Asian"
label var l_probability_black "Share of people with same last_name who are Black"
label var l_probability_hispanic "Share of people with same last_name who are Hispanic"
label var l_probability_white "Share of people with same last_name who are White"
label var l_probability_2race "Share of people with same last_name who are multi-racial"


save "$int_dir/texas_breath_tests_uniqueincident", replace




** Now make first-initial datasets for breath tests
use "$int_dir/texas_breath_tests_uniqueincident.dta", clear

foreach var in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z	{
	
	preserve
	gen temp = substr(first_name,1,1)
	keep if temp=="`var'"
	drop temp
	save $int_dir/texas_breath_tests_uniqueincident_`var', replace
	restore
	
}
