/*********************************************************************

*	Occupational exposure to capital-embodied technical change

 Computes computer use data from IPUMS, generates computer use statitics by occ2d for years 84-89-93-97-01-03
********************************************/



**** DATA FOR COUNT PICTURE


*
********
* use the counts wieghted by hours from [7]
*****
use "$intermediate_data/[7]counts_weighted_byhours_1985.dta", clear
append using "$intermediate_data/[7]counts_weighted_byhours_2003.dta"
append using "$intermediate_data/[7]counts_weighted_byhours_2016.dta"
drop total_hours
foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
ren count_`var' count_`var'_
}

reshape wide count_*, i(occ2d) j(year)

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

		
		collapse (sum) count_*, by(occ1d)
		
		foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
egen totcount_`var'_2016=total(count_`var'_2016)
egen totcount_`var'_2003=total(count_`var'_2003)
egen totcount_`var'_1985=total(count_`var'_1985)
}

		foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
gen share_`var'_1985=count_`var'_1985/totcount_`var'_1985
gen share_`var'_2003=count_`var'_2016/totcount_`var'_2003
gen share_`var'_2016=count_`var'_2016/totcount_`var'_2016
}

		keep share_* occ1d 
reshape long share_t_t_4_ share_t_t_5_ share_t_t_6_ share_t_t_9_ share_t_t_10_ share_t_t_11_ share_t_t_13_ share_t_t_14_ share_t_t_17_ share_t_t_18_ share_t_t_19_ share_t_t_20_ share_t_t_26_ share_t_t_27_ share_t_t_28_ share_t_t_29_ share_t_t_30_ share_t_t_33_ share_t_t_36_ share_t_t_39_ share_t_t_40_ share_t_t_41_ share_t_t_99_ share_t_t_2225_, i(occ1d) j(year)

save "$intermediate_data/[18]shares_tools_forpicture_weightedmean.dta",replace



*** Data on computer use from CPS


use  "$raw_data/IPUMS_CPS/cps_00012_computer_use.dta", clear

* drop 2001, not used by BMV
drop if year == 2001
 
** 1) Trimming the sample by hours and wage
 
	*1.a 
	gen hours = .
	replace hours= uhrsworkt   if uhrsworkt~=999 & uhrsworkt~=997  // Only information of usual hours at work
	replace hours = 80 if uhrsworkt > 80 & uhrsworkt~=999 & uhrsworkt~=997

	**Autor (2015) Adjustment Figure4
	*48+ annual weeks worked and 35+ usual weekly hours.
	*keep if wkswork1>=48  // this information do not exist in the sample
	keep if hours>=35

	*1.b age and employment
	keep if age >=16 & age <= 65
	keep if empstat == 10 | empstat == 10 //  At work or Has job, not at work last week (only ones responding the computer module) 

	
	
** 2) merge with occupations 	
	*2.a) 84 and 89 
	    merge m:1 occ using "$raw_data/Crosswalks/occ1980_occ1990dd.dta"
		rename occ1990dd occ1990dd_80
		
		
	* 2.2) 93 and 97
		drop _merge
		merge m:1 occ using "$raw_data/Crosswalks/occ1990_occ1990dd.dta"
		rename occ1990dd occ1990dd_90
			
	*2.3) 2003		
		drop _merge
		replace occ = occ/ 10
		merge m:1 occ using "$raw_data/Crosswalks/occ2000_occ1990dd.dta"
		rename occ1990dd occ1990dd_03
		
				
		
	gen occ1990dd = occ1990dd_80 if year == 1984 | year == 1989
	replace occ1990dd = occ1990dd_90 if year == 1993 | year == 1997
	replace occ1990dd = occ1990dd_03 if year == 2003 

	drop occ1990dd_80 occ1990dd_90  occ1990dd_03
	
	**** Change name of three occuaptions for which we do ot have many years of data
	/*
	489 Inspectors of agricultural products to  36 Inspectors and compliance officers, outside 
	462 Ushers to 459 Recreation facility attendants 
	583 Paperhangers to  599 Misc. construction and related occupations
	*/
	
	replace occ1990dd = 36 if occ1990dd == 489
	replace occ1990dd = 459 if occ1990dd == 462
	replace occ1990dd = 599 if occ1990dd == 583

	
	gen occ2d = occ1990dd
	
** 3) Computer use variable
 
	gen computer_use = 1 if ciwrkcmp == 2
	replace computer_use = 0 if ciwrkcmp == 1
	
	table year, c(mean computer_use)
 
 
 ** 4) collapse data
 
	gen hperwt = hours/40*cisuppwt  // cisuppwt: weight for computer use module // not information on weeks worked
 
	egen total_hours = sum(hperwt), by(occ2d year)
	
	gen hours_computers = 0 
	replace hours_computers = hours/40*cisuppwt if computer_use == 1
	egen total_hours_computers = sum(hours_computers), by(occ2d year)
 
	gen share_computer = total_hours_computers  /  total_hours 
	
	keep share_computer occ2d year  total_hours_computers total_hours 
	
	duplicates drop
	
	save "$intermediate_data/[18]Computer_use_by_occ2", replace

*/	
	
** 5) Merge with capital stock in computers per worker 

**THIS IS NOT REALLY NEEDED, ONLY TO MERGE THE 3-DIGITS appropriately.. the data is never used
use "$intermediate_data/[7]investmentCPS_by_occ_allyear_DOTONET.dta", clear
 
* Keep computers 
keep if   nipa_code == 4

* Keep relevant years
keep if year == 1984 | year == 1989 | year == 1993  | year == 1997 | year == 2003     
  
  
* Proportion of tolls
gen total_tools = count_t_t_/ total_hours 

keep  total_tools occ2d year count_t_t_ prop_t_t_
 
 
 ** 6) Merge tool and computer use
 merge 1:1 occ2d year using "$intermediate_data/[18]Computer_use_by_occ2"
 keep if _merge == 3
 
 gen aux= 1 
 egen count = sum(aux), by(occ2d)
 
 drop if count !=5
 
 

 
 egen aux2 = sum( total_hours_computers), by(year)
 gen prop_computers = total_hours_computers / aux2 *100
 
 replace prop_t_t_ = prop_t_t_ *100
 

 
 
*=============================================================================
* Classiffy 3 digit occ into 1 digit occupations
*=============================================================================


 gen occ1d  = .
replace occ1d = 1 if occ2d >= 4 & occ2d <= 37
replace occ1d = 2 if occ2d >= 43 & occ2d <= 199
replace occ1d = 3 if occ2d >= 203 & occ2d <= 235
replace occ1d = 4 if occ2d >= 243 & occ2d <= 285
replace occ1d = 5 if occ2d >= 303 & occ2d <= 389
replace occ1d = 6 if occ2d >= 405 & occ2d <= 471
replace occ1d = 7 if occ2d >= 472 & occ2d <= 498
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

collapse (sum) prop_computers, by(occ1d  year) 

replace year = 1985 if year  == 1984

merge 1:1 occ1d  year using "$intermediate_data/[18]shares_tools_forpicture_weightedmean.dta"

keep if _merge == 3 
keep occ1d year share_t_t_4_  prop_computers
replace prop_computers = prop_computers /100

	export excel using "$model_data/tool_shares.xlsx", sheet("computer_use") sheetreplace firstrow(variables)

