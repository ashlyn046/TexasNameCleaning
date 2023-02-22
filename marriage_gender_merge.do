/*

INPUT: cleanedNames.csv
	   marriage_wspouse_`A-Z'.dta
	   
INTERMEDIARY: N/A

OUTPUT: marriage_wspouse_`A-Z'.dta

This file merges a gender variable into the cleaned marriage dataset
*/


clear all
set more off
program drop _all


global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
*global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"


global raw_dir "$root_dir/raw_data"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"


//importing names by gender data
import delimited using $root_dir/raw_data/cleanedNames
drop v1 count probability
rename firstname first_name
replace first_name = upper(first_name)
replace first_name = trim(first_name)

save $root_dir/raw_data/cleanedNames, replace

// using is names and genders
//master is marriage data

//merging with each cleaned names marriage file
foreach var in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z{
	display "!!!"
	use $int_dir/clean_name_marr/marriage_wspouse_`var', clear
	gen id = _n
	replace first_name = trim(first_name)
	merge m:1 first_name using $root_dir/raw_data/cleanedNames
	drop if _m==2
	drop _m 
	
	save $int_dir/clean_name_marr/marriage_wspouse_`var', replace
	
	//now we're creating a separate dataset for womem with married names
	drop if gender != "F"
	replace last_name = spouse_last_name
	save $int_dir/clean_name_marr/women_married_names_`var', replace
}

// exit

// preserve
//
// drop if gender != ""
// tempfile mycopy
// //save 'mycopy'
// contract first_name, freq(temp)