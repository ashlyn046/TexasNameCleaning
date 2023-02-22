
**Root directory--This is all that needs to be changed across users
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas


**Note that the directory pir_sos_20210118 may need to be uncompressed for the file to run
global raw_dir "$root_dir/raw_data/courts_data"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"






clear all
set more off
/*

*** MOVE TO CLEANING CODE***
* Create first-initial convictions datasets

	
use "$clean_dir/conviction_database/person_linked", clear

merge 1:m ind_idn using "$clean_dir/conviction_database/conv_linked"


gen conv_yob = year(date_dob1)
gen conv_yoa = year(date_doa) // year of arrest
gen conv_moa = month(date_doa) // month of arrest
	// For now, keep only convictions in breath test sample period
	keep if conv_yoa==2004 | inrange(conv_yoa,2009,2015) | (inlist(conv_yoa,2005,2016) & conv_moa==1)
	
// Still need to create sentencing vars, offense vars


** Clean name vars
* Normalize capitilization and punctuation of names
replace lname_txt1=upper(lname_txt1)
replace lname_txt1=subinstr(lname_txt1,"-"," ",.)
replace lname_txt1=subinstr(lname_txt1,".","",.)
replace lname_txt1=subinstr(lname_txt1,"  "," ",.)
replace lname_txt1=subinstr(lname_txt1,"  "," ",.)
replace lname_txt1=subinstr(lname_txt1,"'","",.)
replace lname_txt1=subinstr(lname_txt1,"?"," ",.)
replace lname_txt1=subinstr(lname_txt1,"*"," ",.)
replace lname_txt1=trim(lname_txt1)


replace fname_txt1=upper(fname_txt1)
replace fname_txt1=subinstr(fname_txt1,"-"," ",.)
replace fname_txt1=subinstr(fname_txt1,".","",.)
replace fname_txt1=subinstr(fname_txt1,"  "," ",.)
replace fname_txt1=subinstr(fname_txt1,"  "," ",.)
replace fname_txt1=subinstr(fname_txt1,"'","",.)
replace fname_txt1=trim(fname_txt1)



**Make first name vars (one with first word, one with all words)
split fname_txt1

*Pull out suffixes
gen conv_suffix=""
forvalues i=2/5 {
	replace conv_suffix="JR" if fname_txt1`i'=="JR"
	replace fname_txt1`i'="" if fname_txt1`i'=="JR"
	replace conv_suffix="JR" if fname_txt1`i'=="JR."
	replace fname_txt1`i'="" if fname_txt1`i'=="JR."
	replace conv_suffix="SR" if fname_txt1`i'=="SR"
	replace fname_txt1`i'="" if fname_txt1`i'=="SR"
	replace conv_suffix="II" if fname_txt1`i'=="II"
	replace fname_txt1`i'="" if fname_txt1`i'=="II"
	replace conv_suffix="III" if fname_txt1`i'=="III"
	replace fname_txt1`i'="" if fname_txt1`i'=="III"
	replace conv_suffix="IV" if fname_txt1`i'=="IIII"
	replace fname_txt1`i'="" if fname_txt1`i'=="IIII"
	replace conv_suffix="IV" if fname_txt1`i'=="IV"
	replace fname_txt1`i'="" if fname_txt1`i'=="IV"
	replace conv_suffix="V" if fname_txt1`i'=="V"
	replace fname_txt1`i'="" if fname_txt1`i'=="V"
	replace conv_suffix="VI" if fname_txt1`i'=="VI"
	replace fname_txt1`i'="" if fname_txt1`i'=="VI"
	replace conv_suffix="JR" if fname_txt1`i'=="JR"
	replace fname_txt1`i'="" if fname_txt1`i'=="JR"
}

gen first_name = fname_txt11
gen f_first3 = substr(first_name,1,3)

**The alt_first_name is everything but the suffix
gen conv_alt_first_name=fname_txt11+fname_txt12+fname_txt13+fname_txt14+fname_txt15 if fname_txt12~=""

**I pull a possible middle initial from the first character of the second word in the first name
gen conv_middle_initial =substr(fname_txt12,1,1)

drop fname_txt11-fname_txt15



**Make last name vars
// Need to return to code where lname_txt1, etc., were created to make sure we're making last name vars that are consistent with the last name vars from the breath tests. Right now, lname_txt1 is one word long for everyone in the data (very different from breath test data).
gen last_name = lname_txt1

gen l_first3 = substr(last_name,1,3)



gen conv_fullname = fname_txt1 + " " + lname_txt1
replace conv_fullname = stritrim(conv_fullname)


foreach i in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z	{
preserve
keep if substr(fname_txt1,1,1)=="`i'"
save "$int_dir/person_conv_breathtestyears_`i'", replace
clear
restore

}
*/
*****************************





