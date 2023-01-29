
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Reescaled tool share using measures from 1977 Dictionary of Occupational Titles
(DOT)
********************************************/

	
*********************************************************************
		
*DOT data
use "$raw_data/DOT_1977/equiptment_nipa_of_occ1990dd_full_inCW_adj.dta",clear



** adjust counts in occupation 628 to match the average in the 1-digit occupation (for computers and other equipment)
**only uses computers
su count_t_t_4 if occ1d==10
replace count_t_t_4=r(mean) if occ1990dd == 628

* Assign the computer tool usage to software. instead of zeros.

replace count_t_t_99=count_t_t_4
keep occ1990dd count_t*


foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'=0 if count_`var'==.
ren count_`var' count_`var'_1980
egen totcount_`var'_1980=total(count_`var'_1980)
}

save "$intermediate_data/[5]base_1980.dta",replace



use "$intermediate_data/[1]equiptment_nipa_of_occ1990dd.dta",clear
keep occ* count_t*
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'=0 if count_`var'==.
ren count_`var' count_`var'_2016
egen totcount_`var'_2016=total(count_`var'_2016)
}
save "$intermediate_data/[5]base_2016.dta",replace

use "$intermediate_data/[5]base_1980.dta",clear
drop if occ1990dd==.




merge 1:1 occ1990dd using "$intermediate_data/[5]base_2016.dta", gen (_mergeDOTONET)

foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'_1980=count_`var'_1980/totcount_`var'_1980*totcount_`var'_2016
}
*
*
forvalues i=1981(1)2015{
local j=`i'-1
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
gen count_`var'_`i'=.
replace count_`var'_`i'=count_`var'_`j'+(count_`var'_2016-count_`var'_1980)/36 if _mergeDOTONET==3

replace count_`var'_`i'=count_`var'_2016 if _mergeDOTONET==2

}

}
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'_1980=count_`var'_2016 if _mergeDOTONET==2
}


reshape long count_t_t_4_ count_t_t_5_ count_t_t_6_ count_t_t_9_ count_t_t_10_ count_t_t_11_ count_t_t_13_ count_t_t_14_ count_t_t_17_ count_t_t_18_ count_t_t_19_ count_t_t_20_ count_t_t_26_ count_t_t_27_ count_t_t_28_ count_t_t_29_ count_t_t_30_ count_t_t_33_ count_t_t_36_ count_t_t_39_ count_t_t_40_ count_t_t_41_ count_t_t_99_ count_t_t_2225_, i(occ1990dd) j(year)


foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
ren count_`var'_ count_`var'
}


drop tot*
save "$intermediate_data/[5]base_all_rescaled.dta",replace


keep if year==1985
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
ren count_`var' count_`var'_
}
reshape wide count_*, i(occ1990dd) j(year)
save "$intermediate_data/[5]base_1985.dta",replace


use "$intermediate_data/[5]base_all_rescaled.dta",clear
keep if year==2003
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
ren count_`var' count_`var'_
}
reshape wide count_*, i(occ1990dd) j(year)
save "$intermediate_data/[5]base_2003.dta",replace




*********************************1980
**** DATA FOR COUNT PICTURE
use "$intermediate_data/[5]base_1980.dta",clear
drop if occ1990dd==.
merge 1:1 occ1990dd using "$intermediate_data/[5]base_2016.dta", gen (_mergeDOTONET)


* RE-SCALE COUNTS in 1980 so the total count is comparable to 2016

foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'_1980=count_`var'_1980/totcount_`var'_1980*totcount_`var'_2016
}
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
replace count_`var'_1980=count_`var'_2016 if _mergeDOTONET==2
}


ren occ1990dd occ2d
 gen occ1d  = .
		replace occ1d = 1 if occ2d >= 4 & occ2d <= 37
		replace occ1d = 2 if occ2d >= 43 & occ2d <= 199
		replace occ1d = 3 if occ2d >= 203 & occ2d <= 235
		replace occ1d = 4 if occ2d >= 243 & occ2d <= 285
		replace occ1d = 5 if occ2d >= 303 & occ2d <= 389
		replace occ1d = 6 if occ2d >= 405 & occ2d <= 471
		replace occ1d 	= 7 if occ2d >= 472 & occ2d <= 498
		replace occ1d = 8 if occ2d >= 503 & occ2d <= 599
		replace occ1d = 9 if occ2d >= 614 & occ2d <= 617
		replace occ1d = 10 if occ2d >= 628 & occ2d <= 696
		replace occ1d = 11 if occ2d >= 699 & occ2d <= 799
		replace occ1d = 12 if occ2d >= 803 & occ2d <= 889
		
		drop if occ1d==7 | occ1d==9
		replace occ1d=7 if occ1d==8
		replace occ1d=8 if occ1d==10
		replace occ1d=9 if occ1d==11
		replace occ1d=10 if occ1d==12
		
		replace occ1d=7 if occ1d==10
		
		preserve
		
		collapse (sum) count_*, by(occ1d)
		
		foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
egen totcount_`var'_2016=total(count_`var'_2016)
egen totcount_`var'_1980=total(count_`var'_1980)
}

		foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
gen share_`var'_1980=count_`var'_1980/totcount_`var'_1980
gen share_`var'_2016=count_`var'_2016/totcount_`var'_2016
}

		keep share_* occ1d 
reshape long share_t_t_4_ share_t_t_5_ share_t_t_6_ share_t_t_9_ share_t_t_10_ share_t_t_11_ share_t_t_13_ share_t_t_14_ share_t_t_17_ share_t_t_18_ share_t_t_19_ share_t_t_20_ share_t_t_26_ share_t_t_27_ share_t_t_28_ share_t_t_29_ share_t_t_30_ share_t_t_33_ share_t_t_36_ share_t_t_39_ share_t_t_40_ share_t_t_41_ share_t_t_99_ share_t_t_2225_, i(occ1d) j(year)

export excel using "$model_data/tool_shares.xlsx", sheet("tool_share") sheetreplace firstrow(variables)
restore
	
	
	
