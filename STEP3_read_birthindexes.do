/*
NOTES:
- What about ' in names?
- Should we create middle_initial or b_index_middle_initial?
- Need to add loop over all birth index years + append
- Check for dups in terms of name and yob (also look at name first word, name last word,
and yob) - how often do these uniquely ID?
*/

**Root directory--This is all that needs to be changed across users
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas

global raw_dir "$root_dir/raw_data/birth_indexes"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"

clear all
set more off


forval y = 1947/1999	{
	
import excel using "$raw_dir/BIRTH - Summary Data Report_`y'.xlsx", clear first


* There are a few obs with dups in terms of all variables. Could be recording issues or could actually be multiple people with same name, DOB, and county of birth
duplicates drop

*** Prep name vars
gen b_index_fullname = RegistrantName

** Normalize capitalization and punctuation of names
replace b_index_fullname = upper(b_index_fullname)
replace b_index_fullname=subinstr(b_index_fullname,"-"," ",.)
replace b_index_fullname=subinstr(b_index_fullname,".","",.)
replace b_index_fullname=subinstr(b_index_fullname,"*","",.)
replace b_index_fullname=subinstr(b_index_fullname,"  "," ",.)
replace b_index_fullname=subinstr(b_index_fullname,"  "," ",.)
replace b_index_fullname=subinstr(b_index_fullname,"'","",.)
replace b_index_fullname=trim(b_index_fullname)
replace b_index_fullname = stritrim(b_index_fullname)


** Create new variable for suffixes and remove
gen b_index_suffix=""
egen temp = ends(b_index_fullname), last
foreach i in JR SR II III IV V VI	{
    
	replace b_index_suffix = "`i'" if temp=="`i'"
	replace b_index_fullname = subinstr(b_index_fullname," `i'","",.) if b_index_suffix=="`i'"
	
}
drop temp

** Create first word and last word vars
egen first_name = ends(b_index_fullname), head
egen name_last_word = ends(b_index_fullname), last

** Create var for middle name words
gen b_index_name_middle_words = subinstr(b_index_fullname,first_name,"",1)
replace b_index_name_middle_words = subinstr(b_index_name_middle_words,name_last_word,"",.)
replace b_index_name_middle_words = trim(b_index_name_middle_words)

gen b_index_middle_initial = substr(b_index_name_middle_words,1,1)



*** Prep birthdate vars
rename DateofBirth b_index_b_date
gen b_index_b_year = year(b_index_b_date)
gen b_index_b_month = month(b_index_b_date)
gen b_index_b_day = day(b_index_b_date)



*** Clean sex vars
gen b_index_male = SexoftheRegistrant=="MALE"
	replace b_index_male = . if inlist(SexoftheRegistrant,"NULL","UNKNOWN")



*** Rename county and sex
rename CountyofOccurance b_index_county
rename SexoftheRegistrant b_index_sex

drop RegistrantName


*** Label variables
label var b_index_b_date "Date of birth in birth index"
label var b_index_county "County of birth in birth index" 
label var b_index_sex "Sex at birth from birth index"
label var b_index_fullname "Full name from birth index"
label var b_index_suffix "Name suffix from birth index"
label var first_name "First word of name"
label var name_last_word "Last word of name"
label var b_index_name_middle_words "Middle words of name from birth index (everything between first and last word)"
label var b_index_middle_initial "Middle initial from birth index (constructed; first letter of of middle words)"
label var b_index_b_year "Birth year from birth index"
label var b_index_b_month "Birth month from birth index"
label var b_index_b_day "Birth day (of month) from birth index"
label var b_index_b_date "Birth date from birth index"
label var b_index_male "Indicator for male in birth index"

save $int_dir/tx_birth_index_`y', replace

}



*** Make datasets based on first initial.

forval y = 1947/1999	{
	
	use $int_dir/tx_birth_index_`y', clear
	gen temp = substr(first_name,1,1)
	
	foreach i in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z	{
	
		
		preserve
		keep if temp=="`i'"
		drop temp
		compress
		save $int_dir/tx_birth_index_`y'`i', replace
		restore
	
	}
	
}



foreach i in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z	{
	
	clear
	forval y = 1947/1999	{
		
		append using $int_dir/tx_birth_index_`y'`i'
		
		}
	compress
	save $int_dir/tx_birth_index_allyears_`i', replace
	
}
