/*
This do-file cleans court records from criminal cases in the Harris County District Court.

v1: Use "RECORD LAYOUT - 2020-12-08.xlsx" to read in data and name variables

TO DO:
- Fix var names for heterogeneity analysis (so they're different from above)
- Make Figure 1 pretty
- Figure 2: Figure 1 by observables (maybe binned more finely?)
- ?Add in criminal history
- Figure 3: Coefplot for BrAC x race (ideally w/ and w/o criminal history controls)
- Figure 4: Coefplot for BrAC x attorney type (conditional on having case filed, for BrAC >= .08)

*/




**Root directory--This is all that needs to be changed across users
*global root_dir "/Volumes/Elements/DUI/texas"
*global root_dir "/Users/ll263/Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas


**Note that the directory pir_sos_20210118 may need to be uncompressed for the file to run
global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"
global tabfig  "$root_dir/tabfig"


clear all
set more off


* Read in merged data
//use $clean_dir/allmerged, clear
use "$clean_dir/dui_hc_merged", clear


* If this works, move some version of this into the DUI cleaning code
replace dui_lowest_vresult = round(dui_lowest_vresult,.001)


** Make rounded BrAC for binning
gen double rounded_lowest_result = floor(dui_lowest_vresult*100)/100


** Make vars for regressions
* Make RD vars (2 ways)
//gen above_limit = dui_lowest_vresult>=.08
//gen above_limitxresult = above_limit*dui_lowest_vresult

gen index = dui_lowest_vresult - .08
gen above_limit = index>-.0001
gen interact = above_limit*index


gen dui_male = dui_sex=="M"


