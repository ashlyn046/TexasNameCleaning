/*
This do-file cleans court records from criminal cases in the Harris County District Court.

To do:
- Start using complaint offense for filing vars (and current offense for conviction vars)--usually the same, but not always

*/




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


**Read in raw text data


*******************************************
*******************************************
*******************************************
*******************************************
* RA: clean up obs with messed up quotes
import delimited using "$raw_dir/harris_county_districtcourt/DATA - Leslie NO QUOTE.txt", delim("|") varn(nonames) clear

rename v1 cdi
rename v2 cas
rename v3 fda
rename v4 ins
rename v5 cad
rename v6 crt
rename v7 cst
rename v8 dst
rename v9 bam
rename v10 curr_off
rename v11 curr_off_lit
rename v12 curr_l_d
rename v13 com_off
rename v14 com_off_lit
rename v15 com_l_d
rename v16 gj_off
rename v17 gj_off_lit
rename v18 gj_l_d
rename v19 nda
rename v20 cnc
rename v21 rea
rename v22 def_nam
rename v23 def_spn
rename v24 def_rac
rename v25 def_sex
rename v26 def_dob
rename v27 def_stnum
rename v28 def_stnam
rename v29 def_cty
rename v30 def_tx
rename v31 def_zip
rename v32 aty_nam
rename v33 aty_spn
rename v34 aty_coc
rename v35 aty_coc_lit
rename v36 comp_nam
rename v37 comp_agency
rename v38 off_rpt_num
rename v39 dispdt
rename v40 disposition
rename v41 sentence
rename v42 def_citizen


label var cdi "court division indicator"
label var cas "case number"
label var fda "case file date"
label var ins "instrument type"
label var cad "setting results"
label var crt "court number"
label var cst "case status"
label var dst "defendant status"
label var bam "bond amount"
label var curr_off "current offense NCIC"
label var curr_off_lit "current offense literal"
label var curr_l_d "current offense level and degree"
label var com_off "complaint offense NCIC"
label var com_off_lit "complaint offense literal"
label var com_l_d "complaint offense level and degree"
label var gj_off "grand jury offense NCIC"
label var gj_off_lit "grand jury offense literal"
label var gj_l_d "grand jury offense level and degree"
label var nda "next appearance date"
label var cnc "docket type"
label var rea "next appearance reason"
label var def_nam "defendant name"
label var def_spn "defendant spn"
label var def_rac "defendant race"
label var def_sex "defendant sex"
label var def_dob "defendant date of birth"
label var def_stnum "defendant street number"
label var def_stnam "defendant street name"
label var def_cty "defendant city"
label var def_tx "defendant state"
label var def_zip "defendant zip"
label var aty_nam "attorney name"
label var aty_spn "attorney spn"
label var aty_coc "attorney connection code"
label var aty_coc_lit "attorney connection literal"
label var comp_nam "complainant name"
label var comp_agency "complainant agency"
label var off_rpt_num "offense report number"
label var dispdt "disposition date"
label var disposition "disposition"
label var sentence "sentence"
label var def_citizen "def citizienship status"
*******************************************
*******************************************
*******************************************
*******************************************




*** Offense levels
gen court_curroff_felony = regexm(curr_l_d,"F")
gen court_curroff_misdemeanor = regexm(curr_l_d,"M")

gen court_comoff_felony = regexm(com_l_d,"F")
gen court_comoff_misdemeanor = regexm(com_l_d,"M")


	
*** Identify crime types
* RA: Refine drug possession crime vars
* Current offense DWI vars
gen court_curroff_dwi = regexm(curr_off_lit, "DWI")
	replace court_curroff_dwi = 1 if regexm(curr_off_lit,"DRIVING WHILE INTOX")	
