clear all
set more off
program drop _all


**Root directory
global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
*global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"

global raw_dir "$root_dir/raw_data/marriage_divorce"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"

use $int_dir/clean_name_marr/marriage_1977

//full_name_raw will be the spouse name from the using when we merge, 
//spouse name will be the fullname from the using when we merge
keep full_name_raw last_name spouse_name
rename spouse_name fullname
rename full_name_raw spouse_name
rename fullname full_name_raw
rename last_name spouse_last_name

replace full_name_raw = trim(full_name_raw)
replace spouse_name = trim(spouse_name)

duplicates drop

merge 1:m spouse_name full_name_raw using $int_dir/clean_name_marr/marriage_1977