* Make vars for heterogeneity analysis
forval i = .01(.01).15	{
    
	local j = floor(`i'*100)
	gen black_x_roundedresult`j' = likely_black==1 & rounded_lowest_result==`i'
	gen hispanic_x_roundedresult`j' = likely_hispanic==1 & rounded_lowest_result==`i'
	gen white_x_roundedresult`j' = likely_white==1 & rounded_lowest_result==`i'
	
}


/*
**************************
*** SUMMARY STATISTICS ***
**************************
global summ_var lowest_result male cage likely_white likely_black likely_hispanic priordwis priorconvictions dwi dwiconviction any_charges any_conviction has_sentence_incarcmonths has_sentence_fine 

estpost sum $summ_var if inrange(lowest_result,.03,.13)
eststo col1

estpost sum $summ_var if inrange(lowest_result,.03,.069)
eststo col2

estpost sum $summ_var if inrange(lowest_result,.07,.079)
eststo col3

estpost sum $summ_var if inrange(lowest_result,.08,.13)
eststo col4

esttab col1 col2 col3 col4 using $tabfig/summstats.tex, replace ///
	mtitle("BAC $\in$ \[.03,.13\]" "BAC $\in$ [.03,.069]" "BAC $\in$ [.07,.079]" "BAC $\in$ [.08,.13]") label cells(mean(fmt(2))) ///
	varlabels(lowest_result "\hspace{0.1cm}BAC" male "\hspace{0.1cm}Male" cage "\hspace{0.1cm}Age" likely_white "\hspace{0.1cm}Likely White" likely_hispanic "\hspace{0.1cm}Likely Hispanic" likely_black "\hspace{0.1cm}Likely Black" priordwis "\hspace{0.1cm}Prior DWIs" priorconvictions "\hspace{0.1cm}Prior Convictions" dwi "\hspace{0.1cm}DWI charges filed" dwiconviction "\hspace{0.1cm}Convicted for DWI" any_charges "\hspace{0.1cm}Any charges filed" any_conviction "\hspace{0.1cm}Convicted on any charge" has_sentence_incarcmonths "\hspace{0.1cm}Sentenced to incarceration" has_sentence_fine "\hspace{0.1cm}Fined") ///
	refcat(dwi "\emph{Criminal justice outcomes}", nolabel) ///
	stats(N, labels("N") fmt(0)) collabels(none) booktabs f

/*
global summ_var totalcalls dv dv_day8_5 dv_morneve dv_repeat_3mo dv_norepeat_3mo theft traffic

estpost sum $summ_var if year==2019 & sample1==1
eststo col1

estpost sum $summ_var if year==2020 & sample1==1
eststo col2

esttab col1 col2 using ../paper/summstats.tex, replace ///	
	mtitle("2019" "2020") label cells(mean(fmt(2))) ///
	varlabels(totalcalls "Total calls for service" dv "Daily domestic violence calls" dv_day8_5 "\hspace{.5cm}Calls between 8 AM and 5 PM" dv_morneve "\hspace{.5cm}Calls at other times" dv_repeat_3mo "\hspace{.5cm}Calls to street blocks with 3 month history" dv_norepeat_3mo "\hspace{.5cm}Calls to street blocks without 3 month history" theft "Calls about theft" traffic "Calls about traffic incidents") ///
	stats(N, labels("N") fmt(0)) collabels(none) booktabs f

*/
*/

*******************
*** REGRESSIONS ***
*******************
/* Moved to RD validity do-file
reg male above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & insample, robust
eststo ymale

reg likely_black above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & insample, robust
eststo yblack

reg likely_hispanic above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & insample, robust
eststo yhisp

reg cage above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & insample, robust
eststo age


esttab ymale yblack yhisp age using $tabfig/rd_predet_characteristics.tex, replace ///
	keep(above_limit) varlabels(above_limit "BrAC $\geq$ .08") ///
	collabels(,none) mtitles("Male" "Black" "Hispanic" "Age") ///
	cells(b(fmt(3)) se(par fmt(3))) ///
	noobs f booktabs
*/
/*
esttab col11 col12 col13 col14 using ../paper/dd_sample1.tex, replace ///
	keep(post2 postx2020)  ///
	varlabels(post2 "\hspace{0.1cm} Post-Mar 9" postx2020 "\hspace{0.1cm} Post-Mar 9*Year 2020") ///
	refcat(post2 "\emph{Outcome: IHS(Daily DV Calls)}", nolabel) ///
	nostar collabels(,none) ///
	mtitles("\shortstack{Weeks 1-21\\2020}" "\shortstack{Weeks 1-21\\2020 and 2019}" "\shortstack{Weeks 1-21\\2020 and 2019}" "\shortstack{Weeks 1-14\\2020 and 2019}") ///
	noobs ///
	cells(b(fmt(3)) CI[lo](fmt(3) par(`"["' `","')) & CI[hi](fmt(3) par(`""' `"]"'))  p[r1](fmt(3) par)) ///
	stats(mean, labels("Mean of dep. var.") fmt(3)) ///
	f booktabs
*/


***************
*** FIGURES ***
***************
*** Make averaged vars for figs
foreach var in court_curroff_dwi court_comoff_dwi court_dwiconviction court_dwiconv_defer_nolo court_sentence_incarcmonths court_sentence_fine court_sentence_probation has_court_sentence_incarc has_court_sentence_fine has_court_sentence_prob any_charges any_court_conviction any_court_conv_defer_nolo any_court_nondwiconv{
    
	bys dui_lowest_vresult: egen mean_`var' = mean(`var')
	
}


* Make averaged vars for heterogeneity figs
foreach var in court_curroff_dwi court_comoff_dwi court_dwiconviction court_dwiconv_defer_nolo court_sentence_incarc court_sentence_fine court_sentence_prob has_court_sentence_i has_court_sentence_f has_court_sentence_p any_charges any_court_convic any_court_conv_d any_court_nondwiconv	{
    
	bys rounded_lowest_result likely_white likely_black likely_hispanic: egen race_`var' = mean(`var')
	bys rounded_lowest_result dui_male: egen male_`var' = mean(`var')
	bys rounded_lowest_result aty_coc: egen aty_`var' = mean(`var')
	bys rounded_lowest_result likely_white likely_black likely_hispanic aty_coc: egen raceaty_`var' = mean(`var')
	
}

bys rounded_lowest_result: egen mean_aty_hired = mean(court_aty_hired)
bys rounded_lowest_result: egen mean_aty_appointed = mean(court_aty_appointed)
gen any_aty = court_aty_hired==1 | court_aty_appointed==1
	replace any_aty = . if court_aty_hired==.
bys rounded_lowest_result: egen mean_any_aty = mean(any_aty)

/* Moved to RD validity checks do-file
*** Histogram of BrAC
hist lowest_result, frac ytitle("Share of breath tested drivers") xtitle("Lowest measured BrAC") graphregion(fcolor(white)) xline(.03 .13) fcolor(%90) 
graph save $tabfig/histofbrac, replace
graph export $tabfig/histofbrac.png, as(png) replace


* Test to confirm that there is not a discontinuity in density at the cutoff
/*
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
net install lpdensity, from(https://raw.githubusercontent.com/nppackages/lpdensity/master/stata) replace
*/
rddensity lowest_result if lowest_result>0, c(.08) plot
*/

*** FIGURE: Filings everyone
qui reg court_comoff_dwi above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg court_comoff_dwi above_limit index interact if inrange(dui_lowest_vresult,.06,.09) & !inrange(dui_lowest_vresult,.07,.079), robust
gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
gen tmpvar3 = "."+tmpvar1
gen tmpvar4 = ".0"+tmpvar2
local b2=tmpvar3
local sd2=tmpvar4
drop tmpvar*

scatter mean_court_comoff_dwi dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to DWI filing") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.2 .12 "{&beta} = `b1' (`sd1')") text(.1 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/dwifiling, replace
graph export $tabfig/dwifiling.png, as(png) replace



*** FIGURE: Filings and convictions for everyone
qui reg any_charges above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg any_charges above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_any_charges dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to any filing") ytitle("Share with charges filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.35 .12 "{&beta} = `b1' (`sd1')") text(.25 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/anyfiling, replace
graph export $tabfig/anyfiling.png, as(png) replace



qui reg court_dwiconviction above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg court_dwiconviction above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_court_dwiconviction dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to DWI conviction") ytitle("Share convicted of DWI") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.17 .12 "{&beta} = `b1' (`sd1')") text(.07 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/dwiconviction, replace
graph export $tabfig/dwiconviction.png, as(png) replace



qui reg any_court_conviction above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg any_court_conviction above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_any_court_conviction dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to any conviction") ytitle("Share with any conviction") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.17 .12 "{&beta} = `b1' (`sd1')") text(.07 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/anyconviction, replace
graph export $tabfig/anyconviction.png, as(png) replace


graph combine $tabfig/dwifiling.gph $tabfig/anyfiling.gph $tabfig/dwiconviction.gph $tabfig/anyconviction.gph, ///
	iscale(.5) graphregion(margin(zero)) ycommon 
graph save $tabfig/hcfilingsconvs, replace
graph export $tabfig/hcfilingsconvs.png, as(png) replace


exit



qui reg any_court_nondwiconv above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg any_court_nondwiconv above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_any_court_nondwiconv dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to any non-DWI conviction") ytitle("Share with any conviction") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.25 .12 "{&beta} = `b1' (`sd1')") text(.15 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/anynondwiconviction, replace
graph export $tabfig/anynondwiconviction.png, as(png) replace


graph combine $tabfig/dwiconviction.gph $tabfig/anynondwiconviction.gph, ///
	iscale(.72) graphregion(margin(zero)) ycommon cols(1) ysize(8)
graph save $tabfig/hcdwiandnondwiconv, replace
graph export $tabfig/hcdwiandnondwiconv.png, as(png) replace










*** FIGURE: Incarceration and fines for everyone
qui reg has_court_sentence_incarcmonths above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg has_court_sentence_incarcmonths above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_has_court_sentence_incarc dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to incarceration") ytitle("Share incarcerated") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.17 .12 "{&beta} = `b1' (`sd1')") text(.07 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/hassentenceincarc, replace
graph export $tabfig/hassentenceincarc.png, as(png) replace



qui reg has_court_sentence_fine above_limit index interact if inrange(dui_lowest_vresult,.07,.09), robust
local b1 = round(e(b)[1,1], .001)
local sd1 = round(e(V)[1,1]^(1/2), .001)

qui reg has_court_sentence_fine above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
local b2 = round(e(b)[1,1], .001)
local sd2 = round(e(V)[1,1]^(1/2), .001)

scatter mean_has_court_sentence_fine dui_lowest_vresult if inrange(dui_lowest_vresult,.03,.13), title("Share of breath tests that lead to fine") ytitle("Share fined") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.17 .12 "{&beta} = `b1' (`sd1')") text(.07 .12 "{&beta}{subscript:donut} = `b2' (`sd2')") 
graph save $tabfig/hassentencefine, replace
graph export $tabfig/hassentencefine.png, as(png) replace


