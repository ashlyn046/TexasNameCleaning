**********************************************************************
/*
INPUT: n/a
INTERMEDIARY: n/a
OUTPUT: tx_county_code.dta
*/
*This file will read in county data and merge it with county codes
**********************************************************************

**Root directory
*global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"

global raw_dir "$root_dir/raw_data/marriage_divorce"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"

**********************
*PHASE 1 : Webscrape
**********************
net install readhtml, from(https://ssc.wisc.edu/sscc/stata/)

//reading in county-fips info from website
readhtmltable https://comptroller.texas.gov/taxes/resources/county-codes.php


**********************
*PHASE 2 : Cleaning
**********************
// dropping unnecessary row
drop in 1

// rename variables
forval i = 1/10{
		rename t`i'c1 county`i'
		rename t`i'c2 code`i'
}

//merge prep: generate id
gen id = _n
reshape long county code, i(id) j(indicator)

//clean up post-reshape
drop id indicator
replace county = upper(county)
replace county = strtrim(county)
replace code = strtrim(code)

//adjust variables to match dataset of other file
rename county marr_county
rename code marr_countycode
replace marr_county = "MC LENNAN" if marr_county == "MCLENNAN"
replace marr_county = "MC CULLOCH" if marr_county == "MCCULLOCH"
replace marr_county = "MC MULLEN" if marr_county == "MCMULLEN"
replace marr_county = "DE WITT" if marr_county == "DEWITT"
replace marr_county = "LA SALLE" if marr_county == "LASALLE"
drop if marr_county ==""

save "$int_dir/tx_county_code", replace