gen court_curroff_1stdwi = court_curroff_dwi & regexm(curr_off_lit,"1ST")
gen court_curroff_2nddwi = court_curroff_dwi & regexm(curr_off_lit,"2ND")
gen court_curroff_3rddwi = court_curroff_dwi & regexm(curr_off_lit,"3RD")
gen court_curroff_aggdwi = court_curroff_dwi & (regexm(curr_off_lit,"AGG") | regexm(curr_off_lit,"SBI") | regexm(curr_off_lit,"CHILD") | regexm(curr_off_lit,"OPEN"))
	
	
* Complaint offense DWI vars
gen court_comoff_dwi = regexm(com_off_lit, "DWI")
	replace court_comoff_dwi = 1 if regexm(com_off_lit,"DRIVING WHILE INTOX")
gen court_comoff_1stdwi = court_comoff_dwi & regexm(com_off_lit,"1ST")
gen court_comoff_2nddwi = court_comoff_dwi & regexm(com_off_lit,"2ND")
gen court_comoff_3rddwi = court_comoff_dwi & regexm(com_off_lit,"3RD")
gen court_comoff_aggdwi = court_comoff_dwi & (regexm(com_off_lit,"AGG") | regexm(com_off_lit,"SBI") | regexm(com_off_lit,"CHILD") | regexm(com_off_lit,"OPEN"))
	
	
* Current offense non-DWI vars
gen court_curroff_poss = regexm(curr_off_lit,"POSS")
	replace court_curroff_poss = 0 if regexm(curr_off_lit,"WEAPON")	
gen court_curroff_drugmanufdeliv = regexm(curr_off_lit,"MAN/DEL")
gen court_curroff_recklessdriving = regexm(curr_off_lit,"RECKLESS DRIVING")
gen court_curroff_resistarrest = regexm(curr_off_lit,"RESIST")
gen court_curroff_weapon = regexm(curr_off_lit,"WEAPON") | regexm(curr_off_lit,"WPN")
gen court_curroff_hitandrun = regexm(curr_off_lit,"FAILURE TO STOP & GIVE") | regexm(curr_off_lit,"FAILURE TO STOP AND GIVE")
gen court_curroff_evadearrest = regexm(curr_off_lit,"EVADING ARREST") | regexm(curr_off_lit,"EVADE ARREST") | regexm(curr_off_lit,"EVAD ARREST")
gen court_curroff_licenseinvalid = regexm(curr_off_lit,"LIC INV")


* Complaint offense non-DWI vars
gen court_comoff_poss = regexm(com_off_lit,"POSS")
	replace court_comoff_poss = 0 if regexm(com_off_lit,"WEAPON")	
gen court_comoff_drugmanufdeliv = regexm(com_off_lit,"MAN/DEL")
gen court_comoff_recklessdriving = regexm(com_off_lit,"RECKLESS DRIVING")
gen court_comoff_resistarrest = regexm(com_off_lit,"RESIST")
gen court_comoff_weapon = regexm(com_off_lit,"WEAPON") | regexm(com_off_lit,"WPN")
gen court_comoff_hitandrun = regexm(com_off_lit,"FAILURE TO STOP & GIVE") | regexm(com_off_lit,"FAILURE TO STOP AND GIVE")
gen court_comoff_evadearrest = regexm(com_off_lit,"EVADING ARREST") | regexm(com_off_lit,"EVADE ARREST") | regexm(com_off_lit,"EVAD ARREST")
gen court_comoff_licenseinvalid = regexm(com_off_lit,"LIC INV")


*construct criminal history
*RA: double check that guilty is coded correctly
*RA: create vars for prior felony convictions, prior felony charges, prior misdemeanor convictions, prior misdemeanor charges
gen court_conviction = regexm(disposition,"CONVICTION") | regexm(disposition,"GUILTY PLEA") | regexm(disposition,"PLEA OF GUILTY")

gen court_deferredadjud = regexm(disposition,"DEFERRED ADJ") | regexm(disposition,"DEF ADJ")

gen court_nolocontend = regexm(disposition,"NOLO")

gen court_conv_defer_nolo = court_conviction | court_deferredadjud | court_nolocontend
	
gen court_dwiconviction = court_curroff_dwi & court_conviction
gen court_dwideferredadjud = court_curroff_dwi & court_deferredadjud
gen court_dwinolocontend = court_curroff_dwi & court_nolocontend
gen court_dwiconv_defer_nolo = court_curroff_dwi & court_conv_defer_nolo 


	

