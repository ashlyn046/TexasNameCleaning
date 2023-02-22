/*
TO DO:
- Re-download all the raw files. Update file names in cleaning code and rerun to make sure it works.
- Finish cleaning code for divorce records.
- Construct bdate range vars for marriage and divorce records
- Bring in code to match divorces with marriage records
	- Use bdate range to match divorces with marriages
	- Use bdate range to match divorce/marriage records w/ breath test records
- Download the rest of the years of records (1966-1976)
- Format of names changes in 2017 (seems to go last MI first in 2017, then last first fullmiddle after that)

*/

/*
This do-file cleans marriage and divorce indexes (downloaded from https://www.dshs.texas.gov/vs/marr-div/indexes.aspx in February 2022) and matches divorces with marriages.

*/


clear all
set more off
program drop _all



**Root directory
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
*global root_dir C:\Users\andersee\Box\DUI\texas
*global root_dir "C:\Users\jtd44\Box\DUI\texas"
global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
*global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"



global raw_dir "$root_dir/raw_data/marriage_divorce"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"


//USE THIS CODE FOR LOOPING

//forvalues year = 1977/1979{ UNCOMMENT THIS!!!
	//display `year'
	//display "!!!!!"
	//display "!!!!!"
clear 

//bringing in 2019 data to clean
//use $int_dir/marriage`year'.dta
use "$int_dir/marriage2019.dta"


*RESHAPING to change unit of obs to individual
*******************

//generating new variables to prepare for reshaping
gen fullname1 = marr_husbandname
gen fullname2 = marr_wifename
gen age1 = marr_husbandage
gen age2 = marr_wifeage
gen marr_filenum1 = marr_filenumber
gen marr_filenum2 = marr_filenumber
gen marr_date1 = marr_date
gen marr_date2 = marr_date
gen marr_county1 = marr_county
gen marr_county2 = marr_county
gen marr_countycode1 = marr_countycode
gen marr_countycode2 = marr_countycode
drop marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_county marr_countycode

//generating an id for reshaping
gen id = _n

//reshaping the data so that each individual is an observation rather than each marriage being an observation
reshape long fullname age marr_date marr_county marr_countycode marr_filenum, i(id) j(spousenum)

*******************


*NAME CLEANING
******************

**Normalize capitilization and punctuation of names
replace fullname=upper(fullname)
replace fullname=subinstr(fullname,"-"," ",.)
replace fullname=subinstr(fullname,".","",.)
replace fullname=subinstr(fullname,"  "," ",.)
replace fullname=subinstr(fullname,"'","",.)
replace fullname=subinstr(fullname,"?"," ",.)
replace fullname=subinstr(fullname,"*"," ",.)
replace fullname=trim(fullname)

*split fullname to create other varibles

//This will get the number names by taking the number of spaces plus 1
gen num_split_temp = length(fullname) - length(subinstr(fullname, " ", "", .)) + 1
egen num_split = max(num_split_temp)
recast int num_split

split fullname, parse(" ") gen(fnsplit)


**Pull out suffixes
gen suffix=""

//Here, we declare a local variable equal to the number of names so that we can loop on that
local n = num_split[1]
forvalues i=1/`n'{
	replace suffix="JR" if fnsplit`i'=="JR"
	replace fnsplit`i'="" if fnsplit`i'=="JR"
	replace suffix="JR" if fnsplit`i'=="JR."
	replace fnsplit`i'="" if fnsplit`i'=="JR."
	replace suffix="SR" if fnsplit`i'=="SR"
	replace fnsplit`i'="" if fnsplit`i'=="SR"
	replace suffix="SR" if fnsplit`i'=="SR."
	replace fnsplit`i'="" if fnsplit`i'=="SR."
	replace suffix="JR" if fnsplit`i'=="II"
	replace fnsplit`i'="" if fnsplit`i'=="II"
	replace suffix="III" if fnsplit`i'=="III"
	replace fnsplit`i'="" if fnsplit`i'=="III"
	replace suffix="IV" if fnsplit`i'=="IIII"
	replace fnsplit`i'="" if fnsplit`i'=="IIII"
	replace suffix="IV" if fnsplit`i'=="IV"
	replace fnsplit`i'="" if fnsplit`i'=="IV"
	//replace suffix="V" if fnsplit`i'=="V"
	//replace fnsplit`i'="" if fnsplit`i'=="V"
	//replace suffix="VI" if fnsplit`i'=="VI"
	//replace fnsplit`i'="" if fnsplit`i'=="VI"
}
//we checked, and there aren't any suffixes other than jr and sr
*clean fullname variable