graph combine $tabfig/hassentenceincarc.gph $tabfig/hassentencefine.gph, ///
	iscale(.72) graphregion(margin(zero)) ycommon cols(1) ysize(8)
graph save $tabfig/hcincarcfine, replace
graph export $tabfig/hcincarcfine.png, as(png) replace








*** FIGURE: Filings and convictions by race
// Source for added text syntax: https://www.statadaily.com/writing-greek-letters-and-other-symbols-in-graphs/


foreach r in white hispanic black	{
	qui reg court_comoff_dwi above_limit index interact if inrange(dui_lowest_vresult,.07,.09) & likely_`r'==1, robust
	local `r'b1 = round(e(b)[1,1], .001)
	local `r'sd1 = round(e(V)[1,1]^(1/2), .001)
	//gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	//gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	//gen tmpvar3 = "0."+tmpvar1
	//gen tmpvar4 = "0.0"+tmpvar2
	//local `r'b1=tmpvar3
	//local `r'sd1=tmpvar4
	//drop tmpvar*
	
	qui reg court_comoff_dwi above_limit index interact if inrange(dui_lowest_vresult,.06,.09) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust
	local `r'b2 = round(e(b)[1,1], .001)
	local `r'sd2 = round(e(V)[1,1]^(1/2), .001)
	//gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	//gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	//gen tmpvar3 = "0."+tmpvar1
	//gen tmpvar4 = "0.0"+tmpvar2
	//local `r'b2=tmpvar3
	//local `r'sd2=tmpvar4
	//drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}


	// The hispanicb local is displaying in the graph with lots of extra 0s and I don't know why.
scatter race_court_comoff_dwi rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_court_comoff_dwi rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
scatter race_court_comoff_dwi rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to DWI filing") subtitle("by BrAC and race") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /*text(.2 .08 "{&beta}{subscript:W} = `whiteb1' (`whitesd1')") text(.1 .08 "{&beta}{subscript:H} = `hispanicb1' (`hispanicsd1')") text(0 .08 "{&beta}{subscript:B} = `blackb1' (`blacksd1')") text(.2 .12 "{&beta}{subscript:W,donut} = `whiteb2' (`whitesd2')") text(.1 .12 "{&beta}{subscript:H,donut} = `hispanicb2' (`hispanicsd2')") text(0 .12 "{&beta}{subscript:B,donut} = `blackb2' (`blacksd2')")*/
graph save $tabfig/dwifiling_byrace, replace
graph export $tabfig/dwifiling_byrace.png, as(png) replace	



foreach r in white hispanic black	{
	qui reg any_charges above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust

	gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	gen tmpvar3 = "0."+tmpvar1
	gen tmpvar4 = "0.0"+tmpvar2
	local `r'b=tmpvar3
	local `r'sd=tmpvar4
	drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}
scatter race_any_charges rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_any_charges rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
scatter race_any_charges rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to any filing") subtitle("by BrAC and race") ytitle("Share with charges filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /*text(.2 .12 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.1 .12 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(0 .12 "{&beta}{subscript:B} = `blackb' (`blacksd')")*/
graph save $tabfig/anyfiling_byrace, replace
graph export $tabfig/anyfiling_byrace.png, as(png) replace	



foreach r in white hispanic black	{
	qui reg dwiconviction above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust

	gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	gen tmpvar3 = "0."+tmpvar1
	gen tmpvar4 = "0.0"+tmpvar2
	local `r'b=tmpvar3
	local `r'sd=tmpvar4
	drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}
scatter race_court_dwiconviction rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_court_dwiconviction rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
	scatter race_court_dwiconviction rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to DWI conviction") subtitle("by BrAC and race") ytitle("Share convicted of DWI") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /*text(.2 .12 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.1 .12 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(0 .12 "{&beta}{subscript:B} = `blackb' (`blacksd')")*/
graph save $tabfig/dwiconviction_byrace, replace
graph export $tabfig/dwiconviction_byrace.png, as(png) replace	


foreach r in white hispanic black	{
	qui reg any_court_conviction above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust

	gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	gen tmpvar3 = "0."+tmpvar1
	gen tmpvar4 = "0.0"+tmpvar2
	local `r'b=tmpvar3
	local `r'sd=tmpvar4
	drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}
scatter race_any_court_convic rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_any_court_convic rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
scatter race_any_court_convic rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to any conviction") subtitle("by BrAC and race") ytitle("Share with any conviction") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /*text(.2 .12 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.1 .12 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(0 .12 "{&beta}{subscript:B} = `blackb' (`blacksd')")*/
graph save $tabfig/anyconviction_byrace, replace
graph export $tabfig/anyconviction_byrace.png, as(png) replace	


/*
net install grc1leg,from( http://www.stata.com/users/vwiggins/) 
*/
grc1leg $tabfig/dwifiling_byrace.gph $tabfig/anyfiling_byrace.gph $tabfig/dwiconviction_byrace.gph $tabfig/anyconviction_byrace.gph, ///
	iscale(.5) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon
graph save $tabfig/hcfilingconv_byrace, replace
graph export $tabfig/hcfilingconv_byrace.png, as(png) replace




*** FIGURE: Incarceration and fines by race
foreach r in white hispanic black	{
	qui reg has_court_sentence_incarcmonths above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust

	gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	gen tmpvar3 = "0."+tmpvar1
	gen tmpvar4 = "0.0"+tmpvar2
	local `r'b=tmpvar3
	local `r'sd=tmpvar4
	drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}
scatter race_has_court_sentence_i rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_has_court_sentence_i rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
	scatter race_has_court_sentence_i rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to incarceration") subtitle("by BrAC and race") ytitle("Share incarcerated") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /*text(.2 .12 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.1 .12 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(0 .12 "{&beta}{subscript:B} = `blackb' (`blacksd')")*/
graph save $tabfig/hassentenceincarc_byrace, replace
graph export $tabfig/hassentenceincarc_byrace.png, as(png) replace	


foreach r in white hispanic black	{
	qui reg has_court_sentence_fine above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079) & likely_`r'==1, robust

	gen tmpvar1 = string(round(e(b)[1,1]*1000, 1))
	gen tmpvar2 = string(round(e(V)[1,1]^(1/2)*1000, 1))
	gen tmpvar3 = "0."+tmpvar1
	gen tmpvar4 = "0.0"+tmpvar2
	local `r'b=tmpvar3
	local `r'sd=tmpvar4
	drop tmpvar*
	
	// This way seems better, but in practice Stata added a bunch of extra digits to one of the coefficients on the graph
	* local `r'b = round(e(b)[1,1], .001)
	* local `r'sd = round(e(V)[1,1]^(1/2), .001)
}	
scatter race_has_court_sentence_f rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_has_court_sentence_f rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
	scatter race_has_court_sentence_f rounded_lowest_result if inrange(dui_lowest_vresult,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to fine") subtitle("by BrAC and race") ytitle("Share fined") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) ylabel(.0(.2)1) graphregion(fcolor(white)) /* text(.2 .12 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.1 .12 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(0 .12 "{&beta}{subscript:B} = `blackb' (`blacksd')") */