clear
foreach i in A /*B C D E F G H I J K L M N O P Q R S T U V W X Y Z*/	{
use "$int_dir/texas_breath_tests_uniqueincident_`i'", clear // 28,928 obs


*** ROUND 1 MERGE
mmerge first_name last_name using "$int_dir/person_conv_breathtestyears_`i'"
keep if _merge==3
drop _merge

**Get rid of matches where arrest date is before stop date or more than 2 days after stop date (matches after that appear low quality)
drop if date_doa-cdot<0 | date_doa-cdot>2	// Now have 23,620 obs, 15,101 unique incidents

**Get rid of matches where the birth years aren't compatible
drop if dui_b_year_likely~=conv_yob & dui_b_year_unlikely~=conv_yob //22,488 obs, 14,595 unique incidents


**Compare middle initials
gen mi_match = middle_initial==conv_middle_initial
	gen mi_none = middle_initial=="" & conv_middle_initial==""
	gen mi_mismatch = middle_initial!=conv_middle_initial & middle_initial!="" & conv_middle_initial!=""
	
*Drop if the middle initials are mismatched (neither missing & they aren't the same)
drop if mi_mismatch
	
*Drop obs with a missing middle initial in the conviction database when there exists another potential merge with matching middle initial
egen num_mi_match = sum(mi_match), by(incident_id)
drop if mi_match==0 & num_mi_match>0	
	
	
*Drop obs where there is no middle initial in the DUI record, there is one in the conviction database, and there exists another potential merge from the conviction_database with no middle initial
egen num_mi_none = sum(mi_none), by(incident_id)
drop if mi_none==0 & num_mi_none>0

	
**Compare alternative first and last names (which include more words from the raw names) 
// Skipping alternative last names for now because we don't have this var constructed for conviction database
	gen alt_first_name_match=dui_alt_first_name==conv_alt_first_name & dui_alt_first_name~=""
	//gen alt_last_name_match=dui_alt_last_name==hc_alt_last_name & dui_alt_last_name~=""
	
	**Drop people who have an alternative name match with some record but don't have an alternative name match with the current record.
	egen num_alt_first_match=sum(alt_first_name_match), by(incident_id)
	//egen num_alt_last_match=sum(alt_last_name_match), by(incident_id)
		
	drop if alt_first_name_match==0 & num_alt_first_match>0
	//drop if alt_last_name_match==0 & num_alt_last_match>0
	
	
**Compare suffixes
	gen suffix_match = suffix==conv_suffix & suffix!=""
	
	egen num_suffix_match = sum(suffix_match), by(incident_id)
	drop if suffix_match==0 & num_suffix_match>0
	
	

	***Looking at observations that matched to multiple crimes, it appears that these are multiple offenses for the same breath test incident. We'll keep them all in for now.
	egen num_conv=sum(1), by(incident_id)
	
	// There are many people who seem to have multiple convictions connected to the same breath test (and who seem to have the same ind_id in the conviction database). Need to figure out what's going on here.
	

	
	
*** Save the incidents we've matched so far
	gen conv_round1match = 1
	
	save "$int_dir/dui_conv_round1", replace
	
	
	**Now we'll merge them back into the original DUI file so we get back all of the observations that didn't merge
	use "$int_dir/dui_conv_round1", clear
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_`i'"
	tab _merge
	
	keep if _m==2
	drop _m
	
	
	drop per_idn-conv_round1match
	
	
	*** ROUND 2 MERGE
	*** Some people with composite last names in the DUI data (e.g. CHAVARRIA-SANTOS, merge on CHAVARRIA, not SANTOS)--this
	*** merges these folks.

	
	**Now I figure out the length of variables so I can pull the first part of the alt_last_name off to merge it
	gen length_lname=length(last_name)	
	gen length_alname=length(dui_alt_last_name)

	
	**I will merge on the basis of the first part of the alt last name.  I change the names of some variables
	**to do this
	rename last_name dui_last_name
	
	
	**I create new last name with first part of compound last name
	gen last_name=substr(dui_alt_last_name,1,length_alname-length_lname) if length_alname>0
	
	**We'll only merge people with non-missing values of the edited last names
	
	keep if last_name~=""
	
	
	**Now merge to the conviction database
	mmerge first_name last_name using "$int_dir/person_conv_breathtestyears_`i'"
	
	keep if _merge==3
	drop _merge length_*
	
	
	
** Now do the other restrictions from the round 1 merges

**Get rid of matches where arrest date is before stop date or more than 2 days after stop date (matches after that appear low quality)
drop if date_doa-cdot<0 | date_doa-cdot>2	

**Get rid of matches where the birth years aren't compatible
drop if dui_b_year_likely~=conv_yob & dui_b_year_unlikely~=conv_yob 


**Compare middle initials
gen mi_match = middle_initial==conv_middle_initial
	gen mi_none = middle_initial=="" & conv_middle_initial==""
	gen mi_mismatch = middle_initial!=conv_middle_initial & middle_initial!="" & conv_middle_initial!=""
	
*Drop if the middle initials are mismatched (neither missing & they aren't the same)
drop if mi_mismatch
	
*Drop obs with a missing middle initial in the conviction database when there exists another potential merge with matching middle initial
egen num_mi_match = sum(mi_match), by(incident_id)
drop if mi_match==0 & num_mi_match>0	
	
	
*Drop obs where there is no middle initial in the DUI record, there is one in the conviction database, and there exists another potential merge from the conviction_database with no middle initial
egen num_mi_none = sum(mi_none), by(incident_id)
drop if mi_none==0 & num_mi_none>0

	
**Compare alternative first and last names (which include more words from the raw names) 
// Skipping alternative last names for now because we don't have this var constructed for conviction database
	gen alt_first_name_match=dui_alt_first_name==conv_alt_first_name & dui_alt_first_name~=""
	//gen alt_last_name_match=dui_alt_last_name==hc_alt_last_name & dui_alt_last_name~=""
	
	**Drop people who have an alternative name match with some record but don't have an alternative name match with the current record.
	egen num_alt_first_match=sum(alt_first_name_match), by(incident_id)
	//egen num_alt_last_match=sum(alt_last_name_match), by(incident_id)
		
	drop if alt_first_name_match==0 & num_alt_first_match>0
	//drop if alt_last_name_match==0 & num_alt_last_match>0
	
	
**Compare suffixes
	gen suffix_match = suffix==conv_suffix & suffix!=""
	
	egen num_suffix_match = sum(suffix_match), by(incident_id)
	drop if suffix_match==0 & num_suffix_match>0
	
	

	***Looking at observations that matched to multiple crimes, it appears that these are multiple offenses for the same breath test incident. We'll keep them all in for now.
	egen num_conv=sum(1), by(incident_id)
	
	// There are many people who seem to have multiple convictions connected to the same breath test (and who seem to have the same ind_id in the conviction database). Need to figure out what's going on here.
	

*** Save the incidents we've matched in this round
	gen conv_round2match = 1
		
	save "$int_dir/dui_conv_round2", replace
	
	
	
	*** ROUND 3 MERGE
	*** Some people with composite last names in the courts data (e.g. CHAVARRIA-SANTOS, merge on CHAVARRIA, not SANTOS)--this
	*** merges these folks.  We need to start with the harris county data first for this merge.
	use "$int_dir/person_conv_breathtestyears_`i'", clear

	
	**In this case, the alternative last name is the categorized as a middle names
	gen tmpvar=fname_txt1
	split tmpvar
	replace last_name=tmpvar2
	drop tmpvar*
	
	save tmpdat, replace
	
	use "$int_dir/texas_breath_tests_uniqueincident_`i'", clear

	mmerge first_name last_name using tmpdat
	keep if _merge==3
	drop _merge

**Get rid of matches where arrest date is before stop date or more than 2 days after stop date (matches after that appear low quality)
drop if date_doa-cdot<0 | date_doa-cdot>2	// Now have 23,620 obs, 15,101 unique incidents

**Get rid of matches where the birth years aren't compatible
drop if dui_b_year_likely~=conv_yob & dui_b_year_unlikely~=conv_yob //22,488 obs, 14,595 unique incidents


**Comparing middle initials won't work given how we constructed the alternative last name
	
**Compare suffixes
	gen suffix_match = suffix==conv_suffix & suffix!=""
	
	egen num_suffix_match = sum(suffix_match), by(incident_id)
	drop if suffix_match==0 & num_suffix_match>0
	
	
	***Looking at observations that matched to multiple crimes, it appears that these are multiple offenses for the same breath test incident. We'll keep them all in for now.
	egen num_conv=sum(1), by(incident_id)
	
	// There are many people who seem to have multiple convictions connected to the same breath test (and who seem to have the same ind_id in the conviction database). Need to figure out what's going on here.
	

	
	
*** Save the incidents we've matched so far
	gen conv_round3match = 1
	
	save "$int_dir/dui_conv_round3", replace

exit
	
	append using "$int_dir/dui_conv_round1" "$int_dir/dui_conv_round2"
	**Now we'll merge them back into the original DUI file so we get back all of the observations that didn't merge
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_`i'"
	tab _merge
	
	keep if _m==2
	drop _m
	
	drop per_idn-conv_round1match
	
	
		

** ROUND 4 MERGE
	mmerge f_first3 l_first3 using "$int_dir/person_conv_breathtestyears_`i'"
	
	keep if _merge==3
	drop _merge
	
**Get rid of matches where arrest date is before stop date or more than 2 days after stop date (matches after that appear low quality)
drop if date_doa-cdot<0 | date_doa-cdot>2


**Compare birth years. Drop obs where they are incompatible, but there is another match with a compatible birth year
	gen b_year_match = dui_b_year_likely==conv_yob | dui_b_year_unlikely==conv_yob
	bys incident_id: egen max_b_year_match = max(b_year_match)
	bys incident_id: egen min_b_year_match = min(b_year_match)
	
	drop if b_year_match==0 & max_b_year_match==1

	
**Compare names using Jaro-Winkler distance
	jarowinkler dui_fullname conv_fullname
	
	sort jarowinkler
	
	//browse incident_id jaro dui_fullname conv_fullname middle_initial conv_middle_initial dui_b_year_likely dui_b_year_unlikely conv_yob lowest_result
	
	keep if jarowinkler > .9 | (jarowinkler>=.8 & b_year_match==1)
	
	
	egen num_conv = sum(1), by(incident_id)
	
	drop *b_year_match jarowinkler
	
	gen conv_round4match = 1
	
	
	save "$int_dir/dui_conv_round4", replace
	
	
	use "$int_dir/dui_conv_round4", clear
	append using /*"$int_dir/dui_conv_round3" */ "$int_dir/dui_conv_round2" "$int_dir/dui_conv_round1"
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_`i'"
	tab _merge
	
	keep if _m==2
	drop _m
	
	drop per_idn-conv_round1match
	
/* Haven't adapted rounds 5 and 6 yet - wait until we've sorted out last name

	*** ROUND 5 MERGE
	mmerge first_name using "$int_dir/harris_county_breathtestyears.dta"
	
	keep if _merge==3
	drop _merge
	
	**Get rid of matches where filing date is before stop date or more than 2 days after stop date (matches after that appear low quality)
	drop if file_date-cdot<0 | file_date-cdot>2
		
	**Compare birth years. Drop obs where they are incompatible, but there is another match with a compatible birth year
	gen b_year_match = dui_b_year_likely==def_yob | dui_b_year_unlikely==def_yob
	bys incident_id: egen max_b_year_match = max(b_year_match)
	bys incident_id: egen min_b_year_match = min(b_year_match)
	
	drop if b_year_match==0 & max_b_year_match==1
	

	**Compare names using Jaro-Winkler distance
	jarowinkler hc_fullname dui_fullname
	
	
		* It looks to me like all the matches with jarowinkler >=.95 are good. Matches with jarowinkler in something like [.877,.95) and compatible birth years also look good.
		
		
	* Figure out how many words and initials match (excluding first word and first initial)
	gen dui_namewordcount = wordcount(dui_fullname)
	gen hc_namewordcount = wordcount(hc_fullname)
	
	split dui_fullname, p(" ")
	split hc_fullname, p(" ")
	
	forval i = 1/6	{
		
		gen dui_initial`i' = substr(dui_fullname`i',1,1)
		gen hc_initial`i' = substr(hc_fullname`i',1,1)
		
		* Don't want to include matching initials or JRs in word match count
		replace dui_fullname`i' = "" if length(dui_fullname`i')==1 | dui_fullname`i'=="JR"
		replace hc_fullname`i' = "" if length(hc_fullname`i')==1 | hc_fullname`i'=="JR"
		
	}
	
	
	gen n_word_match = 0
	gen n_initial_match = 0
	
	forval i = 2/6	{
		forval j = 2/6	{
		
			replace n_word_match = n_word_match + 1 if dui_fullname`i'==hc_fullname`j' & dui_fullname`i'!="" & hc_fullname`j'!=""
			replace n_initial_match = n_initial_match + 1 if dui_initial`i'==hc_initial`j' & dui_initial`i'!="" & hc_initial`j'!=""
			
		}
	}
	
		* People with at least one matching word besides first name word seem to be the same person as well
	//keep if jarowinkler>=.95 | (jarowinkler>=.877 & b_year_match==1) | n_word_match>0
	keep if jarowinkler>=.95 | (jarowinkler>=.9 & b_year_match==1) | n_word_match>0
	
	egen num_off_filed=sum(1), by(incident_id)
	
	drop *b_year_match jarowinkler dui_namewordcount-n_initial_match
	
	gen hc_round5match = 1
	
	save "$int_dir/dui_hc_round5", replace
	append using  "$int_dir/dui_hc_round4" "$int_dir/dui_hc_round3" "$int_dir/dui_hc_round2" "$int_dir/dui_hc_round1"
	
	
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_hc"
	tab _merge
	
	keep if _m==2
	drop _m
	drop cdi-num_off_filed
	
	
	
	*** ROUND 6 MERGE
	//gen def_age = cage //
	
	//mmerge l_first3 def_age using "$int_dir/harris_county_breathtestyears.dta"
	//mmerge l_first3 using "$int_dir/harris_county_breathtestyears.dta"
	mmerge last_name using "$int_dir/harris_county_breathtestyears.dta"
	
	keep if _merge==3
	drop _merge
	
	**Get rid of matches where filing date is before stop date or more than 2 days after stop date (matches after that appear low quality)
	drop if file_date-cdot<0 | file_date-cdot>2
		
	**Compare birth years. Drop obs where they are incompatible, but there is another match with a compatible birth year
	gen b_year_match = dui_b_year_likely==def_yob | dui_b_year_unlikely==def_yob
	bys incident_id: egen max_b_year_match = max(b_year_match)
	bys incident_id: egen min_b_year_match = min(b_year_match)
	
	drop if b_year_match==0 & max_b_year_match==1
	

	**Compare names using Jaro-Winkler distance
	jarowinkler hc_fullname dui_fullname
	
	keep if jarowinkler >= .95 | (jarowinkler >= .85 & b_year_match==1)
	
	
	
	egen num_off_filed=sum(1), by(incident_id)
	
	drop *b_year_match jarowinkler
	
	gen hc_round6match = 1
	
	save "$int_dir/dui_hc_round6", replace
	append using "$int_dir/dui_hc_round1" "$int_dir/dui_hc_round2" "$int_dir/dui_hc_round3" "$int_dir/dui_hc_round4" "$int_dir/dui_hc_round5"
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_hc"
	replace num_off_filed=0 if _merge~=3
	assert num_off_filed~=.
	drop _merge
	
	
	
	** Cleaning up variables for analysis
	foreach var in dwi poss drugmanufdeliv recklessdriving resistarrest weapon hitandrun evadearrest licenseinvalid conviction deferredadjud nolocontend conv_defer_nolo dwiconviction dwideferredadju dwinolocontend dwiconv_defer_nolo	{
	    
		replace `var' = 0 if `var'==.
		
	}

foreach var in sentence_incarcmonths sentence_probation sentence_fine	{
    
	replace `var' = 0 if `var'==.
	gen has_`var' = `var' > 0
	
}

gen nondwiconviction = dwi==0 & conviction==1


	** Addressing incidents with multiple associated charges
	duplicates tag incident_id, gen(n_charges)
	replace n_charges = n_charges + 1 if cas!=.
	gen any_charges = n_charges>0
	
	foreach var in dwi dwiconviction conviction deferredadjud nolocontend conv_defer_nolo nondwiconviction	{
	    
		bys incident_id: egen n_`var' = sum(`var')
		bys incident_id: gen any_`var' = n_`var' > 0
	
	}
	
	* Check what happens with sentences when there are convictions on multiple charges. The sentences are almost always listed as identical, which makes me think they are NOT additive.
	foreach var in sentence_incarcmonths sentence_probation sentence_fine	{
	    
		bys incident_id: egen max_`var' = max(`var')
		bys incident_id: egen max_has_`var' = max(has_`var')
		
	}
	

** Construct the predicted race variables that we'll use (taking advantage of race info in court records)
gen f_prob_ms=f_probability_black==.
   replace f_probability_black=0 if f_probability_black==.

gen l_prob_ms=l_probability_black==.
   replace l_probability_black=0 if l_probability_black==.

gen f2=f_probability_black^2
   
gen l2=l_probability_black^2
   
gen int1=f_probability_black*l_probability_black
gen int2=f_probability_black*l_prob_ms
gen int3=l_probability_black*f_prob_ms

logit black f_probability_black l_probability_black f_prob_ms l_prob_ms int1 int2 int3
predict p_black

sum p_black lowest_result


gen likely_black = p_black>.5 & f_likely_race!="hispanic" & l_likely_race!="hispanic"
gen likely_hispanic = f_likely_race=="hispanic" & l_likely_race=="hispanic"
gen likely_white = p_black<.2 & !likely_hispanic & f_likely_race=="white" & l_likely_race=="white"


save "$clean_dir/dui_hc_merged.dta", replace
*/



**** Preliminary data merge
	use "$int_dir/dui_conv_round4", clear
	append using /*"$int_dir/dui_conv_round3" */ "$int_dir/dui_conv_round2" "$int_dir/dui_conv_round1"
	
	mmerge incident_id using "$int_dir/texas_breath_tests_uniqueincident_`i'"
	//tab _merge
	
	
	* Narrow down to one obs per incident
	bys incident_id: gen temp = _n==1
	keep if temp
	drop temp
	
	gen any_conviction = num_conv!=.
	
	save "$int_dir/dui_conv_merged_`i'", replace
}	
	
	
/*
*** Preliminary analysis of match quality/first stage
	bys lowest_result: egen mean_any_conviction = mean(any_conviction)
	
	scatter mean_any_conviction lowest_result
	scatter mean_any_conviction lowest_result if inrange(lowest_result,.03,.13)
