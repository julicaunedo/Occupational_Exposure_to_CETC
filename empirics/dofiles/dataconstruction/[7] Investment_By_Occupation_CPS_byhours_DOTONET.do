
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Takes employment and wage series by year and 3 digit occupation, and
merge with tools and investment to generate investment series for the construction of stocks


Data comes from previous files
********************************************/



* Loop by year 

foreach i of numlist 1983(1)2016{
	
	use "$intermediate_data/[6]employmentCPS_`i'_byhours.dta",clear	



***II.2 EQUIPMENT BY OCCUPATIONS ****
	* Merge with tool data
	capture drop _merge
		merge m:1 occ1990dd year using "$intermediate_data/[5]base_all_rescaled.dta"

	drop if year~=`i'
	



		replace total_hours=1
		
	bys occ1d: egen tot_count_4=total(count_t_t_4)



preserve
collapse (sum) count_t_t_4 count_t_t_5 count_t_t_6 count_t_t_9 count_t_t_10 count_t_t_11 count_t_t_13 count_t_t_14 count_t_t_17 count_t_t_18 count_t_t_19 count_t_t_20 count_t_t_26 count_t_t_27 count_t_t_28 count_t_t_29 count_t_t_30 count_t_t_33 count_t_t_36 count_t_t_39 count_t_t_40 count_t_t_41 count_t_t_99 count_t_t_2225, by(occ2d year)

foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
sum count_`var'                         // Total tools in an occupations
			gen prop_tools_`var' = count_`var'/r(sum)     // prportion of tools in each occupation
			
			sum prop_tools_`var'
			if r(sum)<1{
			replace prop_tools_`var'=prop_tools_`var'/r(sum)
			}
			}
keep prop_tools_* occ2d year
	save "$intermediate_data/[7]tool_count_requirements_`i'.dta", replace