graph save $tabfig/hassentencefine_byrace, replace
graph export $tabfig/hassentencefine_byrace.png, as(png) replace
	

grc1leg $tabfig/hassentenceincarc_byrace.gph $tabfig/hassentencefine_byrace.gph, ///
	iscale(.6) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon cols(2)
graph save $tabfig/hcincarcfine_byrace, replace
graph export $tabfig/hcincarcfine_byrace.png, as(png) replace




*** FIGURE: Filings and convictions by race for people w/o prior DWI
/*
// Source for added text syntax: https://www.statadaily.com/writing-greek-letters-and-other-symbols-in-graphs/
foreach r in white hispanic black	{
	qui reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & likely_`r'==1 & priordwi==0, robust
	local `r'b = round(e(b)[1,1], .001)
	local `r'sd = round(e(V)[1,1]^(1/2), .001)
}

	// The hispanicb local is displaying in the graph with lots of extra 0s and I don't know why.
scatter race_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1 & priordwi==0, msymbol(O) mfcolor(none) || ///
scatter race_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1 & priordwi==0, msymbol(D) mfcolor(none) || ///
	scatter race_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1 & priordwi==0, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to DWI filing") subtitle("by BrAC and race, conditional on no prior DWI") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) text(.4 .1 "{&beta}{subscript:W} = `whiteb' (`whitesd')") text(.25 .1 "{&beta}{subscript:H} = `hispanicb' (`hispanicsd')") text(.1 .1 "{&beta}{subscript:B} = `blackb' (`blacksd')")
graph save $tabfig/dwifiling_byrace1stDWI, replace
graph export $tabfig/dwifiling_byrace1stDWI.png, as(png) replace	
*/

