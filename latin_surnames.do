/*
Pulling surname race prediction file to use for merging with the marriage_cleaning_texasv4.do file

INPUT: surnames_race.csv, first_names_race.csv

INTERMEDIARY/OUTPUT: latin_names.dta
*/
clear all
set more off
program drop _all


**Root directory
*global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"


global raw_dir "$root_dir/raw_data/race_prediction"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"

import delimited using "$raw_dir/surnames_race.csv", clear

drop v1

count if likely_race == "hispanic" //11,216

// keep names with that are likely hispanic
keep if likely_race == "hispanic"

keep name
//capitalize names to match the format of the marriage record names
replace name = upper(name)

//removing names that are more often first names
*drop if name == "MARIA" | name == "ANTONIO"

save "$int_dir/latin_names.dta", replace

// use first names file to compare possible first names in surnames file
import delimited using "$raw_dir/first_names_race.csv", clear

//clean data
drop in 1
*keep if likely_race == "hispanic"
keep name
replace name = upper(name)

// merge first and last name files to get rid of names that could be either
merge 1:1 name using "$int_dir/latin_names.dta"
keep if _m == 2 | name == "ALTAGRACIA" | name == "ABELARDO" | name == "CRUZ" | name == "AMADOR" | name == "AMPARO" | name == "BERNABE" | name == "BLAS" | name == "CANDELARIO" | name == "CARIDAD" | name == "CUC" | name == "CONCEPCION" | name == "SANTOS" 
drop _m
// names that we're not sure about but are probably first names
*ALVARO
*BLANCA
*GASPAR
*HILARIO
*ROQUE

// adding observation(s)
local np1 = _N + 1
set obs `np1'

*display _N // now 10993
replace name = "XURUC" in 10993

save "$int_dir/latin_names.dta", replace