sort def_spn fda

bys def_spn (fda): gen court_priordwis = sum(court_dwiconviction)
	replace court_priordwis = court_priordwis - court_dwiconviction

bys def_spn (fda): gen court_priorconvictions = sum(court_conviction)
	replace court_priorconvictions = court_priorconvictions - court_conviction




*******************************************
*******************************************
*******************************************
*******************************************
*RA: What are we learning from second event about how case turned out?
**keep only first event of a case
**The second event seems to tell us something about the eventual resolution of the case (e.g. deferred adjudication terminated)
**We'll want to think about this as well.
sort cas dispdt
bys cas: gen temp = _n==1
*******************************************
*******************************************
*******************************************
*******************************************


keep if temp
drop temp

*create date vars
gen court_file_year = floor(fda/10000)
gen court_file_month = floor(fda/100) - court_file_year*100
gen court_file_day = fda - court_file_year*10000 - court_file_month*100
gen court_file_date = mdy(court_file_month,court_file_day,court_file_year)
	format court_file_date %td
	
gen court_disposition_year = substr(dispdt,1,4)
gen court_disposition_month = substr(dispdt,5,2)
gen court_disposition_day = substr(dispdt,7,2)
	destring court_disposition_*, replace force
	
gen court_disposition_date = mdy(court_disposition_month, court_disposition_day, court_disposition_year)
	format court_disposition_date %td



*infer defendant age
gen court_b_year = floor(def_dob/1e4)
gen court_b_month = floor(def_dob/100) - court_b_year*100
gen court_b_day = def_dob - 10000*court_b_year - 100*court_b_month

gen court_b_date = date(string(court_b_month)+"/"+string(court_b_day)+"/"+string(court_b_year),"MDY")
format court_b_date %td
drop def_dob
	
	
*create defendant race vars
// I'm guessing on what these codes mean (especially I = Islander and U = Unknown)
gen court_race_black = def_rac=="B"
gen court_race_white = def_rac=="W"
gen court_race_asian = def_rac=="A"
gen court_race_islander = def_rac=="I"

foreach var in black white asian islander	{
	
	replace court_race_`var' = . if def_rac=="U" | def_rac==""
	
}

drop def_rac

*create defendant attorney type
gen court_aty_appointed = aty_coc=="AAT"
gen court_aty_hired = aty_coc=="HAT"

*create sentence vars
split sentence, p(",")

	*incarceration
gen court_sentence_hcj = ""
	replace court_sentence_hcj = sentence1 if regexm(sentence1,"HCJ")
gen court_sentence_statejail = ""
	replace court_sentence_statejail = sentence1 if regexm(sentence1,"STATE JAIL")
gen court_sentence_tdc = ""
	replace court_sentence_tdc = sentence1 if regexm(sentence1,"TDC")

gen court_sentence_incarcmonths = .

foreach var in hcj statejail tdc	{
	
	split court_sentence_`var', gen(temp)
		destring temp1, replace
		replace court_sentence_incarcmonths = temp1/30 if temp2=="DAYS"
		replace court_sentence_incarcmonths = temp1 if temp2=="MONTHS"
		replace court_sentence_incarcmonths = temp1*12 if temp2=="YEARS"
		drop temp*
	
}

replace court_sentence_incarcmonths = 0 if court_sentence_incarcmonths==.

	*probation
gen temp = ""	
forval i = 1/3	{
	
	replace temp = sentence`i' if regexm(sentence`i',"PROBATION")
	
}
split temp, gen(temp2)
destring temp21, force replace

gen court_sentence_probation = .
	replace court_sentence_probation = temp21/30 if temp22=="DAYS"
	replace court_sentence_probation = temp21 if temp22=="MONTHS"
	replace court_sentence_probation = temp21*12 if temp22=="YEARS"
	replace court_sentence_probation = 0 if court_sentence_probation==.
drop temp*