scatter race_any_charges rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1 & priordwi==0, msymbol(O) mfcolor(none) || ///
scatter race_any_charges rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1 & priordwi==0, msymbol(D) mfcolor(none) || ///
	scatter race_any_charges rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1 & priordwi==0, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to any filing") subtitle("by BrAC and race, conditionalon no prior DWI") ytitle("Share with charges filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/anyfiling_byrace1stDWI, replace
graph export $tabfig/anyfiling_byrace1stDWI.png, as(png) replace	


scatter race_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1 & priordwi==0, msymbol(O) mfcolor(none) || ///
scatter race_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1 & priordwi==0, msymbol(D) mfcolor(none) || ///
	scatter race_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1 & priordwi==0, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to DWI conviction") subtitle("by BrAC and race, conditional on no prior DWI") ytitle("Share convicted of DWI") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_byrace1stDWI, replace
graph export $tabfig/dwiconviction_byrace1stDWI.png, as(png) replace	


scatter race_any_conviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1 & priordwi==0, msymbol(O) mfcolor(none) || ///
scatter race_any_conviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1 & priordwi==0, msymbol(D) mfcolor(none) || ///
	scatter race_any_conviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1 & priordwi==0, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to any conviction") subtitle("by BrAC and race, conditional on no prior DWI") ytitle("Share with any conviction") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/anyconviction_byrace1stDWI, replace
graph export $tabfig/anyconviction_byrace1stDWI.png, as(png) replace	


/*
net install grc1leg,from( http://www.stata.com/users/vwiggins/) 
*/
grc1leg $tabfig/dwifiling_byrace1stDWI.gph $tabfig/anyfiling_byrace1stDWI.gph $tabfig/dwiconviction_byrace1stDWI.gph $tabfig/anyconviction_byrace1stDWI.gph, ///
	iscale(.5) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon
graph save $tabfig/hcfilingconv_byrace1stDWI, replace
graph export $tabfig/hcfilingconv_byrace1stDWI.png, as(png) replace




*** FIGURE: Incarceration and fines by race
scatter race_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) || ///
	scatter race_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1, msymbol(T) mfcolor(none) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of breath tests that lead to incarceration") subtitle("by BrAC and race") ytitle("Share incarcerated") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/hassentenceincarc_byrace, replace
graph export $tabfig/hassentenceincarc_byrace.png, as(png) replace



*** FIGURE: Attorney hiring by race
scatter race_aty_hired rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter race_aty_appointed rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1, msymbol(D) mfcolor(none) ///
legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases with each lawyer type") subtitle("for White drivers") ytitle("Share of DWI filings") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/atytype_white, replace
graph export $tabfig/atytype_white.png, as(png) replace

scatter race_aty_hired rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1, msymbol(O) mfcolor(none) || ///
scatter race_aty_appointed rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1, msymbol(D) mfcolor(none) ///
legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases with each lawyer type") subtitle("for Hispanic drivers") ytitle("Share of DWI filings") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/atytype_hispanic, replace
graph export $tabfig/atytype_hispanic.png, as(png) replace


grc1leg $tabfig/atytype_white.gph $tabfig/atytype_hispanic.gph, ///
	iscale(.6) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon cols(2)
graph save $tabfig/hcatytype_byrace, replace
graph export $tabfig/hcatytype_byrace.png, as(png) replace




*** FIGURE: Case outcomes by attorney type
scatter aty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_hired==1, msymbol(O) mfcolor(none) || ///
scatter aty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_appointed==1, msymbol(D) mfcolor(none) ///
legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases that lead to DWI conviction") subtitle("by attorney type") ytitle("Share of DWI filings convicted") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_byaty, replace
graph export $tabfig/dwiconviction_byaty.png, as(png) replace






