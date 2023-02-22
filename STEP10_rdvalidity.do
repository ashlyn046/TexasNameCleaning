
**Root directory--This is all that needs to be changed across users
*global root_dir "/Users/ll263/Library/CloudStorage/Box-Box/DUI/texas"
global root_dir C:/Users/andersee/Box/DUI/texas


global int_dir "$root_dir/intermediate_data"
global clean_dir "$root_dir/clean_data"
global tabfig  "$root_dir/tabfig"



clear all
set more off


* Read in merged data
//use $clean_dir/allmerged, clear
use "$int_dir/texas_breath_tests_uniqueincident", clear



*** FIGURE: HISTOGRAM OF BrAC VALUES ***
qui rddensity dui_lowest_vresult if dui_lowest_vresult>0, c(.08) plot
local p = round(e(pv_q),.001)

hist dui_lowest_vresult, frac ytitle("Share of breath tested drivers") xtitle("Lowest measured BrAC") graphregion(fcolor(white)) /*xline(.03 .13, lpattern(dash))*/ xline(.08) fcolor(%90) text(.01 .35 "manipulation test p = `p'")
graph save $tabfig/histofbrac, replace
graph export $tabfig/histofbrac.png, as(png) replace





/*

qui reg dwi above_limit index interact if inrange(lowest_result,.03,.13) & !inrange(lowest_result,.07,.079), robust
local b = round(e(b)[1,1], .001)
local sd = round(e(V)[1,1]^(1/2), .001)

scatter mean_dwi lowest_result if inrange(lowest_result,.03,.13), title("Share of breath tests that lead to DWI filing") ytitle("Share with DWI filed") xtitle("Lowest measured BrAC") xlabel(.03(.01).13) graphregion(fcolor(white)) xline(.07 .08) msize(vsmall) text(.1 .12 "{&beta} = `b' (`sd')") 
graph save $tabfig/dwifiling, replace
graph export $tabfig/dwifiling.png, as(png) replace

*/



*** TABLE: RD RESULTS FOR PRE-DETERMINED CHARACTERISTICS
use "$clean_dir/dui_hc_merged.dta", clear

** Make rounded BrAC for binning
gen double rounded_lowest_result = floor(dui_lowest_vresult*100)/100


** Make vars for regressions
* Make RD vars (2 ways)
gen above_limit = dui_lowest_vresult>=.08
gen above_limitxresult = above_limit*dui_lowest_vresult

gen index = dui_lowest_vresult - .08
gen interact = above_limit*index


gen dui_male = dui_sex=="M"




*** With doughnut
reg dui_male above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
eststo ymale

reg likely_black above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
eststo yblack

reg likely_hispanic above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
eststo yhisp

reg dui_age above_limit index interact if inrange(dui_lowest_vresult,.03,.13) & !inrange(dui_lowest_vresult,.07,.079), robust
eststo age


esttab ymale yblack yhisp age using $tabfig/dnutrd_predet_characteristics.tex, replace ///
	keep(above_limit) varlabels(above_limit "BrAC $\geq$ .08") ///
	collabels(,none) mtitles("Male" "Black" "Hispanic" "Age") ///
	cells(b(fmt(3)) se(par fmt(3))) ///
	noobs f booktabs
	
*** Without doughnut
reg dui_male above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust
eststo ymale

reg likely_black above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust
eststo yblack

reg likely_hispanic above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust
eststo yhisp

reg dui_age above_limit index interact if inrange(dui_lowest_vresult,.03,.13), robust
eststo age


esttab ymale yblack yhisp age using $tabfig/rd_predet_characteristics.tex, replace ///
	keep(above_limit) varlabels(above_limit "BrAC $\geq$ .08") ///
	collabels(,none) mtitles("Male" "Black" "Hispanic" "Age") ///
	cells(b(fmt(3)) se(par fmt(3))) ///
	noobs f booktabs