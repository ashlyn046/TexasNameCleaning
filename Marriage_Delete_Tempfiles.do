
clear all
set more off
program drop _all

**Root Directory
global root_dir "/Users/ashlyn04/Box/DUIAshlyn/texas"
*global root_dir "/Users/mukaie/Box/DUIAshlyn/texas"


global raw_dir "$root_dir/raw_data/marriage_divorce"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"

clear 

foreach var in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {
	forvalues i = 1977/2019{
		!erase $int_dir/clean_name_marr/year_first_init/marriage_`i'_`var'
	}
}