gen temp = ""
forval i = 1/3	{
	
	replace temp = sentence`i' if regexm(sentence`i',"FINE")
	
}
split temp, gen(temp2)
replace temp21 = subinstr(temp21,"$","",.)
destring temp21, replace
rename temp21 court_sentence_fine
	replace court_sentence_fine = 0 if court_sentence_fine==.
drop temp* sentence1 sentence2 sentence3 sentence



* prep full_name var
/*
gen split = ustrpos(def_nam, ",") //show substr where the split is
gen last_name_raw = usubstr(def_nam, 1, split-1)
gen first_name_raw = usubstr(def_nam, split+1, .) //create first and last
*/
split def_nam, parse(",")
rename def_nam1 last_name_raw
rename def_nam2 first_name_raw

gen court_fullname = first_name_raw + " " + last_name_raw
replace court_fullname = stritrim(court_fullname)

**Normalize capitilization and punctuation of names
replace last_name_raw=upper(last_name_raw)
replace last_name_raw=subinstr(last_name_raw,"-"," ",.)
replace last_name_raw=subinstr(last_name_raw,".","",.)
replace last_name_raw=subinstr(last_name_raw,"  "," ",.)
replace last_name_raw=subinstr(last_name_raw,"'","",.)
replace last_name_raw=subinstr(last_name_raw,"?"," ",.)
replace last_name_raw=subinstr(last_name_raw,"*"," ",.)
replace last_name_raw=trim(last_name_raw)


replace first_name_raw=upper(first_name_raw)
replace first_name_raw=subinstr(first_name_raw,"-"," ",.)
replace first_name_raw=subinstr(first_name_raw,".","",.)
replace first_name_raw=subinstr(first_name_raw,"  "," ",.)
replace first_name_raw=subinstr(first_name_raw,"'","",.)
replace first_name_raw=trim(first_name_raw)




**Make first name vars (one with first word, one with all words)
split first_name_raw



**Pull out suffixes
gen court_suffix=""
forvalues i=2/4 {
	replace court_suffix="JR" if first_name_raw`i'=="JR"
	replace first_name_raw`i'="" if first_name_raw`i'=="JR"
	replace court_suffix="JR" if first_name_raw`i'=="JR."
	replace first_name_raw`i'="" if first_name_raw`i'=="JR."
	replace court_suffix="SR" if first_name_raw`i'=="SR"
	replace first_name_raw`i'="" if first_name_raw`i'=="SR"
	replace court_suffix="II" if first_name_raw`i'=="II"
	replace first_name_raw`i'="" if first_name_raw`i'=="II"
	replace court_suffix="III" if first_name_raw`i'=="III"
	replace first_name_raw`i'="" if first_name_raw`i'=="III"
	replace court_suffix="IV" if first_name_raw`i'=="IIII"
	replace first_name_raw`i'="" if first_name_raw`i'=="IIII"
	replace court_suffix="IV" if first_name_raw`i'=="IV"
	replace first_name_raw`i'="" if first_name_raw`i'=="IV"
	replace court_suffix="V" if first_name_raw`i'=="V"
	replace first_name_raw`i'="" if first_name_raw`i'=="V"
	replace court_suffix="VI" if first_name_raw`i'=="VI"
	replace first_name_raw`i'="" if first_name_raw`i'=="VI"
	replace court_suffix="JR" if first_name_raw`i'=="JR"
	replace first_name_raw`i'="" if first_name_raw`i'=="JR"
}


gen first_name=first_name_raw1
gen f_first3 = substr(first_name,1,3)

**The alt_first_name is everything but the suffix
gen court_alt_first_name=first_name_raw1+first_name_raw2+first_name_raw3+first_name_raw4 if first_name_raw2~=""

**I pull a possible middle initial from the first character of the second word in the first name
gen court_middle_initial =substr(first_name_raw2,1,1)


drop first_name_raw*


**Make last name vars
split last_name_raw


