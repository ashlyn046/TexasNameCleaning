************************************************************
**This file will merge in data from the Texas DUI file and marriage/divorce indexes.
************************************************************
/*
Could refine byear match criteria: Age at certain point in time implies a window of time when birthdate could be. Could refine criteria to see if the windows are overlapping.

*/

clear all
set more off
program drop _all


**Root directory
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas

global raw_dir "$root_dir/raw_data/breath_test_data"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"



	

foreach y in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {
	
	
	use "$int_dir/texas_breath_tests_uniqueincident_`y'.dta", clear
	//use "$int_dir/texas_breath_tests_uniqueincident_A.dta", clear
	
	* STEP 1
	//mmerge first_name last_name using "$int_dir/marriagerecords_`y'"
	mmerge first_name last_name using "$int_dir/marrwithdivorces_`y'"
	//mmerge first_name last_name using "$int_dir/marrwithdivorces_A"
	
	*Work with observations that merged
	keep if _merge==3
	drop _merge
	
		
	* STEP 2
	**Get rid of matches where the birthdate ranges aren't compatible
	drop if dui_bdate_min > marr_hbdate_max | dui_bdate_max < marr_hbdate_min

	
	**Compare middle initials
	gen dui_marr_mi_match = dui_middle_initial==marr_middle_initial
	gen dui_marr_mi_none = dui_middle_initial=="" & marr_middle_initial==""
	gen mi_mismatch = dui_middle_initial!=marr_middle_initial & dui_middle_initial!="" & marr_middle_initial!=""
	
	
	* STEP 3
	*Drop if the middle initials are mismatched (neither missing & they aren't the same)
	drop if mi_mismatch
	drop mi_mismatch
	
	
	**At this point we want to count how many people satisfy the criteria for each DUI incident.
	**We may use this to further prune observations when we perform the eventual analysis.
	
	duplicates tag dui_incident_id, gen(dui_marr_dup_initial)
	
	* STEP 4
	*Drop obs with a missing middle initial in the voter file when there exists another potential merge with matching middle initial
	egen dui_marr_num_mi_match = sum(dui_marr_mi_match), by(dui_incident_id)
	drop if dui_marr_mi_match==0 & dui_marr_num_mi_match>0
	
	
	* STEP 5
	*Drop obs where there is no middle initial in the DUI record, there is one in the voter file, and there exists another potential merge from the voter file with no middle initial
	egen dui_marr_num_mi_none = sum(dui_marr_mi_none), by(dui_incident_id)
	drop if dui_marr_mi_none==0 & dui_marr_num_mi_none>0
	
	/* Don't have alt first and last names constructed for marriage records
	* STEP 6
	**Compare alternative first and last names (which include more words from the raw names) 
	gen dui_voter_alt_first_name_match=dui_alt_first_name==voter_alt_first_name & dui_alt_first_name~=""
	gen dui_voter_alt_last_name_match=dui_alt_last_name==voter_alt_last_name & dui_alt_last_name~=""
	
	*Drop people with an alternative name match with some record but don't have an alternative name match with the current record.
	egen num_alt_first_match=sum(dui_voter_alt_first_name_match), by(dui_incident_id)
	egen num_alt_last_match=sum(dui_voter_alt_last_name_match), by(dui_incident_id)
		
	drop if dui_voter_alt_first_name_match==0 & num_alt_first_match>0
	drop if dui_voter_alt_last_name_match==0 & num_alt_last_match>0
	*/
	
	
	* STEP 7
	**Compare suffixes
	gen dui_marr_suffix_match = dui_suffix==marr_suffix & dui_suffix!=""
	
	egen dui_marr_num_suffix_match = sum(dui_marr_suffix_match), by(dui_incident_id)
	drop if dui_marr_suffix_match==0 & dui_marr_num_suffix_match>0
	
	
	
	/* Not sure we have county FIPS codes attached to all marriage records
	* STEP 8
	** Compare counties
	gen dui_voter_county_match=last_dui_county_fips==voter_county_fips // using county from last DUI test for incidents with multiple tests
	
	*Drop obs where counties are different but there's another match where they are the same
	egen dui_voter_num_county_match=sum(dui_voter_county_match), by(dui_incident_id)
	drop if dui_voter_county_match==0 & dui_voter_num_county_match>1
	
	drop num*
	*/
	
	/*
	* STEP 9
	**We have some multiple matches--some of these are people who presumably moved because
	**the birthdates are exactly the same.  Others are people with extremely common names.
	
	
	**Let's get rid of duplicates where the birthdate is exactly the same and it looks plausible that 
	**the person just moved and hence was registered to vote in 2 places.  Note that there are
	**a couple of cases where the duplicates appear to be 2 people registered in different places
	**with middle names that are just slightly different spellings.
	duplicates drop dui_incident_id first_name last_name voter_middle_initial voter_b_date, force
	*/
		
	
	**Inventory the obs we have left
	duplicates tag dui_incident_id, gen(dui_marr_dup)
	
	
	**Create variables for the timing of the marriage relative to the incident
	gen months_test_to_marr = (marr_date - dui_test_date)/30
	gen marr_after_test = months_test_to_marr > 0
	gen marr_1yrafter = inrange(months_test_to_marr,1,12)
	gen marr_2yrsafter = inrange(months_test_to_marr,1,24)
	
	foreach var in marr_after_test marr_1yrafter marr_2yrsafter	{
		
		bys dui_incident_id: egen any_`var' = max(`var')
		
	}
	
	**Create indicator for being married at the time of the incident
	gen married_when_tested = marr_date < dui_test_date & div_date > dui_test_date
	
	**Create variables indicating whether a divorce occured after the incident
	gen div_after_test = div_date > dui_test_date & div_date!=.
	gen div_within1yr = inrange((div_date - dui_test_date)/30,1,12)
	gen div_within2yrs = inrange((div_date - dui_test_date)/30,1,24)
	gen marrbefore_divafter = married_when_tested & div_after_test
	
	foreach var in div_after_test div_within1yr div_within2yrs married_when_tested marrbefore_divafter	{
		
		bys dui_incident_id: egen any_`var' = max(`var')
		
	}
	
	**For now, reduce to just one obs per incident
	drop marr_husbandname* marr_husbandage marr_wifename marr_wifeage marr_county marr_countycode marr_month marr_day marr_year marr_date marr_hbdate_max marr_hbdate_min marr_suffix marr_middle_initial dui_marr_mi_match dui_marr_mi_none dui_marr_num_mi_match dui_marr_num_mi_none dui_marr_suffix_match dui_marr_num_suffix_match months_test_to_marr marr_after_test marr_1yrafter marr_2yrsafter
	
	drop div_husbandname* div_husbandage div_wifename div_wifeage div_num_child div_countycode div_county div_month div_day div_year div_date div_marriagemonth div_marriageday div_marriageyear div_marriagedate div_hbdate_max div_hbdate_min div_suffix div_middle_initial div_after_test div_within1yr div_within2yrs married_when_tested
	
	duplicates drop
	
	**Add back in incidents that didn't merge
	append using "$int_dir/texas_breath_tests_uniqueincident_`y'.dta"
	gen dui_marr_no_match = any_marr_after_test==.
	bys dui_incident_id: egen temp = min(dui_marr_no_match)
	drop if dui_marr_no_match==1 & temp==0
	drop temp
	
	foreach var in any_marr_after_test any_marr_1yrafter any_marr_2yrsafter	{
		
		replace `var' = 0 if `var'==.
		
	}
	
	
	
	
	save "$int_dir/dui_marr_merged_`y'.dta", replace
	
	
	}
	
	
	
	
	
*** Append all first-initial datasets together
clear

foreach y in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {
    
	append using "$int_dir/dui_marr_merged_`y'.dta"
	
}

compress
save "$int_dir/dui_marr_merged_all", replace


exit


*** PRELIMINARY ANALYSIS
use "$int_dir/dui_marr_merged_all", clear

* So far we only have merged marriage records for men
keep if inlist(dui_sex,"M","m")

gen double rounded_lowest_vresult = floor(dui_lowest_vresult*100)/100

gen above_limit = dui_lowest_vresult>=.08
gen above_limitxresult = above_limit*dui_lowest_vresult

gen index = dui_lowest_vresult - .08
gen interact = above_limit*index


//bys rounded_lowest_vresult: egen mean_any_marr_after = mean(any_marr_after_test)
//bys rounded_lowest_vresult: egen mean_any_marr_1yr = mean(any_marr_1yrafter)
//bys rounded_lowest_vresult: egen mean_any_marr_2yrs = mean(any_marr_2yrsafter)

bys dui_lowest_vresult: egen mean_any_marr_after = mean(any_marr_after_test)
bys dui_lowest_vresult: egen mean_any_marr_1yr = mean(any_marr_1yrafter)
bys dui_lowest_vresult: egen mean_any_marr_2yrs = mean(any_marr_2yrsafter)

bys dui_lowest_vresult any_married_when_tested: egen mean_marrbefore_divafter = mean(any_marrbefore_divafter)


//scatter mean_any_marr_1yr rounded_lowest_vresult if inrange(dui_lowest_vresult,.03,.13)
scatter mean_any_marr_1yr dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), xline(.08)

scatter mean_any_marr_2yrs dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), xline(.08)

scatter mean_any_marr_after dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), xline(.08)

scatter mean_marrbefore_divafter dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13) & any_married_when_tested==1, xline(.08)


reg any_marr_1yr above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust

reg any_marr_1yr above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust

reg any_marr_2yrs above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust

reg any_marr_2yrs above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust

reg any_marrbefore_divafter above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & any_married_when_tested==1, robust

reg any_marrbefore_divafter above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & any_married_when_tested==1, robust