*** FIGURE: Filings and convictions by sex
// Source for added text syntax: https://www.statadaily.com/writing-greek-letters-and-other-symbols-in-graphs/
foreach i in 0 1	{
	qui reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & male==`i', robust
	local `r'b = round(e(b)[1,1], .001)
	local `r'sd = round(e(V)[1,1]^(1/2), .001)
}

	// The hispanicb local is displaying in the graph with lots of extra 0s and I don't know why.
scatter sex_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to DWI filing") subtitle("by BrAC and sex") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwifiling_bysex, replace
graph export $tabfig/dwifiling_bysex.png, as(png) replace	

scatter sex_any_charges rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_any_charges rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to any filing") subtitle("by BrAC and sex") ytitle("Share with charges filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/anyfiling_bysex, replace
graph export $tabfig/anyfiling_bysex.png, as(png) replace	


scatter sex_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to DWI conviction") subtitle("by BrAC and sex") ytitle("Share convicted of DWI") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_bysex, replace
graph export $tabfig/dwiconviction_bysex.png, as(png) replace	


scatter sex_any_conviction rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_any_conviction rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to any conviction") subtitle("by BrAC and sex") ytitle("Share with any conviction") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/anyconviction_bysex, replace
graph export $tabfig/anyconviction_bysex.png, as(png) replace	


/*
net install grc1leg,from( http://www.stata.com/users/vwiggins/) 
*/
grc1leg $tabfig/dwifiling_bysex.gph $tabfig/anyfiling_bysex.gph $tabfig/dwiconviction_bysex.gph $tabfig/anyconviction_bysex.gph, ///
	iscale(.5) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon
graph save $tabfig/hcfilingconv_bysex, replace
graph export $tabfig/hcfilingconv_bysex.png, as(png) replace




*** FIGURE: Incarceration and fines by sex
scatter sex_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to incarceration") subtitle("by BrAC and sex") ytitle("Share incarcerated") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/hassentenceincarc_bysex, replace
graph export $tabfig/hassentenceincarc_bysex.png, as(png) replace	


	
scatter sex_has_sentence_fine rounded_lowest_result if inrange(lowest_result,.03,.13) & male==1, msymbol(O) mfcolor(none) || ///
scatter sex_has_sentence_fine rounded_lowest_result if inrange(lowest_result,.03,.13) & male==0, msymbol(D) mfcolor(none) ///
	legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to fine") subtitle("by BrAC and sex") ytitle("Share fined") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/hassentencefine_bysex, replace
graph export $tabfig/hassentencefine_bysex.png, as(png) replace
	

grc1leg $tabfig/hassentenceincarc_bysex.gph $tabfig/hassentencefine_bysex.gph, ///
	iscale(.6) graphregion(margin(zero)) graphregion(fcolor(white)) ycommon cols(2)
graph save $tabfig/hcincarcfine_bysex, replace
graph export $tabfig/hcincarcfine_bysex.png, as(png) replace







	
	
	
	
* By sex	
scatter sex_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & sex=="M", msymbol(O) mfcolor(none) || ///
scatter sex_dwi rounded_lowest_result if inrange(lowest_result,.03,.13) & sex=="F", msymbol(D) mfcolor(none) ///
legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to DWI filing") subtitle("by BrAC and sex") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwifiling_bysex, replace
graph export $tabfig/dwifiling_bysex.png, as(png) replace


scatter sex_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & sex=="M", msymbol(O) mfcolor(none) || ///
scatter sex_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & sex=="F", msymbol(D) mfcolor(none) ///
legend(label(1 "Male") label(2 "Female")) title("Share of breath tests that lead to DWI filing") subtitle("by BrAC and sex") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_bysex, replace
graph export $tabfig/dwiconviction_bysex.png, as(png) replace
	
	
	
	
	
/*	
* By lawyer type
scatter aty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_hired==1, msymbol(O) mfcolor(none) || ///
scatter aty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_appointed==1, msymbol(D) mfcolor(none) ///
legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases that lead to DWI conviction") subtitle("by attorney type") ytitle("Share of DWI filings convicted") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_byaty, replace
graph export $tabfig/dwiconviction_byaty.png, as(png) replace

scatter mean_aty_hired rounded_lowest_result if inrange(lowest_result,.03,.13), msymbol(O) mfcolor(none) || ///
scatter mean_aty_appointed rounded_lowest_result if inrange(lowest_result,.03,.13), msymbol(D) mfcolor(none) || ///
scatter mean_any_aty rounded_lowest_result if inrange(lowest_result,.03,.13), msymbol(T) mfcolor(none) ///
legend(label(1 "Hired Attorney") label(2 "Appointed Attorney") label(3 "Any attorney")) title("Share of DWI cases with each lawyer type") ytitle("Share of DWI filings") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))

	
* By race and lawyer type
scatter raceaty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_hired==1 & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter raceaty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_hired==1 & likely_hispanic==1, msymbol(D) mfcolor(none) ///
legend(label(1 "White") label(2 "Hispanic")) title("Share of DWI cases that lead to DWI conviction") subtitle("by race for drivers with hired attorney") ytitle("Share of DWI filings convicted") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))


scatter raceaty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_appointed==1 & likely_white==1, msymbol(O) mfcolor(none) || ///
scatter raceaty_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & aty_appointed==1 & likely_hispanic==1, msymbol(D) mfcolor(none) ///
legend(label(1 "White") label(2 "Hispanic")) title("Share of DWI cases that lead to DWI conviction") subtitle("by race for drivers with appointed attorney") ytitle("Share of DWI filings convicted") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white))

*/
		
	
	
	
	
	
	
	

	
*** Regressions: Heterogeneity by race
* DWI conviction
regress dwiconviction hispanic_x_roundedresult3 hispanic_x_roundedresult4 hispanic_x_roundedresult5  hispanic_x_roundedresult6 hispanic_x_roundedresult7 hispanic_x_roundedresult8 hispanic_x_roundedresult9 hispanic_x_roundedresult10 hispanic_x_roundedresult11  hispanic_x_roundedresult12  hispanic_x_roundedresult13  rounded_lowest_result if (likely_white==1 | likely_hispanic==1) & inrange(rounded_lowest_result,.03,.13), robust

coefplot, keep(hispanic_x*) vertical rename(hispanic_x_roundedresult3 = ".03" hispanic_x_roundedresult4 = ".04" hispanic_x_roundedresult5 = ".05" hispanic_x_roundedresult6 = ".06" hispanic_x_roundedresult7 = ".07" hispanic_x_roundedresult8 = ".08" hispanic_x_roundedresult9 = ".09" hispanic_x_roundedresult10 = ".1" hispanic_x_roundedresult11 = ".11" hispanic_x_roundedresult12 = ".12" hispanic_x_roundedresult13 = ".13")


areg dwiconviction hispanic_x_roundedresult3 hispanic_x_roundedresult4 hispanic_x_roundedresult5  hispanic_x_roundedresult6 hispanic_x_roundedresult7 hispanic_x_roundedresult8 hispanic_x_roundedresult9 hispanic_x_roundedresult10 hispanic_x_roundedresult11  hispanic_x_roundedresult12  hispanic_x_roundedresult13  rounded_lowest_result if (likely_white==1 | likely_hispanic==1) & inrange(rounded_lowest_result,.03,.13), a(lawyer_id)

coefplot, keep(hispanic_x*) vertical rename(hispanic_x_roundedresult3 = ".03" hispanic_x_roundedresult4 = ".04" hispanic_x_roundedresult5 = ".05" hispanic_x_roundedresult6 = ".06" hispanic_x_roundedresult7 = ".07" hispanic_x_roundedresult8 = ".08" hispanic_x_roundedresult9 = ".09" hispanic_x_roundedresult10 = ".1" hispanic_x_roundedresult11 = ".11" hispanic_x_roundedresult12 = ".12" hispanic_x_roundedresult13 = ".13")





* Having an appointed attorney
regress aty_appointed hispanic_x_roundedresult3 hispanic_x_roundedresult4 hispanic_x_roundedresult5  hispanic_x_roundedresult6 hispanic_x_roundedresult7 hispanic_x_roundedresult8 hispanic_x_roundedresult9 hispanic_x_roundedresult10 hispanic_x_roundedresult11  hispanic_x_roundedresult12  hispanic_x_roundedresult13  rounded_lowest_result if (likely_white==1 | likely_hispanic==1) & inrange(rounded_lowest_result,.03,.13), robust

coefplot, keep(hispanic_x*) vertical rename(hispanic_x_roundedresult3 = ".03" hispanic_x_roundedresult4 = ".04" hispanic_x_roundedresult5 = ".05" hispanic_x_roundedresult6 = ".06" hispanic_x_roundedresult7 = ".07" hispanic_x_roundedresult8 = ".08" hispanic_x_roundedresult9 = ".09" hispanic_x_roundedresult10 = ".1" hispanic_x_roundedresult11 = ".11" hispanic_x_roundedresult12 = ".12" hispanic_x_roundedresult13 = ".13")


	

/*
scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_white==1, msymbol(O) || ///
scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_hispanic==1, msymbol(D) || ///
	scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.03,.13) & likely_black==1, msymbol(T) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of DWI cases that end in conviction") subtitle("by BrAC and lawyer type") ytitle("Share convicted (cond. on filing)") xtitle("Lowest measured BrAC") xlabel(.08(.01).13) graphregion(fcolor(white))

	

reg dwiconviction lowest_result likely_black likely_hispanic if inrange(lowest_result,.08,.15) & (likely_black==1 | likely_white==1 | likely_hispanic==1) & aty_hired!=.

reg dwiconviction lowest_result likely_black likely_hispanic aty_hired if inrange(lowest_result,.08,.15) & (likely_black==1 | likely_white==1 | likely_hispanic==1)





use "$clean_dir/dui_hc_merged.dta", clear

* Clean up and generate a few variables (move this to merge code)
foreach var in sentence_incarcmonths sentence_probation sentence_fine	{
    
	replace `var' = 0 if `var'==.
	gen has_`var' = `var' > 0
	
}


