/*
In the breath test records, we start with three name variables:
1) first_name_raw
2) last_name_raw
3) dui_middle_initial

From these, we will construct three new variables:
1) first_name (the first word of the name)
2) last_name (the last word of the name, excluding suffixes and combining compound names, e.g. "DE LA ROSA" = "DELAROSA")
3) dui_suffix

During the match process, we merge on first_name last_name. We refine from there, including prioritizing candidate matches with the same middle initials and suffixes in both datasets.
*/


***Standardize case and remove punctuation + leading/trailing spaces from first and last name variables
replace last_name_raw=upper(last_name_raw)
replace first_name_raw=upper(first_name_raw)
replace dui_middle_initial=upper(dui_middle_initial)
replace last_name_raw=subinstr(last_name_raw,"-"," ",.)
replace last_name_raw=subinstr(last_name_raw,".","",.)
replace last_name_raw=subinstr(last_name_raw,"  "," ",.)
replace last_name_raw=subinstr(last_name_raw,"  "," ",.)
replace last_name_raw=subinstr(last_name_raw,"'","",.)
replace last_name_raw=subinstr(last_name_raw,"?"," ",.)
replace last_name_raw=subinstr(last_name_raw,"*"," ",.)
replace last_name_raw=trim(last_name_raw)


replace first_name_raw=subinstr(first_name_raw,"-"," ",.)
replace first_name_raw=subinstr(first_name_raw,".","",.)
replace first_name_raw=subinstr(first_name_raw,"  "," ",.)
replace first_name_raw=subinstr(first_name_raw,"  "," ",.)
replace first_name_raw=subinstr(first_name_raw,"'","",.)
replace first_name_raw = trim(first_name_raw)



***Clean first names
* Split multiword first names so that each word is its own variable
split first_name_raw


* Pull out suffixes that are mixed into first names
gen dui_suffix=""

forvalues i=2/4 {
	replace dui_suffix="JR" if first_name_raw`i'=="JR"
	replace first_name_raw`i'="" if first_name_raw`i'=="JR"
	replace dui_suffix="JR" if first_name_raw`i'=="JR."
	replace first_name_raw`i'="" if first_name_raw`i'=="JR."
	replace dui_suffix="SR" if first_name_raw`i'=="SR"
	replace first_name_raw`i'="" if first_name_raw`i'=="SR"
	replace dui_suffix="II" if first_name_raw`i'=="II"
	replace first_name_raw`i'="" if first_name_raw`i'=="II"
	replace dui_suffix="III" if first_name_raw`i'=="III"
	replace first_name_raw`i'="" if first_name_raw`i'=="III"
	replace dui_suffix="IV" if first_name_raw`i'=="IIII"
	replace first_name_raw`i'="" if first_name_raw`i'=="IIII"
	replace dui_suffix="IV" if first_name_raw`i'=="IV"
	replace first_name_raw`i'="" if first_name_raw`i'=="IV"
	replace dui_suffix="V" if first_name_raw`i'=="V"
	replace first_name_raw`i'="" if first_name_raw`i'=="V"
	replace dui_suffix="VI" if first_name_raw`i'=="VI"
	replace first_name_raw`i'="" if first_name_raw`i'=="VI"
	replace dui_suffix="JR" if first_name_raw`i'=="JR"
	replace first_name_raw`i'="" if first_name_raw`i'=="JR"
}

* Create a variable that is the first word of the first name (we will merge on this)
gen first_name=first_name_raw1

* We won't use the raw first name or the variables containing each word of the first name anymore
drop first_name_raw*


***Clean last names
* Split multiword last names so that each word is its own variable
split last_name_raw


*Pull out suffixes that are mixed into last names
	forval i=2/5 {
		capture replace dui_suffix="JR" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="JR" |  last_name_raw`i'=="JR."
		capture replace dui_suffix="II" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="II" | last_name_raw`i'=="2" | last_name_raw`i'=="2ND"
		capture replace dui_suffix="SR" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace last_name_raw`i'="" if last_name_raw`i'=="SR" | last_name_raw`i'=="SR."
		capture replace dui_suffix="III" if last_name_raw`i'=="III"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="III"
		capture replace dui_suffix="IV" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII" 
		capture replace last_name_raw`i'="" if last_name_raw`i'=="IV" | last_name_raw`i'=="1V" | last_name_raw`i'=="IIII"
		capture replace dui_suffix="V" if last_name_raw`i'=="V"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="V"
		capture replace dui_suffix="VI" if last_name_raw`i'=="VI"
		capture replace last_name_raw`i'="" if last_name_raw`i'=="VI"
		}

* Construct last name variable for merge
/*
This is:
- The only word of the last name for one-word names
- The last word of the last name for multi-word names, except for those that we call "compound" (e.g. DE LA ROSA or MC DONALD)
- All pieces of compound names concatenated (e.g. "SANCHEZ DE LA ROSA" = "DELAROSA")
*/
gen temp = last_name_raw
foreach i in JR SR II III IV V VI	{

	replace temp = subinstr(temp," `i'","",.) if dui_suffix=="`i'"
	
}

drop temp*
	
	
**Finish last name cleaning (combine compound name phrases like "de la" into a single word, but not cases that look like multiple distinct surnames)
*One-word last names		
gen last_name=last_name_raw1 if last_name_raw2==""

*XX (and below)
gen dui_alt_last_name=""

*Two-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

*Last names that seem to be 2 different surnames
replace dui_alt_last_name=last_name_raw1+last_name_raw2 if last_name_raw3=="" & last_name==""
replace last_name=last_name_raw2 if last_name_raw3=="" & last_name==""