** Here, we take the suffixes out of fullname
**putting names back together (leading and lagging empty values will be caught by trim afterwards and we assume at most only 1 fnsplit could have been made empty by the suffix loop)

//generating fnsplit variables for years that don't have them so that the following code will run

forvalues i = `n'/8{
	local j = `i' + 1
	if `j' <= 8{
		gen fnsplit`j' = ""
	}
}

* case 1: fnsplit* are nonempty
replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if suffix == ""

* case 2: if fnsplit2 was made empty by the suffix loop
replace fullname = fnsplit1 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if (suffix ~= "" & fnsplit2 == "")

* case 3: if fnsplit3 was made empty by the suffix loop
replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if (suffix ~= "" & fnsplit3 == "")

*etc.
replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if (suffix ~= "" & fnsplit4 == "")

replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if (suffix ~= "" & fnsplit5 == "")

replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit7 + " " + fnsplit8 if (suffix ~= "" & fnsplit6 == "")

replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit8 if (suffix ~= "" & fnsplit7 == "")


replace fullname = trim(fullname)
drop fnsplit* num_split_temp num_split

//condensing compound last names

//creating a local var for the number of names
gen num_split_temp = length(fullname) - length(subinstr(fullname, " ", "", .)) + 1
egen num_split = max(num_split_temp)
recast int num_split
local m = num_split[1] //see local variable m in read me
local k = `m'-1
//local k should be equal to the number of names MINUS 1

split fullname, parse(" ") gen(fnsplit)

//loop to condense two part last and middle names
gen ind = 0
gen ind2 = 0 // we generated this one so that if someone's name is of the form de la rosa, the la won't get caught by ind 1 to become de la-ros
forvalues i = 1/`k'{
	replace ind = 0
	local j = `i' + 1
	
	replace ind = 1 if ((fnsplit`i'=="DOS" | fnsplit`i' + fnsplit`j'=="DANDREA" |  fnsplit`i' + fnsplit`j'=="DANDRE" | fnsplit`i' + fnsplit`j'=="DANN" | fnsplit`i'=="DE" | fnsplit`i'=="DEL" | fnsplit`i'=="DELLA" | fnsplit`i'=="DELA" | fnsplit`i'=="DA" | fnsplit`i'=="VAN" | fnsplit`i'=="VON" | fnsplit`i'=="VOM" | fnsplit`i'=="SAINT" | fnsplit`i'=="ST" | fnsplit`i'=="SANTA" | fnsplit`i'=="AL" | fnsplit`i'=="BEN" | fnsplit`i'=="DI" | fnsplit`i'=="EL" | fnsplit`i'=="LA" | fnsplit`i'=="LE" | fnsplit`i'=="MC" | fnsplit`i'=="MAC" | fnsplit`i'=="SAN" | fnsplit`i' + fnsplit`j' =="OCONNOR" | fnsplit`i' + fnsplit`j'== "OBRYAN" | fnsplit`i' + fnsplit`j' =="OBRIEN" | fnsplit`i' + fnsplit`j'=="OBRYANT" | fnsplit`i' + fnsplit`j'=="ONEAL" | fnsplit`i' + fnsplit`j'=="ODONNEL" | fnsplit`i' + fnsplit`j'=="OSULLIVAN" | fnsplit`i' + fnsplit`j'=="OREILLY" | fnsplit`i' + fnsplit`j'=="OLEARY") & fnsplit`j'~= "") & (fnsplit`j' ~= "LA" & fnsplit`j' ~= "LAS" & fnsplit`j' ~= "LOS" & fnsplit`j' ~= "DE" & fnsplit`j' ~= "DER") & ind2~=2
	
replace ind2 = 0
	replace ind2 = 2 if (fnsplit`i'+fnsplit`j'=="DELA" | fnsplit`i'+fnsplit`j'=="DELOS" | fnsplit`i'+fnsplit`j'=="DELAS"  | fnsplit`i'+fnsplit`j'=="VANDE" | fnsplit`i'+fnsplit`j'=="VANDER") //we need this case so the ones that are de la get overridden
	
	replace fnsplit`i' = fnsplit`i' + fnsplit`j' if ind == 1
	
	forvalues `k' = `j'/`k'{
		local l = `k' + 1
		replace fnsplit`k' = fnsplit`l' if ind == 1
	}
	//replace fnsplit8 = "" if ind == 1
}

