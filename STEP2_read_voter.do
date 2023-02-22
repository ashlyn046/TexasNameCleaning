clear
capture log close
set more off



**Root directory
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas


**Note that the directory pir_sos_20210118 may need to be uncompressed for the file to run
global raw_dir "$root_dir/raw_data/voter_data/pir_sos_20210118"
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"



** Read in file for each county, clean, sort into files by first letter of first name
forvalues y=1/254 {

clear
	
**Information on Hispanic ethnicity, party, and voting method do not appear to be present in the data so we won't read that in.
infix voter_county_fips 1-3 str voter_precinct 4-12 str voter_id 13-22 str last_name_raw 24-73 str first_name_raw 74-123 str voter_middle_name 124-173 str voter_former_last_name 174-223 str voter_suffix 224-227 str voter_sex 228 str dob 229-236 str p_h_no 237-245 str p_des 246-257 str p_dir_pre 258-259 str p_str_name 260-309 str p_str_type 310-320 str p_dir_suf 321-323 str p_unit_no 324-335 str p_unit_type 336-347 str p_city 348-397 str p_zip 398-402 str m_add_1 407-516 str m_add_2 517-566 str m_city 567-616 str m_state 617-636 str m_zip 637-641 str voter_reg_date 657-664 str voter_status_code 665-665 using "$raw_dir/pir_sos_20210520084000_20210118_`y'.txt"

drop if last_name_raw=="PER SOS DEC RPT #3549" | last_name_raw=="" | last_name_raw=="PER SOS DEC RPT #3427"

for var p_*: replace X=trim(X)

gen voter_perm_address=p_h_no
 replace voter_perm_address=voter_perm_address+" "+p_des if p_des~=""
 replace voter_perm_address=voter_perm_address+" "+p_dir_pre if p_dir_pre~="" 
 replace voter_perm_address=voter_perm_address+" "+p_str_name if p_str_name~="" 
 replace voter_perm_address=voter_perm_address+" "+p_str_type if p_str_type~="" 
 replace voter_perm_address=voter_perm_address+" "+p_dir_suf if p_dir_suf~="" 
 replace voter_perm_address=voter_perm_address+" "+p_unit_type if p_unit_type~="" 
 replace voter_perm_address=voter_perm_address+" "+p_unit_no if p_unit_no~="" 
 replace voter_perm_address=voter_perm_address+", "+p_city if p_city~="" 
 replace voter_perm_address=voter_perm_address+", TX" 
 replace voter_perm_address=voter_perm_address+" "+p_zip if p_zip~="" 

drop p_*

gen voter_mail_address=trim(m_add_1)
  replace voter_mail_address=voter_mail_address+" "+trim(m_add_2) if trim(m_add_2)~=""
  replace voter_mail_address=voter_mail_address+", "+trim(m_city)+", "+trim(m_state)+" "+trim(m_zip)
drop m_*

**Get rid of extra spaces
gen tmpvar=subinstr(voter_mail_address,"  "," ",.)
gen tmpvar2=subinstr(tmpvar,"  "," ",.)
gen tmpvar3=subinstr(tmpvar2,"  "," ",.)
replace voter_mail_address=tmpvar3
drop tmpvar*


** Prep birthdate vars
gen voter_b_year=real(substr(dob,1,4))
gen voter_b_month=real(substr(dob,5,2))
gen voter_b_day=real(substr(dob,7,2))


gen voter_b_date=date(string(voter_b_month)+"/"+string(voter_b_day)+"/"+string(voter_b_year),"MDY")
format voter_b_date %td
drop dob



***Clean names and construct name variables for merging with other files
gen voter_fullname = first_name_raw + " " + voter_middle_name + " " + last_name_raw + " " + voter_suffix

*Standardize case and remove punctuation + extra spaces
replace last_name_raw=upper(last_name_raw)
replace first_name_raw=upper(first_name_raw)
replace voter_middle_name=upper(voter_middle_name)
replace last_name_raw=subinstr(last_name_raw,"-"," ",.)
replace last_name_raw=subinstr(last_name_raw,".","",.)
replace last_name_raw=subinstr(last_name_raw,"  "," ",.)
replace last_name_raw=subinstr(last_name_raw,"'","",.)
replace last_name_raw=trim(last_name_raw)

replace first_name_raw=subinstr(first_name_raw,"-"," ",.)
replace first_name_raw=subinstr(first_name_raw,".","",.)
replace first_name_raw=subinstr(first_name_raw,"  "," ",.)
replace first_name_raw=subinstr(first_name_raw,"'","",.)


** Make first name vars (one with first word, one with all words)
split first_name_raw

gen first_name=first_name_raw1
gen voter_alt_first_name=subinstr(first_name_raw," ","",.)

drop first_name_raw*



** Make last name vars
split last_name_raw

cap gen last_name_raw2 = ""
cap gen last_name_raw3 = ""
cap gen last_name_raw4 = ""
cap gen last_name_raw5 = ""
cap gen last_name_raw6 = ""

*Pull out suffixes
	forval i=2/5 {
		local j=`i'+1
		capture replace voter_suffix="JR" if last_name_raw`i'=="JR" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="JR" & last_name_raw`j'==""
		capture replace voter_suffix="SR" if last_name_raw`i'=="SR" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="SR" & last_name_raw`j'==""
		capture replace voter_suffix="III" if last_name_raw`i'=="III" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="III" & last_name_raw`j'==""
		capture replace voter_suffix="IV" if last_name_raw`i'=="IV" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="IV" & last_name_raw`j'==""
		capture replace voter_suffix="V" if last_name_raw`i'=="V" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="V" & last_name_raw`j'==""
		capture replace voter_suffix="VI" if last_name_raw`i'=="VI" & last_name_raw`j'=="" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="VI" & last_name_raw`j'==""
		}
		
**Finish last name cleaning (combine last name phrases like "de la" into a single word, but not cases that look like multiple distinct surnames)
*One-word last names
gen last_name=last_name_raw1 if last_name_raw2==""	
gen voter_alt_last_name = ""

*Two-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

*Last names that seem to be 2 different surnames
replace voter_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""


*Three-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name_raw4=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

*Three-word names that seem a compound of one two word name and another 1 word name
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

replace last_name=last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")


*Three-word names that seem a compound of 1 one-word name and another two-word name
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")

replace last_name=last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")


*The rest of the three-word names
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4==""
replace last_name=last_name_raw3 if last_name=="" & last_name_raw4==""


*Four-word names
*Names that include de los or van de
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

replace last_name=last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")


replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

replace last_name=last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

*Names that end with a two-word name like de santis
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")

replace last_name=last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")


*The rest of the 4 word names
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5==""
replace last_name=last_name_raw4 if last_name=="" & last_name_raw5==""


*Five-word names
*We're just going to work on the last parts of the names
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

replace last_name=last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

*Names that end with a 2 word name like de santis
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")

replace last_name=last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")


*The rest of the five-word names
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & last_name_raw6==""
replace last_name=last_name_raw5 if last_name=="" & last_name_raw6==""


*Six-word last names
replace voter_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5+last_name_raw6 if last_name_raw6~=""


replace last_name="DELAFUENTE" if last_name_raw=="DE LA GARZA DE LA FUENTE"
replace last_name="DELAFUENTE" if last_name_raw=="DE LA CRUZ DE LA FUENTE"
replace last_name="UK" if last_name_raw=="CEVO V AMOSU ONESI ASIAWU UK"
replace last_name="DESAINTMARC" if last_name_raw=="BAUGNIES DE PAUL DE SAINT MARC"
replace last_name="DEBORBON" if last_name_raw=="DE TODOS LOS SANTOS DE BORBON"
replace last_name="DELAROSA" if last_name_raw=="DE LEON DE DE LA ROSA"
replace last_name="DELAGARZA" if last_name_raw=="DE LOS REYES DE LA GARZA"


drop last_name_raw*


* Make middle initial var
gen voter_middle_initial=substr(voter_middle_name,1,1)


* Clean sex vars
gen voter_male = voter_sex=="M"
	replace voter_male = . if voter_sex=="U"


* Drop unnecessary vars
drop voter_status_code



* Label vars
label var voter_county_fips "County FIPS from voter file"
label var voter_precinct "Voter file precinct"
label var voter_id "Voter file ID number"
label var voter_middle_name "Voter file middle name (administratively recorded, not constructed)"
label var voter_former_last_name "Former last name from voter file"
label var voter_suffix "Voter file suffix"
label var voter_reg_date "Voter registration date"
label var voter_perm_address "Permanent address from voter file"
label var voter_mail_address "Mailing address from voter file"
label var voter_b_year "Birth year from voter file"
label var voter_b_month "Birth month from voter file"
label var voter_b_day "Birth day (of month) from voter file"
label var voter_b_date "Birth date from voter file"
label var first_name "First word of name"
label var voter_alt_first_name "All first name words, without suffixes or spaces, from voter file"
label var last_name "Last listed last name, combining compound name and removing suffixes and spaces (e.g. VONLEHM not VON LEHM)"
label var voter_alt_last_name "All last name words, without suffixes or spaces, from voter file"
label var voter_middle_initial "Middle initial from voter file (first letter of administratively recorded middle name)"



foreach var in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z	{

		preserve
		gen temp = substr(first_name,1,1)
		keep if temp=="`var'"
		drop temp
		save $int_dir/voter_file_`y'_`var', replace
		restore
}
	
}


**Now we stitch back together all of the county files starting with the same
**last initial


foreach var in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z {

clear

forvalues y=1/254	{
	capture append using "$int_dir/voter_file_`y'_`var'.dta"

}

compress
save "$int_dir/voter_file_`var'.dta", replace

}


*** Create a database of name frequency based on voter files to help make predicted match quality measures later

use first_name last_name using "$int_dir/voter_file_A.dta", clear
save tmpdat, replace


foreach y in B C D E F G H I J K L M N O P Q R S T U V W X Y Z {

use first_name last_name using "$int_dir/voter_file_`y'.dta"
append using tmpdat
save tmpdat, replace
}

**Now let's create frequency tables of first and last names.

use tmpdat, clear
gen f_name_freq=1
collapse (sum) f_name_freq, by(first_name)
save "$int_dir/voter_f_name_freq.dta", replace


use tmpdat, clear
gen l_name_freq=1
collapse (sum) l_name_freq, by(last_name)
save "$int_dir/voter_l_name_freq.dta", replace