**Pull out suffixes
	forval i=2/4 {
		capture replace court_suffix="JR" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace court_suffix="II" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace court_suffix="SR" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace court_suffix="III" if last_name_raw`i'=="III"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="III"
		capture replace court_suffix="IV" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII"
		capture replace court_suffix="V" if last_name_raw`i'=="V"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="V"
		capture replace court_suffix="VI" if last_name_raw`i'=="VI"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="VI"
		}


**Finish last name cleaning (combine last name phrases like "de la" into a single word, but not cases that look like multiple distinct surnames)	
*One-word last names		
gen last_name=last_name_raw1 if last_name_raw2==""
gen court_alt_last_name=""

*Two-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

*Last names that seem to be 2 different surnames
replace court_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""


*Three-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name_raw4=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

*Three-word names that seem a compound of one two word name and another 1 word name
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

replace last_name=last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")


*Three-word names that seem a compound of 1 one-word name and another two-word name
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")

replace last_name=last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")


*The rest of the three-word names
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4==""
replace last_name=last_name_raw3 if last_name=="" & last_name_raw4==""


*Four-word names
*Names that include de los or van de
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

replace last_name=last_name_raw4 if last_name=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")


replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

replace last_name=last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""  & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

*Names that end with a two-word name like de santis
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""  & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")

replace last_name=last_name_raw3+last_name_raw4 if last_name=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")


*The rest of the 4 word names
replace court_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name==""
replace last_name=last_name_raw4 if last_name==""


gen l_first3 = substr(last_name,1,3)

drop last_name_raw*



*** Clean sex vars
gen court_male = def_sex=="M"
	replace court_male = . if !inlist(def_sex,"M","F")
	

*** Indicator for record source
gen court_source = "HARRIS COUNTY"


*** Get rid of vars that aren't useful
drop cdi fda ins cad crt cst dst v43 v44 v45 cnc def_nam nda rea


*** Rename a few vars
rename cas court_case_number
rename bam court_bond_amount

foreach var in curr_off curr_off_lit curr_l_d com_off com_off_lit com_l_d gj_off gj_off_lit gj_l_d def_spn def_sex def_stnum def_stnam def_cty def_tx def_zip aty_nam aty_spn aty_coc aty_coc_lit comp_nam comp_agency off_rpt_num dispdt disposition def_citizen	{
	
	rename `var' court_`var'
	
}