//loop to condense three part last and middle names
local h = `k'-1
forvalue i = 1/`h'{
	replace ind = 0 
	local j = `i' + 1
	local l = `j' + 1
	
	replace ind = 2 if (fnsplit`i'+fnsplit`j'=="DELA" | fnsplit`i'+fnsplit`j'=="DELOS" | fnsplit`i'+fnsplit`j'=="DELAS"  | fnsplit`i'+fnsplit`j'=="VANDE" | fnsplit`i'+fnsplit`j'=="VANDER")
	
	replace fnsplit`i' = fnsplit`i' + fnsplit`j' + fnsplit`l' if ind ==2
	
	forvalues q = `j'/`h'{
		local p = `q' + 2
		replace fnsplit`q' = fnsplit`p' if ind == 2
	}
	replace fnsplit`k' = "" if ind == 2
	replace fnsplit`m' = "" if ind == 2
}


//updating fullname variable
replace fullname = ""
forvalues i = 1/`m'{
	replace fullname = fullname + " " + fnsplit`i' + " "
}
replace fullname = trim(fullname)
drop fnsplit*


//FINAL NAME CLEANING
split fullname
gen middle = ""

//generating an extra fullname variable so that this code runs
local r = `m' + 1
gen fullname`r' = ""

//CASES 1: 2-WORD NAMES (LAST FIRST)
capture gen lastname=fullname1 if fullname3==""
capture gen firstname=fullname2 if fullname3==""

//CASE 2: 3-WORD NAMES (baseline assumption: LAST FIRST MIDDLE)
capture replace lastname=fullname1 if fullname4=="" & lastname==""
capture replace firstname=fullname2 if fullname4=="" & firstname==""
capture replace middle= fullname3 if fullname4=="" & fullname3~=""

//CASE 3: 4-WORD NAMES (baseline assumption: LAST LAST FIRST MIDDLE)
capture replace lastname = fullname2 if fullname5=="" & fullname4~=""
capture gen altlastname = fullname1 + " " + fullname2 if fullname5=="" & fullname4~=""
capture replace firstname = fullname3 if fullname5=="" & fullname4~=""
capture replace middle = fullname4 if fullname5=="" & fullname4~=""

//CASE 4: 5-WORD NAMES (baseline assumption: LAST LAST FIRST MIDDLE MIDDLE)
capture replace lastname = fullname2 if fullname6=="" & fullname5~=""
capture replace altlastname = fullname1 + " " + fullname2 if fullname6=="" & fullname5~=""
capture replace firstname = fullname3 if fullname6=="" & fullname5~=""
capture replace middle = fullname4 + " " + fullname5 if fullname6=="" & fullname5~=""

//CASE 5: 6-WORD NAMES (there are only 3 of these, but we assume the form: LAST FIRST MIDDLE MIDDLE MIDDLE MIDDLE)
capture replace lastname = fullname1 if fullname6~="" & fullname7 == ""
capture replace firstname = fullname2 if fullname6~="" & fullname7 == ""
capture replace middle = fullname3 + " " + fullname4 + " " + fullname5 + " " + fullname6 if fullname6~="" & fullname7 == ""

