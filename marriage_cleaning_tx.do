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



clear 

************************
*** MARRIAGE RECORDS ***
************************
* 1977
clear
import delimited using "$raw_dir/1977/MARR77.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1977.dta", replace

* 1978
clear
import delimited using "$raw_dir/1978/MARR78.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1978.dta", replace

* 1979
clear
import delimited using "$raw_dir/1979/MARR79.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1979.dta", replace

* 1980
clear
import delimited using "$raw_dir/1980/MARR80.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1980.dta", replace

* 1981
clear
import delimited using "$raw_dir/1981/MARR81.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1981.dta", replace

* 1982
clear
import delimited using "$raw_dir/1982/MARR82.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1982.dta", replace

* 1983
clear
import delimited using "$raw_dir/1983/MARR83.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1983.dta", replace

* 1984
clear
import delimited using "$raw_dir/1984/MARR84.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1984.dta", replace

* 1985
clear
import delimited using "$raw_dir/1985/MARR85.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1985.dta", replace

* 1986
clear
import delimited using "$raw_dir/1986/MARR86.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1986.dta", replace

* 1987
clear
import delimited using "$raw_dir/1987/MARR87.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1987.dta", replace

* 1988
clear
import delimited using "$raw_dir/1988/MARR88.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1988.dta", replace

* 1989
clear
import delimited using "$raw_dir/1989/MARR89.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1989.dta", replace

* 1990
clear
import delimited using "$raw_dir/1990/MARR90.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1990.dta", replace

* 1991
clear
import delimited using "$raw_dir/1991/MARR91.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1991.dta", replace

* 1992
clear
import delimited using "$raw_dir/1992/MARR92.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1992.dta", replace

* 1993
clear
import delimited using "$raw_dir/1993/MARR93.txt"
drop if _n==1
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1993.dta", replace

* 1994
clear
import delimited using "$raw_dir/1994/MARR94.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1994.dta", replace

* 1995
clear
import delimited using "$raw_dir/1995/MARR95.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1995.dta", replace

* 1996
clear
import delimited using "$raw_dir/1996/MARR96.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1996.dta", replace

* 1997
clear
import delimited using "$raw_dir/1997/MARR97.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1997.dta", replace

* 1998
clear
import delimited using "$raw_dir/1998/MARR98.txt"
rename (v1 v2 v3 v4 v5 v6 v7) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1998.dta", replace

* 1999
clear
import delimited using "$raw_dir/1999/MARR99A.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage1999.dta", replace

* 2000
clear
import delimited using "$raw_dir/2000/MARR00.txt"
rename (v1 v2 v3 v4 v5 v6 v7) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2000.dta", replace

* 2001
clear
import delimited using "$raw_dir/2001/MARR01.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2001.dta", replace

*2002
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir/2002/MARR02.txt"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2002.dta", replace

* 2003
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2003\MARR03.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2003.dta", replace

*2004 
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2004\MARR04.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2004.dta", replace

*2005
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2005\MARR05.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2005.dta", replace

*2006
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2006\MARR06.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2006.dta", replace

*2007
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2007\MARR07.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2007.dta", replace

*2008
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-46 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2008\MARR08.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2008.dta", replace

*2009
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2009\marr09.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2009.dta", replace

*2010
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2010\marr10.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2010.dta", replace

*2011
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2011\MARR11.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2011.dta", replace

