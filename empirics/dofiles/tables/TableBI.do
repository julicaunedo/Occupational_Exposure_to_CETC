/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates Table B.I: CETC and changes in the labor market 1984-2015.

Data from previous files 
********************************************/



* Program to estimate Cuantiles 

use "$final_data/[10]stocks_occuCPS_2020_DOTONET_base85.dta", clear



	ren stock_per_worker_all stock_per_worker
	ren stock_per_worker_COMPUTERS computers
	ren stock_per_worker_HCETC high_chage_equip
	ren stock_per_worker_LCETC low_change_equip
	ren stock_all total_stock 

*** Generate employment shares ***
egen total = sum(total_workers), by(year)
egen total_low = sum(low_skill_workers), by(year)
egen total_high = sum(high_skill_workers), by(year)



gen employ = total_workers/total
gen employ_low = low_skill_workers/total_low
gen employ_high = high_skill_workers/total_high	
gen employ_sh_high = high_skill_workers/total_workers	


gen employ_sh_fem = female_workers/total_workers	


drop total total_low total_high 	

*** Replace with a positive values the zeros so that they are not dropped
foreach var in computers stock_per_worker high_chage_equip low_change_equip {
	sum `var' 
	replace `var' = 0.00001 if `var' == 0 | (`var' == . & total_stock !=.) 
}

drop total_stock
ren stock_per_worker total_stock

keep employ_sh_high employ_sh_fem total_workers low_skill_workers high_skill_workers wage computers total_stock high_chage_equip low_change_equip employ employ_low employ_high year occ2d 


reshape  wide employ_sh_high employ_sh_fem total_workers low_skill_workers high_skill_workers wage computers total_stock high_chage_equip low_change_equip employ employ_low employ_high , j(year) i(occ2d)	





******************************************************************************	
*Block 1) Build Variables
******************************************************************************	


*1) Variables to classiy occupations
	*1.a total changes in stock of capital and tasks measures 
	gen diff5 =  ((total_stock2016/total_stock1985)^(1/31)-1)*100


	*1.b Stock of computers
	gen comp5 =  computers2016/total_stock2016


	*1.c total changes in high_change_equip
	gen high_eq5 =  high_chage_equip2016/total_stock2016

	*1.d total changes in low_change_equip
	gen low_eq5 =  low_change_equip2016/total_stock2016


	* Clean data from occupations that do not have data on any equipment
	egen aux3 =rsum(high_eq5 comp5 low_eq5)
	drop if aux3 > 2
	drop aux3

* 2) Outcomes 

	*2.a) Chnges in wages
	gen wage5 =  ((wage2016/wage1985)^(1/31)-1)*100

	gen wage5t =  ((wage2016/wage1985)-1)*100
	
	*2.b) Changes in employment
	gen sh_employ5 =  (employ2016-employ1985)*100
	summ sh_employ5 
	replace sh_employ5= sh_employ5 - r(mean) // normalize it so that total changes equal zero
	

	*2.c) Changes in the share of high educated 
	* generate skill bias employment change
	gen skill_bias5= (employ_sh_high2016-employ_sh_high1985)*100

	*2.d) Share Females
	* generate skill bias employment change
	gen gender_bias5= (employ_sh_fem2016-employ_sh_fem1985)*100


* 3) Bild cathegories to separete occupations in terciles


* Cuantiles 

pctile aux= diff5, n(3) 
xtile cetc_3c = diff5, cut(aux)
drop aux

pctile aux= comp5, n(3) 
xtile comp_3c = comp5, cut(aux)
drop aux


pctile aux= high_eq5, n(3) 
xtile high_eq_3c = high_eq5, cut(aux)
drop aux


pctile aux= low_eq5, n(3) 
xtile low_eq_3c = low_eq5, cut(aux)
drop aux



* occupations according to the capital that they use more
gen     group = 1 if comp5 > high_eq5 & comp5 >low_eq5    // occupations intensive in computers
replace group = 2 if comp5 < high_eq5 & high_eq5  >low_eq5 // occupations intensive in high eq
replace group = 3 if comp5 < low_eq5 & high_eq5  < low_eq5 // occupations intensive in low eq



******************************************************************************	
*Block 2) Build Table
******************************************************************************
mat summary = J(7,4,.)
loc f = 1
* all ocupations
		sum wage5, d
		mat summary[`f',1]= r(p50)
		sum sh_employ5 
		mat summary[`f',3]= r(sum)
		sum skill_bias5, d
		mat summary[`f',4]= r(p50)
		sum wage5t, d 
		mat summary[`f',2]= r(p50)
		local f = `f' +1
		

* By cathegory 
foreach var of varlist cetc_3c {          
		forvalues i = 1(1)3{ 											
		sum wage5  if `var' == `i', d
		mat summary[`f',1]= r(p50)
		sum sh_employ5  if `var' == `i'
		mat summary[`f',3]= r(sum)
		sum skill_bias5  if `var' == `i',d 
		mat summary[`f',4]= r(p50)
		sum wage5t if `var' == `i', d
		mat summary[`f',2]= r(p50)
		local f = `f' +1
		}

	}

*comp_3c high_eq_3c low_eq_3c 
foreach var of varlist group {          
		forvalues i = 1(1)3{ 											
		sum wage5  if `var' == `i', d
		mat summary[`f',1]= r(p50)
		sum sh_employ5  if `var' == `i'
		mat summary[`f',3]= r(sum)
		sum skill_bias5  if `var' == `i',d 
		mat summary[`f',4]= r(p50)
		sum wage5t if `var' == `i', d
		mat summary[`f',2]= r(p50)
		local f = `f' +1
		}

	}
		

mat list summary

preserve
loc variables summary
foreach var of local variables {
	drop _all
	svmat double `var'
	outsheet using "$results/[TableB.I]CETC and changes in the labor market 1984-2015.xls", replace
	}
restore