rename fullname full_name
drop fullname*
rename full_name fullname

save $int_dir/int_name_marr/marriage_`year', replace

//Many Latin names were ordered incorrectly by our code. Below, we attempt to fix this
import delimited using "$int_dir/first_name_race"



exit


//Split marr_date into month day years
gen year = `year'
rename marr_date marr_date_raw

//generating two mariage dates for the possible formattings of our date variable
gen marr_date1 = date(marr_date_raw, "MDY")
gen marr_date2 = date(marr_date_raw, "YMD")

//generating new variables to determine if they are missing
misstable summarize marr_date1 marr_date2, generate(missing)
count if missingmarr_date1 == 1
local f = r(N)

count if missingmarr_date2 == 1
local g = r(N)

//replacing marr_date with whichever option had the least missing values
gen marr_date = .
replace marr_date = marr_date1 if `f'<`g'
replace marr_date = marr_date2 if `g'<`f'

drop marr_date_raw marr_date1 marr_date2 missingmarr_date1 missingmarr_date2
gen marr_day = day(marr_date)
gen marr_month = month(marr_date)
gen marr_year = year(marr_date)

*** Prep birthdate vars
gen bdate_max = mdy(marr_month,marr_day,marr_year-age)
replace bdate_max = mdy(marr_month,marr_day-1,marr_year-age) if bdate_max==. // takes care of leap years
format bdate_max %td

gen bdate_min = mdy(marr_month,marr_day+1,marr_year-age-1)
replace bdate_min = mdy(marr_month+1,1,marr_year-age-1) if bdate_min==. // takes care of the last day of the month for Jan-November
replace bdate_min = mdy(1,1,marr_year-age) if bdate_min==. // takes care of 12/31 stops
format bdate_min %td

drop id ind ind2 marr_day marr_month marr_year

//lable variables 
label var spousenum "This variable comes from our reshape, and determines whether the given person was listed as the primary or secondary spouse in the original records"
label var age "The age of the individual"
label var marr_filenum "The file number of the marriage (there will be two individuals for each marriage filenum)"
label var marr_county "The county where the marriage took place"
label var marr_countycode "The county code for the county where the marriage took place"
label var suffix "The individuals suffix (if applicable)"
label var middle "The individual's middle name"
label var lastname "The individual's last last name"
label var firstname "The individual's first name"
label var altlastname "A combination of all of the last names of an individual"
label var marr_date "The date of the marriage"
label var bdate_max "The latest possible birthday of an individual"
label var bdate_min "The earliest possible birthday of an individual"
label var num_split "The maximum number of words in the current fullname variables"

save $int_dir/clean_name_marr/marriage_`year', replace

exit
//Now make first-inital datasets for each marriage years
use $int_dir/clean_name_marr/marriage_`year', clear

foreach var in A B /*C D E F G H I J K L M N O P Q R S T U V W X Y Z*/{
	preserve
	gen temp = substr(firstname,1,1)
	keep if temp == "`var'"
	drop temp
	save marriage_`year'_`var', replace
	restore
}

//} UNCOMMENT THIS, IT JUST TAKES US OUT OF THE LOOP
exit


**append each letter initial file across all years and storing intermediary files to the local device so that we can delete them below
foreach var in A B /*C D E F G H I J K L M N O P Q R S T U V W X Y Z*/{
	use marriage_1977_`var', clear
	forvalues i = 1978/1979{
		append using marriage_`i'_`var'
	}
	save $int_dir/clean_name_marr/marriage_`var', replace
}


clear 

//Deleting all letter by year files that we created
foreach var in A B /*C D E F G H I J K L M N O P Q R S T U V W X Y Z */{
	forvalues i = 1977/1979{
		erase marriage_`i'_`var'.dta
	}
}