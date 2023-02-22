**********************************************************************
/*
INPUT: MARR`##'.txt 					(for years 1977 - 2008, 2011, 2013)
	   marr`##'.txt 					(for years 2009, 2010, 2012)
	   MARRIAGE_INDEX14_RUN07252016.TXT (for year 2014)
	   MARRIAGE20`##'_INDEX.TXT 		(for years 2015-2016)
	   marrage20`##'_index.csv 			(for years 2017-2019)

INTERMEDIARY: N/A
OUTPUT: marriage`####'.dta (for all years 1977-2019)
*/

*This do-file converts marriage indexes for each of the years 1977-2019 into a .dta files in preparation for further cleaning and matching.
*(downloaded from https://www.dshs.texas.gov/vs/marr-div/indexes.aspx in February 2022)
**********************************************************************

clear all
set more off
program drop _all

**Root Directory
*global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"


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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1977.dta", replace

* 1978
clear
import delimited using "$raw_dir/1978/MARR78.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1978.dta", replace

* 1979
clear
import delimited using "$raw_dir/1979/MARR79.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1979.dta", replace

* 1980
clear
import delimited using "$raw_dir/1980/MARR80.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1980.dta", replace

* 1981
clear
import delimited using "$raw_dir/1981/MARR81.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1981.dta", replace

* 1982
clear
import delimited using "$raw_dir/1982/MARR82.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1982.dta", replace

* 1983
clear
import delimited using "$raw_dir/1983/MARR83.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1983.dta", replace

* 1984
clear
import delimited using "$raw_dir/1984/MARR84.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1984.dta", replace

* 1985
clear
import delimited using "$raw_dir/1985/MARR85.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1985.dta", replace

* 1986
clear
import delimited using "$raw_dir/1986/MARR86.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1986.dta", replace

* 1987
clear
import delimited using "$raw_dir/1987/MARR87.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1987.dta", replace

* 1988
clear
import delimited using "$raw_dir/1988/MARR88.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1988.dta", replace

* 1989
clear
import delimited using "$raw_dir/1989/MARR89.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1989.dta", replace

* 1990
clear
import delimited using "$raw_dir/1990/MARR90.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1990.dta", replace

* 1991
clear
import delimited using "$raw_dir/1991/MARR91.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1991.dta", replace

* 1992
clear
import delimited using "$raw_dir/1992/MARR92.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1992.dta", replace

* 1993
clear
import delimited using "$raw_dir/1993/MARR93.txt"
drop if _n==1
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1993.dta", replace

* 1994
clear
import delimited using "$raw_dir/1994/MARR94.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1994.dta", replace

* 1995
clear
import delimited using "$raw_dir/1995/MARR95.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1995.dta", replace

* 1996
clear
import delimited using "$raw_dir/1996/MARR96.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1996.dta", replace

* 1997
clear
import delimited using "$raw_dir/1997/MARR97.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1997.dta", replace

* 1998
clear
import delimited using "$raw_dir/1998/MARR98.txt"
rename (v1 v2 v3 v4 v5 v6 v7) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_county = trim(marr_county)
mmerge marr_county using "$int_dir/tx_county_code"
drop _merge
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1998.dta", replace

* 1999
clear
import delimited using "$raw_dir/1999/MARR99A.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage1999.dta", replace

* 2000
clear
import delimited using "$raw_dir/2000/MARR00.txt"
rename (v1 v2 v3 v4 v5 v6 v7) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
mmerge marr_county using "$int_dir/tx_county_code"
drop _merge
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2000.dta", replace

* 2001
clear
import delimited using "$raw_dir/2001/MARR01.txt"
rename (v1 v2 v3 v4 v5 v6 v7 v8) (marr_filenumber marr_husbandname marr_husbandage marr_wifename marr_wifeage marr_date marr_countycode marr_county)
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2001.dta", replace

*2002
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir/2002/MARR02.txt"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2002.dta", replace

* 2003
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2003\MARR03.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2003.dta", replace

*2004 
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2004\MARR04.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2004.dta", replace

*2005
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2005\MARR05.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2005.dta", replace

*2006
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2006\MARR06.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2006.dta", replace

*2007
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-47 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2007\MARR07.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2007.dta", replace

*2008
clear
infix marr_filenumber 1-8 str marr_husbandname 9-40 marr_husbandage 41-46 str marr_wifename 47-78 marr_wifeage 79-87 str marr_date 88-104 marr_countycode 105-110 str marr_county 111-128 using "$raw_dir\2008\MARR08.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2008.dta", replace

*2009
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2009\marr09.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2009.dta", replace

*2010
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2010\marr10.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2010.dta", replace

*2011
clear
infix marr_filenumber 1-7 str marr_husbandname 8-39 marr_husbandage 40-42 str marr_wifename 43-74 marr_wifeage 75-77 str marr_date 78-88 marr_countycode 89-92 str marr_county 93-107 using "$raw_dir\2011\MARR11.TXT"
destring marr_husbandage, replace force
destring marr_wifeage, replace force
destring marr_filenumber, replace force
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
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
replace marr_husbandname = subinstr(marr_husbandname, ",", " ", .)
replace marr_wifename = subinstr(marr_wifename, ",", " ", .)
save "$int_dir/marriage2019.dta", replace


***************************************
* Appending all years into single file
***************************************
/*forvalues year = 1977/2018 {
	display `year'
	append using "$int_dir/marriage`year'.dta"
}

exit
**************************************************
* Save as new file to be pulled for next .do file
**************************************************
save "$int_dir/combined_marriage_files.dta", replace
*/