restore


		collapse (sum) count_t_t_4 count_t_t_5 count_t_t_6 count_t_t_9 count_t_t_10 count_t_t_11 count_t_t_13 count_t_t_14 count_t_t_17 count_t_t_18 count_t_t_19 count_t_t_20 count_t_t_26 count_t_t_27 count_t_t_28 count_t_t_29 count_t_t_30 count_t_t_33 count_t_t_36 count_t_t_39 count_t_t_40 count_t_t_41 count_t_t_99 count_t_t_2225 total_hours (mean) total_workers low_skill_workers* high_skill_workers* wage wage_low wage_high wage_predicted* female_workers age_25_34 age_35_44 age_45_55 labor_inc nominal_labor_inc [pw=hperwt], by(occ2d year)
		
		preserve 
		keep count_* total_hours occ2d year 
		save  "$intermediate_data/[7]counts_weighted_byhours_`i'.dta", replace
		restore 
		
		

	duplicates tag occ2d, gen(fg)
	
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
		replace occ1d = 8 if occ2d >= 803 & occ2d <= 889
		drop if occ1d == . // drop military occupations 
		
		
	* label data
		label var count_t_t_4  "Computers and peripheral"
		label var count_t_t_5  "Communication"
		label var count_t_t_6  "Medical instruments"
		label var count_t_t_9  "Nonmedical instruments"
		label var count_t_t_10  "Photocopy equip"
		label var count_t_t_11  "Office and accounting equip"
		*label var count_t_t_12  "Industrial equip"
		label var count_t_t_13  "Fabricated metal products"
		label var count_t_t_14  "Engines and turbines"
		label var count_t_t_17  "Metalworking machinery"
		label var count_t_t_18  "Special industry machinery"
		label var count_t_t_19  "General industry mach"
		label var count_t_t_20  "Electrical transmision"
		*label var count_t_t_21  "Transposrtation equip"
		label var count_t_t_26  "Aircraft"
		label var count_t_t_27  "Ships and boats"
		label var count_t_t_28  "Railroad"
		label var count_t_t_29  "Other equip"
		label var count_t_t_30  "Furniture"
		label var count_t_t_33  "Agricultural machinery"
		label var count_t_t_36  "Construction machinery"
		label var count_t_t_39  "Mining machinery"
		label var count_t_t_40  "Service machinery"
		label var count_t_t_41  "Electrical equip"
		label var count_t_t_99  "Software"
		label var count_t_t_2225  "Truks,cars"


	
	* Generatest to proportion of tools in ach occupation 
	* t_t_99
		foreach var in t_t_4 t_t_5 t_t_6 t_t_9 t_t_10 t_t_11 t_t_13 t_t_14 t_t_17 t_t_18 t_t_19 t_t_20 t_t_26 t_t_27 t_t_28 t_t_29 t_t_30 t_t_33 t_t_36 t_t_39 t_t_40 t_t_41 t_t_99 t_t_2225{
			
				if year==1983{
					bys occ1d: egen level_`var'_80=total(count_`var')
					tempfile levelcontrol_`var'
					replace level_`var'_80=1 if level_`var'_80==0
					preserve 
					keep level_`var'_80 occ1d
					save  "`levelcontrol_`var''", replace
					restore
				}
				
				if year<1983{
				sum count_`var'                         // Total tools in an occupations
				gen prop_`var' = count_`var'/r(sum)     // prportion of tools in each occupation
				 
				}
				
				if year>=1983{
				
				sort occ1d
				merge occ1d using `levelcontrol_`var''
				drop _merge
				bys occ1d: egen level_`var'=total(count_`var')
				replace level_`var'=1 if level_`var'==0
				gen count_adj_`var'=count_`var'*level_`var'_80/level_`var'
				sum count_adj_`var'
				gen prop_adj_`var'=count_adj_`var'/r(sum)
				
				sum count_`var'                         // Total tools in an occupations
				gen prop_`var' = count_`var'/r(sum)     // prportion of tools in each occupation
				}
				
				**sets the share to 1
				sum prop_`var'
				if r(sum)<1{
				replace prop_`var'=prop_`var'/r(sum)
				}
				sum prop_adj_`var'
				if r(sum)<1{
				replace prop_adj_`var'=prop_adj_`var'/r(sum)
				}
			
			}
		
				bys year: egen tot_prop_t_t_27=total(prop_t_t_27)
		su tot_prop_t_t_27
	
		duplicates tag occ2d, gen(fgp)
		
		su occ2d if fg==1
		duplicates drop occ2d, force
		sort occ2d year
		
		preserve
		keep prop_t_t_* occ2d year
		save "$intermediate_data/[7]tool_requirements_`i'.dta", replace
		restore
		
		preserve
		keep count_t_t_* prop_t_t_* occ2d
	
		reshape long count_t_t_ prop_t_t_,  i(occ2d) j(nipa_code)
		tempfile temp
    	save `temp', replace
    	restore
		
		preserve
		keep occ2d count_adj_t_t_* prop_adj_t_t_*
		
		reshape long count_adj_t_t_ prop_adj_t_t_,  i(occ2d) j(nipa_code)

		tempfile tempadj
    	save `tempadj', replace
    	restore
		
	
    	keep occ2d year total_workers low_skill_workers* high_skill_workers* wage* female_workers age* labor_inc nominal_labor_inc total_hours
		
		
		merge 1:m occ2d using `temp'
		keep if _merge == 3
		drop _merge
		merge 1:1 occ2d nipa_code using `tempadj'
				bys nipa_code year: egen tot_prop_t_t_=total(prop_t_t_)
		bys nipa_code: su tot_prop_t_t_
		su _merge
	
		keep if _merge == 3
		drop _merge

	*** Merge with investment data***
		merge m:1 year nipa_code using "$intermediate_data/[4]Investment_quantity_long.dta"
		*ren quantity_inv equip_
		tab nipa_code if _merge==2
		
		drop if _merge == 2

	* Reshape to have it by NIPA code

	* Investment in each occupation by equipment
           drop wage_predicted
		   drop tot_prop*
		bys nipa_code year: egen tot_prop_t_t_=total(prop_t_t_)
		bys nipa_code: su tot_prop_t_t_
		bys nipa_code: su prop_t_t_

		   
		   saveold "$intermediate_data/[7]investmentCPS_by_occ_`i'_DOTONET.dta", replace
	  
		   }

		  
		  
	* Save data with stock per worker
use  "$intermediate_data/[7]investmentCPS_by_occ_1983_DOTONET.dta", replace
forv t = 1984(1)2016{

	append using  "$intermediate_data/[7]investmentCPS_by_occ_`t'_DOTONET.dta"
}
saveold  "$intermediate_data/[7]investmentCPS_by_occ_allyear_DOTONET.dta", replace
drop _merge

use  "$intermediate_data/[7]tool_count_requirements_1983.dta", replace
forv t = 1984(1)2016{

	append using  "$intermediate_data/[7]tool_count_requirements_`t'.dta"
}
saveold  "$intermediate_data/[7]tool_count_requirements_all.dta", replace