* Regressions
gen above_limit = lowest_result>=.08
gen above_limitxresult = above_limit*lowest_result

gen index = lowest_result - .08
gen interact = above_limit*index


// Why are the estimates for these two regressions different?
reg dwi above_limit lowest_result above_limitxresult if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)

reg dwiconviction above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)


reg sentence_incarcmonth above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg has_sentence_incarcmonths above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg has_sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)
reg has_sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079)



reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & sex=="M"
reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & sex=="F"



reg dwiconviction above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg dwiconviction above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg sentence_incarcmonth above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg sentence_incarcmonth above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg has_sentence_incarcmonths above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg has_sentence_incarcmonths above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg has_sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg has_sentence_probation above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"


reg has_sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="white"
reg has_sentence_fine above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079) & f_likely_race=="hispanic"




* Figures
foreach var in dwi dwiconviction sentence_incarcmonths sentence_fine sentence_probation has_sentence_incarc has_sentence_fine has_sentence_probation	{
    
	bys lowest_result: egen mean_`var' = mean(`var')
	
}



scatter mean_dwi lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to DWI filing") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08)
graph save $tabfig/dwifiling, replace
graph export $tabfig/dwifiling.png, as(png) replace


scatter mean_dwiconviction lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to DWI conviction") ytitle("Share convicted for DWI") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08)
graph save $tabfig/dwiconviction, replace
graph export $tabfig/dwiconviction.png, as(png) replace


