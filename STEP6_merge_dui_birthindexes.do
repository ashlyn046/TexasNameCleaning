


**Root directory--This is all that needs to be changed across users

*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:\Users\andersee\Box\DUI\texas

global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"



clear all
set more off



foreach y in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {

	*** Merge breath tests to birth indexes
	use "$int_dir/texas_breath_tests_uniqueincident_`y'.dta", clear


	mmerge first_name name_last_word using $int_dir/tx_birth_index_allyears_`y'

	
	
	*Work with observations that merged
	keep if _merge==3
	drop _merge
	
	**Now let's start pruning bad matches

	**Get rid of matches where the age at stop and voter birthdate aren't compatible
	keep if b_index_b_date < dui_bdate_max & b_index_b_date > dui_bdate_min
	
	
	
	**Compare middle initials
	gen dui_b_index_mimatch = dui_middle_initial==b_index_middle_initial & dui_middle_initial!=""
	gen dui_b_index_minone = dui_middle_initial=="" & b_index_middle_initial==""
	gen dui_b_index_mimismatch = dui_middle_initial!=b_index_middle_initial & dui_middle_initial!="" & b_index_middle_initial!=""
	
	
	*Drop if the middle initials are mismatched (neither missing & they aren't the same)
	drop if dui_b_index_mimismatch
	drop dui_b_index_mimismatch
	
	
	**See how many matches there are before additional pruning
	duplicates tag dui_incident_id, gen(dui_b_index_dup_initial)

		
	*Now drop obs with a missing middle initial when there exists another potential merge with matching middle initials
	egen dui_b_index_num_mimatch = sum(dui_b_index_mimatch), by(dui_incident_id)
	drop if dui_b_index_mimatch==0 & dui_b_index_num_mimatch>0
	
	
	
	*Now drop obs where there is no middle initial in the DUI record, there is one in the birth index, and there exists another potential merge from the birth indexes with no middle initial
	egen dui_b_index_num_minone = sum(dui_b_index_minone), by(dui_incident_id)
	drop if dui_b_index_minone==0 & dui_b_index_num_minone>0
	
	
	**Compare suffixes
	gen dui_b_index_suffix_match = dui_suffix==b_index_suffix & dui_suffix!=""
	
	egen dui_b_index_num_suffix_match = sum(dui_b_index_suffix_match), by(dui_incident_id)
	drop if dui_b_index_suffix_match==0 & dui_b_index_num_suffix_match>0

	
	**Inventory the obs we have left
	duplicates tag dui_incident_id, gen(dui_b_index_dup)
	
	
	**Clean up

	**Add back in incidents that didn't merge
	append using "$int_dir/texas_breath_tests_uniqueincident_`y'.dta"
	gen dui_b_index_no_match = b_index_b_date==.
	bys dui_incident_id: egen temp = min(dui_b_index_no_match)
	drop if dui_b_index_no_match==1 & temp==0
	drop temp
	
	save "$int_dir/dui_b_index_merged_`y'", replace
	
}

	
	
*** Append all first-initial datasets together and see if being above the legal limit affects having a match in the birth indexes
clear

foreach y in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {
    
	append using "$int_dir/dui_b_index_merged_`y'"
	
}


compress

save "$int_dir/dui_b_index_merged_all", replace