*Three-word last names
*Take care of compound names
replace last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name_raw4=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

*Three-word names that seem a compound of one two word name and another 1 word name
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")

replace last_name=last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw1=="DOS" | last_name_raw1=="D" | last_name_raw1=="DE" | last_name_raw1=="DEL" | last_name_raw1=="DELLA" | last_name_raw1=="DELA" | last_name_raw1=="DA" | last_name_raw1=="VAN" | last_name_raw1=="VON" | last_name_raw1=="VOM" | last_name_raw1=="SAINT" | last_name_raw1=="ST" | last_name_raw1=="SANTA" | last_name_raw1=="A" | last_name_raw1=="AL" | last_name_raw1=="BEN" | last_name_raw1=="DI" | last_name_raw1=="EL" | last_name_raw1=="LA" | last_name_raw1=="LE" | last_name_raw1=="MC" | last_name_raw1=="MAC" | last_name_raw1=="O" | last_name_raw1=="SAN")


*Three-word names that seem a compound of 1 one-word name and another two-word name
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")

replace last_name=last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4=="" & (last_name_raw2=="DOS" | last_name_raw2=="D" | last_name_raw2=="DE" | last_name_raw2=="DEL" | last_name_raw2=="DELLA" | last_name_raw2=="DELA" | last_name_raw2=="DA" | last_name_raw2=="VAN" | last_name_raw2=="VON" | last_name_raw2=="VOM" | last_name_raw2=="SAINT" | last_name_raw2=="ST" | last_name_raw2=="SANTA" | last_name_raw2=="A" | last_name_raw2=="AL" | last_name_raw2=="BEN" | last_name_raw2=="DI" | last_name_raw2=="EL" | last_name_raw2=="LA" | last_name_raw2=="LE" | last_name_raw2=="MC" | last_name_raw2=="MAC" | last_name_raw2=="O" | last_name_raw2=="SAN")


*The rest of the three-word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3 if last_name=="" & last_name_raw4==""
replace last_name=last_name_raw3 if last_name=="" & last_name_raw4==""


*Four-word names
*Names that include de los or van de
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")

replace last_name=last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw1+last_name_raw2=="DELA" | last_name_raw1+last_name_raw2=="DELOS" | last_name_raw1+last_name_raw2=="DELAS"  | last_name_raw1+last_name_raw2=="VANDE" | last_name_raw1+last_name_raw2=="VANDER")


replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

replace last_name=last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw2+last_name_raw3=="DELA" | last_name_raw2+last_name_raw3=="DELOS" | last_name_raw2+last_name_raw3=="DELAS"  | last_name_raw2+last_name_raw3=="VANDE" | last_name_raw2+last_name_raw3=="VANDER")

*Names that end with a two-word name like de santis
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")

replace last_name=last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5=="" & (last_name_raw3=="DOS" | last_name_raw3=="D" | last_name_raw3=="DE" | last_name_raw3=="DEL" | last_name_raw3=="DELLA" | last_name_raw3=="DELA" | last_name_raw3=="DA" | last_name_raw3=="VAN" | last_name_raw3=="VON" | last_name_raw3=="VOM" | last_name_raw3=="SAINT" | last_name_raw3=="ST" | last_name_raw3=="SANTA" | last_name_raw3=="A" | last_name_raw3=="AL" | last_name_raw3=="BEN" | last_name_raw3=="DI" | last_name_raw3=="EL" | last_name_raw3=="LA" | last_name_raw3=="LE" | last_name_raw3=="MC" | last_name_raw3=="MAC" | last_name_raw3=="O" | last_name_raw3=="SAN")


*The rest of the 4 word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4 if last_name=="" & last_name_raw5==""
replace last_name=last_name_raw4 if last_name=="" & last_name_raw5==""


*Five-word names
*We're just going to work on the last parts of the names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

replace last_name=last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw3+last_name_raw4=="DELA" | last_name_raw3+last_name_raw4=="DELOS" | last_name_raw3+last_name_raw4=="DELAS"  | last_name_raw3+last_name_raw4=="VANDE" | last_name_raw3+last_name_raw4=="VANDER")

*Names that end with a 2 word name like de santis
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")

replace last_name=last_name_raw4+last_name_raw5 if last_name=="" & (last_name_raw4=="DOS" | last_name_raw4=="D" | last_name_raw4=="DE" | last_name_raw4=="DEL" | last_name_raw4=="DELLA" | last_name_raw4=="DELA" | last_name_raw4=="DA" | last_name_raw4=="VAN" | last_name_raw4=="VON" | last_name_raw4=="VOM" | last_name_raw4=="SAINT" | last_name_raw4=="ST" | last_name_raw4=="SANTA" | last_name_raw4=="A" | last_name_raw4=="AL" | last_name_raw4=="BEN" | last_name_raw4=="DI" | last_name_raw4=="EL" | last_name_raw4=="LA" | last_name_raw4=="LE" | last_name_raw4=="MC" | last_name_raw4=="MAC" | last_name_raw4=="O" | last_name_raw4=="SAN")

*The rest of the 5 word names
replace dui_alt_last_name=last_name_raw1+last_name_raw2+last_name_raw3+last_name_raw4+last_name_raw5 if last_name==""
replace last_name=last_name_raw5 if last_name==""


drop last_name_raw*

/*
Variables that we'll use for matching records:
- first_name
- last_name
- dui_middle_initial
- dui_suffix

*/