scatter mean_has_sentence_incarc lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to incarceration") ytitle("Share incarcerated") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08)
graph save $tabfig/hassentenceincarc, replace
graph export $tabfig/hassentenceincarc.png, as(png) replace


scatter mean_has_sentence_fine lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to fine") ytitle("Share fined") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08)
graph save $tabfig/hassentencefine, replace
graph export $tabfig/hassentencefine.png, as(png) replace


scatter mean_has_sentence_probation lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to probation") ytitle("Share with probation") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08)
graph save $tabfig/hassentenceprobation, replace
graph export $tabfig/hassentenceprobation.png, as(png) replace



scatter mean_dwi lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)

scatter mean_dwiconviction lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_sentence_incarc lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_has_sentence_incarc lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_sentence_fine lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_has_sentence_fine lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_sentence_probation lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)
scatter mean_has_sentence_probation lowest_result if inrange(lowest_result,.03,.13), xline(.07 .08)





* Now look at just people with lawyer info
keep if (aty_appointed==1 | aty_hired==1) & dwi==1

use "$clean_dir/dui_hc_merged.dta", clear

* Clean up and generate a few variables (move this to merge code)
foreach var in sentence_incarcmonths sentence_probation sentence_fine	{
    
	replace `var' = 0 if `var'==.
	gen has_`var' = `var' > 0
	
}


* Regressions
gen above_limit = lowest_result>=.08
gen above_limitxresult = above_limit*lowest_result

gen index = lowest_result - .08
gen interact = above_limit*index


* Figures
gen rounded_lowest_result = floor(lowest_result*100)/100

foreach var in dwiconviction sentence_incarcmonths sentence_fine sentence_probation has_sentence_incarc has_sentence_fine has_sentence_probation	{
    
	bys rounded_lowest_result aty_hired: egen mean_`var' = mean(`var')
	
}


scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & aty_hired==1, msymbol(O) || ///
	scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & aty_appointed==1, msymbol(T) legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases that end in conviction") subtitle("by BrAC and lawyer type") ytitle("Share convicted (cond. on filing)") xtitle("Lowest measured BrAC") xlabel(.08(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_bylawyer, replace
graph export $tabfig/dwiconviction_bylawyer.png, as(png) replace

	
scatter mean_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.08,.13) & aty_hired==1, msymbol(O) || ///
	scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & aty_appointed==1, msymbol(T) legend(label(1 "Hired Attorney") label(2 "Appointed Attorney")) title("Share of DWI cases that result in incarceration") subtitle("by BrAC and lawyer type") ytitle("Share incarcerated (cond. on filing)") xtitle("Lowest measured BrAC") xlabel(.08(.01).13) graphregion(fcolor(white))
graph save $tabfig/hassentence_bylawyer, replace
graph export $tabfig/hassentence_bylawyer.png, as(png) replace


* Now look at outcomes for filed cases by race (for first time DWIs)
use "$clean_dir/dui_hc_merged.dta", clear

keep if (def_rac=="B" | def_rac=="W") & dwi==1 & priordwis==0

gen race_category = ""
	replace race_category = "hispanic" if f_likely_race=="hispanic" & l_likely_race=="hispanic" & def_rac=="W"
	replace race_category =  "white" if def_rac=="W" & race_category!="hispanic"
	replace race_category = "black" if def_rac=="B"



* Clean up and generate a few variables (move this to merge code)
foreach var in sentence_incarcmonths sentence_probation sentence_fine	{
    
	replace `var' = 0 if `var'==.
	gen has_`var' = `var' > 0
	
}


* Regressions
gen above_limit = lowest_result>=.08
gen above_limitxresult = above_limit*lowest_result

gen index = lowest_result - .08
gen interact = above_limit*index


* Figures
gen rounded_lowest_result = floor(lowest_result*100)/100

foreach var in dwiconviction sentence_incarcmonths sentence_fine sentence_probation has_sentence_incarc has_sentence_fine has_sentence_probation	{
    
	bys rounded_lowest_result race_category: egen mean_`var' = mean(`var')
	
}


scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="white", msymbol(O) || ///
scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="hispanic", msymbol(D) || ///
scatter mean_dwiconviction rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="black", msymbol(T) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of DWI cases that end in conviction") subtitle("by BrAC and lawyer type") ytitle("Share convicted (cond. on filing)") xtitle("Lowest measured BrAC") xlabel(.08(.01).13) graphregion(fcolor(white))
graph save $tabfig/dwiconviction_byrace, replace
graph export $tabfig/dwiconviction_byrace.png, as(png) replace
	
	
	
	
	
scatter mean_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="white", msymbol(O) || ///
scatter mean_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="hispanic", msymbol(D) || ///
	scatter mean_has_sentence_incarc rounded_lowest_result if inrange(lowest_result,.08,.13) & race_category=="black", msymbol(T) legend(label(1 "White") label(2 "Hispanic") label(3 "Black")) title("Share of DWI cases that end in conviction") subtitle("by BrAC and lawyer type") ytitle("Share convicted (cond. on filing)") xtitle("Lowest measured BrAC") xlabel(.08(.01).13) graphregion(fcolor(white)) 
graph save $tabfig/hassentence_byrace, replace
graph export $tabfig/hassentence_byrace.png, as(png) replace