*** Label vars
label var court_curroff_felony "Current offense is a felony"
label var court_curroff_misdemeanor "Current offense is a misdemeanor"
label var court_comoff_felony "Complaint offense is a felony"
label var court_comoff_misdemeanor "Complaint offense is a misdemeanor"
label var court_curroff_dwi "Current offense is a DWI"
label var court_curroff_1stdwi "Current offense code specifies 1st DWI"
label var court_curroff_2nddwi "Current offense code specifies 2nd DWI"
label var court_curroff_3rddwi "Current offense code specifies 3rd DWI"
label var court_curroff_aggdwi "Current offense code consistent with aggravated DWI"
label var court_comoff_1stdwi "Complaint offense code specifies 1st DWI"
label var court_comoff_2nddwi "Complaint offense code specifies 2nd DWI"
label var court_comoff_3rddwi "Complaint offense code specifies 3rd DWI"
label var court_comoff_aggdwi "Complaint offense code consistent with aggravated DWI"
label var court_curroff_poss "Current offense is a drug possession charge"
label var court_curroff_drugmanufdeliv "Current offense is a drug manufacturing/delivery charge"
label var court_curroff_recklessdriving "Current offense is a reckless driving charge"
label var court_curroff_resistarrest "Current offense is a resisting arrest charge"
label var court_curroff_weapon "Current offense is a weapons charge"
label var court_curroff_hitandrun "Current offense is a hit and run charge (a.k.a. failure to stop and give information)"
label var court_curroff_evadearrest "Current offense is an evading arrest charge"
label var court_curroff_licenseinvalid "Current offense is a driving with invalid license charge"
label var court_comoff_poss "Complaint offense is a drug possession charge"
label var court_comoff_drugmanufdeliv "Complaint offense is a drug manufacturing/delivery charge"
label var court_comoff_recklessdriving "Complaint offense is a reckless driving charge"
label var court_comoff_resistarrest "Complaint offense is a resisting arrest charge"
label var court_comoff_weapon "Complaint offense is a weapons charge"
label var court_comoff_hitandrun "Complaint offense is a hit and run charge (a.k.a. failure to stop and give information)"
label var court_comoff_evadearrest "Complaint offense is an evading arrest charge"
label var court_comoff_licenseinvalid "Complaint offense is a driving with invalid license charge"
label var court_conviction "Indicator for convicted (including guilty pleas)"
label var court_deferredadjud "Indicator for deferred adjudication"
label var court_nolocontend "Indicator for no lo contendere"
label var court_conv_defer_nolo "Indicator for convicted OR deferred adjudication OR no lo contendere"
label var court_dwiconviction "Indicator for convicted (including guilty pleas) & current offense is DWI"
label var court_dwideferredadjud "Indicator for deferred adjudication & current offense is DWI"
label var court_dwinolocontend "Indicator for no lo contendere & current offense is DWI"
label var court_dwiconv_defer_nolo "Indicator for convicted OR deferred adjudication OR no lo contendere & current offense is DWI"
label var court_file_year "Court case filing year"
label var court_file_month "Court case filing month"
label var court_file_day "Court case filing day (of month)"
label var court_file_date "Court case filing date"
label var court_disposition_year "Court case disposition year"
label var court_disposition_month "Court case disposition month"
label var court_disposition_day "Court case disposition day (of month)"
label var court_disposition_date "Court case disposition date"
label var court_b_year "Birth year from court record"
label var court_b_month "Birth month from court record"
label var court_b_day "Birth day (of month) from court record"
label var court_b_date "Birth date from court record"
label var court_race_black "Indicator for race recorded as Black in court record"
label var court_race_white "Indicator for race recorded as White in court record"
label var court_race_asian "Indicator for race recorded as Asian in court record"
label var court_race_islander "Indicator for race recorded as islander in court record"
label var court_aty_appointed "Indicator for representation by a court-appointed attorney"
label var court_aty_hired "Indicator for representation by a privately retained attorney"
label var court_sentence_hcj "Sentence time in Harris County Jail"
label var court_sentence_statejail "Sentence time in state jail"
label var court_sentence_tdc "Sentence time in Texas Department of Corrections facility (prison)"
label var court_sentence_incarcmonths "Sentence time in any facility (months)"
label var court_sentence_probation "Sentence time probation (months)"
label var court_fullname "Full name from court records"
label var court_suffix "Suffix from court records"
label var first_name "First word of name"
label var f_first3 "First 3 letters of first name"
label var court_alt_first_name "All first name words, without suffixes or spaces"
label var court_middle_initial "Middle initial from court record (constructed; first letter of second word of name)"
label var last_name "Last listed last name, combining compound name and removing suffixes and spaces (e.g. VONLEHM not VON LEHM)"
label var court_alt_last_name "All last name words, without suffixes or spaces"
label var l_first3 "First 3 letters of last name"
label var court_male "Indicator for male in court record"
label var court_source "Where court record came from"

compress

sort first_name last_name
save "$int_dir/harris_county_allcases.dta", replace



*** Dataset with all offenses within plausible timeframe
use "$int_dir/harris_county_allcases.dta", clear

*remove records that are out of the range of breath test records
keep if court_file_year==2004 | inrange(court_file_year,2009,2015) | (inlist(court_file_year,2005,2016) & court_file_month==1)

save "$int_dir/harris_county_breathtestyears.dta", replace



*** Dataset with only likely stop-related offenses
use "$int_dir/harris_county_allcases.dta", clear

*remove records that are out of the range of breath test records
keep if court_file_year==2004 | inrange(court_file_year,2009,2015) | (inlist(court_file_year,2005,2016) & court_file_month==1)

*keep only likely stop-related offenses
keep if court_curroff_dwi | court_curroff_poss | court_curroff_drugmanufdeliv | court_curroff_recklessdriving | court_curroff_resistarrest | court_curroff_weapon | court_curroff_hitandrun | court_curroff_evadearrest | court_curroff_licenseinvalid


sort first_name last_name
save "$int_dir/harris_county_stopoffenses.dta", replace