*2012
clear
import delimited using "$raw_dir\2012\marr12.TXT"
drop if _n==1
split v1, parse(`"""')
rename v11 marr_filenumber
rename v12 marr_husbandname
rename v13 marr_husbandage
rename v14 marr_wifename
split v15, p(" ")
rename v151 marr_wifeage
rename v152 marr_date
rename v153 marr_countycode
gen marr_county = v154
	replace marr_county = v16 if v154==""
drop v1 v15 v16 v154
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2012.dta", replace

*2013
clear
import delimited using "$raw_dir\2013\MARR2013.TXT"
drop if _n==1
split v1, parse(`"""')
rename v11 marr_filenumber
rename v12 marr_husbandname
rename v13 marr_husbandage
rename v14 marr_wifename
split v15, p(" ")
rename v151 marr_wifeage
rename v152 marr_date
rename v153 marr_countycode
gen marr_county = v154
	replace marr_county = v16 if v154==""
drop v1 v15 v16 v154
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2013.dta", replace

*2014
clear
import delimited using "$raw_dir\2014\MARRIAGE_INDEX14_RUN07252016.TXT"
drop if _n==1
split v1, parse(`"""')
rename v11 marr_filenumber
rename v12 marr_husbandname
rename v13 marr_husbandage
rename v14 marr_wifename
split v15, p(" ")
rename v151 marr_wifeage
rename v152 marr_date
rename v153 marr_countycode
gen marr_county = v154
	replace marr_county = v16 if v154==""
drop v1 v15 v16 v154
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2014.dta", replace

*2015
clear
import delimited using "$raw_dir\2015\MARRIAGE2015_INDEX.TXT", delim("*")
rename filenumber marr_filenumber
rename husbandsname marr_husbandname
rename husbandsage marr_husbandage
rename wifesname marr_wifename
rename wifesage marr_wifeage
rename marriagedate marr_date
rename countycodewhere marr_countycode
rename countynamewhere marr_county
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2015.dta", replace

*2016
clear
import delimited using "$raw_dir\2016\MARRIAGE2016_INDEX.TXT", delim("*")
rename filenumber marr_filenumber
rename husbandsname marr_husbandname
rename husbandsage marr_husbandage
rename wifesname marr_wifename
rename wifesage marr_wifeage
rename marriagedate marr_date
rename countycodewhere marr_countycode
rename countynamewhere marr_county
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
drop _break_
save "$int_dir/marriage2016.dta", replace

*2017
clear
import delimited using "$raw_dir\2017\marrage2017_index.csv"
rename sfn marr_filenumber
rename husb_name marr_husbandname
rename husb_age marr_husbandage
rename wife_name marr_wifename
rename wife_age marr_wifeage
rename md_date marr_date
rename clocalcode marr_countycode
rename county_name marr_county
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2017.dta", replace

*2018
clear
import delimited using "$raw_dir\2018\marrage2018_index.csv"
rename sfn marr_filenumber
rename husb_name marr_husbandname
rename husb_age marr_husbandage
rename wife_name marr_wifename
rename wife_age marr_wifeage
rename md_date marr_date
rename clocalcode marr_countycode
rename county_name marr_county
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2018.dta", replace

*2019
clear
import delimited using "$raw_dir\2019\marrage2019_index.csv"
rename sfn marr_filenumber
rename husb_name marr_husbandname
rename husb_age marr_husbandage
rename wife_name marr_wifename
rename wife_age marr_wifeage
rename md_date marr_date
rename clocalcode marr_countycode
rename county_name marr_county
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
save "$int_dir/marriage2019.dta", replace

/* USE THIS CODE FOR LOOPING
forvalues year = 1977/2019 {
	display `year'
	
}

*/
clear 

//bringing in 2019 data to clean
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
split fullname, parse(" ") gen(fnsplit)
//rename fnsplit1 last_name_raw //This would just grab "de" if the name was compound
//rename def_nam2 first_name_raw

//we can't do this because we don't have a comma so we don't know what are first names and what are parts of first names
**Make first name vars (one with first word, one with all words)
//split first_name_raw


**Pull out suffixes
gen suffix=""

forvalues i=1/8 {
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

drop fnsplit*

//condensing compound last names
split fullname, parse(" ") gen(fnsplit)

*clean last name variables
gen last_name = ""

*generating a variable to tell how many words are in the last name 
gen numwordsln = 1

*Two-word last names
*Take care of compound names
replace numwordsln = 2 if (fnsplit1=="DOS" | fnsplit1=="D" | fnsplit1=="DE" | fnsplit1=="DEL" | fnsplit1=="DELLA" | fnsplit1=="DELA" | fnsplit1=="DA" | fnsplit1=="VAN" | fnsplit1=="VON" | fnsplit1=="VOM" | fnsplit1=="SAINT" | fnsplit1=="ST" | fnsplit1=="SANTA" | fnsplit1=="A" | fnsplit1=="AL" | fnsplit1=="BEN" | fnsplit1=="DI" | fnsplit1=="EL" | fnsplit1=="LA" | fnsplit1=="LE" | fnsplit1=="MC" | fnsplit1=="MAC" | fnsplit1=="O" | fnsplit1=="SAN")

replace last_name = fnsplit1 + "-" + fnsplit2 if numwordsln == 2
replace fullname = last_name + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 2

*Three-word last names
*Take care of compound names
replace numwordsln = 3 if (fnsplit1+fnsplit2=="DELA" | fnsplit1+fnsplit2=="DELOS" | fnsplit1+fnsplit2=="DELAS"  | fnsplit1+fnsplit2=="VANDE" | fnsplit1+fnsplit2=="VANDER")

replace last_name = fnsplit1 + "-" + fnsplit2 + "-" + fnsplit3 if numwordsln ==3
replace fullname = last_name + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 3

//take care of compound middle/last names
//we set numwordsln = 200 to differentiate between the case of two words last names
replace numwordsln = 200 if ((fnsplit2=="DOS" | fnsplit2=="DE" | fnsplit2=="DEL" | fnsplit2=="DELLA" | fnsplit2=="DELA" | fnsplit2=="DA" | fnsplit2=="VAN" | fnsplit2=="VON" | fnsplit2=="VOM" | fnsplit2=="SAINT" | fnsplit2=="ST" | fnsplit2=="SANTA" | fnsplit2=="AL" | fnsplit2=="DI" | fnsplit2=="EL" | fnsplit2=="LA" | fnsplit2=="LE" | fnsplit2=="MC" | fnsplit2=="MAC" | fnsplit2=="O" | fnsplit2=="SAN") & numwordsln == 1 & fnsplit4 ~="")

replace last_name = fnsplit2 + "-" + fnsplit3 if numwordsln == 200
replace fullname = fnsplit1 + " " + last_name + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 200


*Three-word last names
*Take care of compound three word midle/last names
replace numwordsln = 300 if ((fnsplit2+fnsplit3=="DELA" | fnsplit2+fnsplit3=="DELOS" | fnsplit2+fnsplit3=="DELAS"  | fnsplit2+fnsplit3=="VANDE" | fnsplit2+fnsplit3=="VANDER") & fnsplit5 ~="")

replace last_name = fnsplit2 + "-" + fnsplit3 + "-" + fnsplit4 if numwordsln ==300
replace fullname = fnsplit1 + " " + last_name + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 300


gen middle = ""

//fixing middle names with two words
gen numwordsmn = 0
replace numwordsmn = 2 if ((fnsplit4=="DOS" | fnsplit4=="DE" | fnsplit4=="DEL" | fnsplit4=="DELLA" | fnsplit4=="DELA" | fnsplit4=="DA" | fnsplit4=="VAN" | fnsplit4=="VON" | fnsplit4=="VOM" | fnsplit4=="SAINT" | fnsplit4=="ST" | fnsplit4=="SANTA" | fnsplit4=="AL" | fnsplit4=="DI" | fnsplit4=="EL" | fnsplit4=="LA" | fnsplit4=="LE" | fnsplit4=="MC" | fnsplit4=="MAC" | fnsplit4=="O" | fnsplit4=="SAN") & fnsplit5 ~="" & fnsplit6=="")

replace middle = fnsplit4 + "-" + fnsplit5 if numwordsmn == 2
replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + middle if numwordsmn == 2

*Three-word middle names
*Take care of compound three word midle/last names
replace numwordsmn = 3 if ((fnsplit3+fnsplit4=="DELA" | fnsplit3+fnsplit4=="DELOS" | fnsplit3+fnsplit4=="DELAS"  | fnsplit3+fnsplit4=="VANDE" | fnsplit3+fnsplit4=="VANDER") & fnsplit5 ~=""  & fnsplit6=="")

replace middle = fnsplit3 + "-" + fnsplit4 + "-" + fnsplit5 if numwordsmn ==3
replace fullname = fnsplit1 + " " + fnsplit2 + " " + middle if numwordsmn == 3


drop numwordsmn



replace fullname = trim(fullname)

drop fnsplit*
drop last_name
drop numwordsln


split fullname

//LOOKING AT THE DISTRIBUTION
gen numnames = 0

forvalues i = 1/8{
	replace numnames = `i' if fullname`i'!=""
}

hist numnames

forvalues i =1/8{
	count if numnames == `i'
}

/*

  20
  34,301
  213,283
  26,729
  621
  187
  11
  1

*/


//CASES 1: 2-WORD NAMES (LAST FIRST)
gen lastname=fullname1 if fullname3==""
gen firstname=fullname2 if fullname3==""

//CASE 2: 3-WORD NAMES (baseline assumption: LAST FIRST MIDDLE)
replace lastname=fullname1 if fullname4=="" & lastname==""
replace firstname=fullname2 if fullname4=="" & firstname==""
replace middle= fullname3 if fullname4=="" & fullname3~=""

//CASE 3: 4-WORD NAMES (baseline assumption: LAST LAST FIRST MIDDLE)
replace lastname = fullname2 if fullname5=="" & fullname4~=""
gen altlastname = fullname1 + " " + fullname2 if fullname5=="" & fullname4~=""
replace firstname = fullname3 if fullname5=="" & fullname4~=""
replace middle = fullname4 if fullname5=="" & fullname4~=""

//CASE 4: 5-WORD NAMES ()


//there are a large number of cases of the form lname lname "de jesus" fname. here, we fix those
gen numwords = 0
replace numwords = 2 if ((fullname3=="DOS" | fullname3=="DE" | fullname3=="DEL" | fullname3=="DELLA" | fullname3=="DELA" | fullname3=="DA" | fullname3=="VAN" | fullname3=="VON" | fullname3=="VOM" | fullname3=="SAINT" | fullname3=="ST" | fullname3=="SANTA" | fullname3=="AL" | fullname3=="DI" | fullname3=="EL" | fullname3=="LA" | fullname3=="LE" | fullname3=="MC" | fullname3=="MAC" | fullname3=="O" | fullname3=="SAN") & fullname5 ~="" & fullname6=="")

replace lastname = fullname3 + "-" + fullname4 if numwords == 2
replace fullname = fullname1 + " " + fullname2 + " " + lastname + " " + fullname5 if numwords == 2

replace firstname = fullname5 if numwords == 2
replace altlastname = fullname1 + " " + fullname2 + " " + lastname if numwords == 2

replace fullname3 = lastname if numwords == 2
replace fullname4 = fullname5 if numwords == 2
replace fullname5 = "" if numwords == 2


//NOW we clean the rest of the 5-word names //now we only have 444
//we are assuming the form L L F M M
replace lastname = fullname2 if fullname5 ~="" & fullname6==""
replace altlastname = fullname1 + " " + fullname2 if fullname5 ~="" & fullname6==""
replace firstname = fullname3 if fullname5 ~="" & fullname6==""
replace middle = fullname4 + "-" + fullname5 if fullname5 ~="" & fullname6==""


exit


*clean last name variables
gen last_name = ""

*generating a variable to tell how many words are in the last name 
gen numwordsln = 1

*Two-word last names
*Take care of compound names
replace numwordsln = 2 if (fnsplit1=="DOS" | fnsplit1=="D" | fnsplit1=="DE" | fnsplit1=="DEL" | fnsplit1=="DELLA" | fnsplit1=="DELA" | fnsplit1=="DA" | fnsplit1=="VAN" | fnsplit1=="VON" | fnsplit1=="VOM" | fnsplit1=="SAINT" | fnsplit1=="ST" | fnsplit1=="SANTA" | fnsplit1=="A" | fnsplit1=="AL" | fnsplit1=="BEN" | fnsplit1=="DI" | fnsplit1=="EL" | fnsplit1=="LA" | fnsplit1=="LE" | fnsplit1=="MC" | fnsplit1=="MAC" | fnsplit1=="O" | fnsplit1=="SAN")

replace last_name = fnsplit1 + "-" + fnsplit2 if numwordsln == 2
replace fullname = last_name + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 2

*Three-word last names
*Take care of compound names
replace numwordsln = 3 if (fnsplit1+fnsplit2=="DELA" | fnsplit1+fnsplit2=="DELOS" | fnsplit1+fnsplit2=="DELAS"  | fnsplit1+fnsplit2=="VANDE" | fnsplit1+fnsplit2=="VANDER")

replace last_name = fnsplit1 + "-" + fnsplit2 + "-" + fnsplit3 if numwordsln ==3
replace fullname = last_name + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8 if numwordsln == 3


exit
//ENDED HERE !

//DO SOMETHING ABOUT THIS
*Last names that seem to be 2 different surnames
replace court_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""

exit


gen first_name=first_name_raw1
gen f_first3 = substr(first_name,1,3)

**The alt_first_name is everything but the suffix
gen court_alt_first_name=first_name_raw1+first_name_raw2+first_name_raw3+first_name_raw4 if first_name_raw2~=""

**I pull a possible middle initial from the first character of the second word in the first name
gen court_middle_initial =substr(first_name_raw2,1,1)


drop first_name_raw*


**Make last name vars
split last_name_raw


**Finish last name cleaning (combine last name phrases like "de la" into a single word, but not cases that look like multiple distinct surnames)	
*One-word last names		
gen last_name=last_name_raw1 if last_name_raw2==""
gen court_alt_last_name=""

*Two-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

*Last names that seem to be 2 different surnames
replace court_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""


*Three-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name_raw4=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

*Three-word names that seem a compound of one two word name and another 1 word name
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

replace last_name=last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")


*Three-word names that seem a compound of 1 one-word name and another two-word name
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")

replace last_name=last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")


*The rest of the three-word names
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4==""
replace last_name=last_name_raw3 if last_name=="" & last_name_raw4==""


*Four-word names
*Names that include de los or van de
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

replace last_name=last_name_raw4 if last_name=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")


replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

replace last_name=last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""  & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

*Names that end with a two-word name like de santis
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""  & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")

replace last_name=last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")


*The rest of the 4 word names
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""
replace last_name=last_name_raw4 if last_name==""


gen l_first3 = substr(last_name,1,3)

drop last_name_raw*



///OLD CODE

** Normalize capitalization and punctuation of names
replace fullname = upper(fullname)
replace fullname=subinstr(fullname,"-"," ",.)
replace fullname=subinstr(fullname,".","",.)
replace fullname=subinstr(fullname,"*","",.)
replace fullname=subinstr(fullname,"  "," ",.)
replace fullname=subinstr(fullname,"  "," ",.)
replace fullname=subinstr(fullname,"'","",.)
replace fullname=trim(fullname)
replace fullname = stritrim(fullname)


** Create new variable for suffixes and remove
split fullname, parse(" ") gen(fnsplit)

gen suffix=""

forvalues i=1/8 {
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


/* SUFFIX CODE FROM duivoterbirthhc. It dodn't work becuase our data was not as clean
gen suffix=""
gen fullnameog = fullname
egen temp = ends(fullname), last
foreach i in JR SR II III IV V VI	{
    
	replace suffix = "`i'" if temp=="`i'"
	replace fullname = subinstr(fullname," `i'","",.) if suffix=="`i'"
	
}
drop temp
*/

** Here, we take the suffixes out of fullname
replace fullname = fnsplit1 + " " + fnsplit2 + " " + fnsplit3 + " " + fnsplit4 + " " + fnsplit5 + " " + fnsplit6 + " " + fnsplit7 + " " + fnsplit8

replace fullname = trim(fullname)

** Create first word and last word vars
egen last_name = ends(fullname), head
egen name_last_word = ends(fullname), last // ideally, this is mname

** Create var for the words in the middle of the name
gen name_middle_words = subinstr(fullname, last_name,"",1)
replace name_middle_words = subinstr(name_middle_words,name_last_word,"",.)
replace name_middle_words = trim(name_middle_words)

gen b_index_middle_initial = substr(b_index_name_middle_words,1,1)

******************



*** Prep birthdate vars
rename DateofBirth b_index_b_date
gen b_index_b_year = year(b_index_b_date)
gen b_index_b_month = month(b_index_b_date)
gen b_index_b_day = day(b_index_b_date)
