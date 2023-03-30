
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Constructs for 3 digit, 2 digit and 1 digit occupation: 
1) Relative price of investment to consumption by occuptaion and year
2) Price of equipment bundle by occupation and year
3) Expenses in capital by occupation and year

Data from previous files
********************************************/

	
*********************************************************************


*************************
* 1) 3 Digit occupations
*************************



	use "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_DOTONET_base85.dta", clear

	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	ren pcepi cpi
	gen pipc = price_/cpi

	drop _merge
	
	
	

	******************************************************************************	
	*Price indexes/ technology measures
	******************************************************************************	
	preserve
	bys nipa_code occ2d year: gen price_index_all=pipc*average_inv
	bys occ2d year: egen k_price_indx=total(price_index_all)
	label var k_price_indx "Price index of Capital"
		
	gen weigth2 = average_inv *pipc if nipa_code == 4
	egen k_price_comp_indx = sum(weigth2), by(occ2d year)
	label var k_price_comp_indx "Price index of Computers"

	gen weigth3 = average_inv * pipc if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	egen k_price_lowcetc_indx = sum(weigth3), by(occ2d year)
	label var k_price_lowcetc_indx "Price index of LCETC"

	gen weigth4 = average_inv * pipc  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	egen k_price_highcetc_indx = sum(weigth4), by(occ2d year)
	label var k_price_highcetc_indx "Price index of HCETC"
		

	collapse (mean) k*, by(occ2d year)
	save "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_DOTONET_base85.dta", replace
	restore
	 
	 ************************************************************************
	* Cost of Capital By occupation
	***********************************************************************

	bys nipa_code occ2d year: gen cost_all=usercost*average_eq
	bys occ2d year: egen k_price=sum(cost_all)
	label var k_price "User cost of Capital"
		
		
	gen weigth2 = usercost*average_eq if nipa_code == 4
	egen k_price_comp = sum(weigth2), by(occ2d year)
	label var k_price_comp "User cost of Computers"

	egen equip_nipa=total(average_eq) if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	gen weigth3 = usercost*average_eq/equip_nipa if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	egen k_price_lowcetc = sum(weigth3), by(occ2d year)
	label var k_price_lowcetc "User cost of LCETC"

	drop equip_nipa
	egen equip_nipa=total(average_eq) if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	gen weigth4 = usercost*average_eq/equip_nipa  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	egen k_price_highcetc = sum(weigth4), by(occ2d year)
	label var k_price_highcetc "User cost of HCETC"


	drop cost_all weigth2 weigth3 weigth4 equip_nipa

	********************************************************************
	* Tornqvist usercost index
	*****************************************************
	preserve

	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)

	gen expense=total_stock*usercost/cpi_84 if year==1985

	sort occ2d nipa_code year


	replace expense=total_stock*usercost/cpi[_n-1] if nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1] & year>1984
	bys occ2d year: egen aux=total(expense)
	g share_eq_exp=expense/aux
	sort occ2d nipa_code year

		gen average_sh = 0.5*(share_eq_exp[_n] +share_eq_exp[_n-1])  if nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1]
		replace average_sh=share_eq_exp if year==1985
		sort occ2d nipa_code year
		gen usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi_84/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1] & year==1986

		replace usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi[_n-2]/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1]  & year>1986
		bys occ2d year: egen user_gr=total(usercost_gr)
		sort nipa_code occ2d year


		duplicates drop occ2d year, force
		
		
		
		g usercost_index=1 if year==1985

		xtset occ2d year
	forvalues i=1986(1)2016{
		replace usercost_index=L.usercost_index*exp(user_gr) if year==`i'
	}
	save "$intermediate_data/[12]usercost_index_3digit_base85.dta", replace

	restore

	
	********************************************************************
	* Cost of Capital By 1 digit occupation
	*****************************************************
	bys nipa_code occ1d year: gen cost_all=usercost*average_eq1d
	bys occ1d year: egen k_price1d=sum(cost_all)
	label var k_price1d "User cost of Capital 1digit"
		
	gen weigth2 = usercost*average_eq1d if nipa_code == 4
	egen k_price_comp1d = sum(weigth2), by(occ1d year)
	label var k_price_comp1d "User cost of Computers 1digit"

	egen equip_nipa=total(average_eq1d) if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	gen weigth3 = usercost*average_eq1d/equip_nipa if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	egen k_price_lowcetc1d = sum(weigth3), by(occ1d year)
	label var k_price_lowcetc1d "User cost of LCETC 1digit"

	drop equip_nipa
	egen equip_nipa=total(average_eq1d) if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	gen weigth4 = usercost*average_eq1d/equip_nipa  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	egen k_price_highcetc1d = sum(weigth4), by(occ1d year)
	label var k_price_highcetc1d "User cost of HCETC 1digit"
		
	************************************************************************
	* Capital Expenses
	***********************************************************************

	bys nipa_code occ2d year: gen expense_detail=usercost*total_stock
	bys occ2d year: gen expense_detail_computers=usercost*total_stock if nipa_code==4
	bys occ2d year: gen expense_detail_hcetc=usercost*total_stock if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	bys occ2d year: gen expense_detail_lcetc=usercost*total_stock if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 



	bys occ2d year: egen total_exp=total(expense_detail)
	bys occ2d year: egen total_exp_computer=total(expense_detail_computer)
	bys occ2d year: egen total_exp_lcetc=total(expense_detail_lcetc)
	bys occ2d year: egen total_exp_hcetc=total(expense_detail_hcetc)



	collapse (mean) k* total_exp*, by(occ2d year)
	save "$intermediate_data/[12]usercost_occ_by_equipment_upt_CPS_DOTONET_base85.dta", replace

 	
	

*************************
* 2) 1 Digit occupations
*************************


	use "$intermediate_data/[8]test_stock_cps_base85.dta"
	duplicates drop nipa_code year, force
	bys year: egen tot_stock=total(stock)
	gen share_eq_tot=stock/tot_stock
	tempfile shares
	keep year nipa_code share_eq_tot
	save `shares'
	

	use "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_byhours_1d_from3d_DOTONET_base85.dta", clear

	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	ren pcepi cpi
	gen pipc = price_/cpi

	drop _merge
	

	******************************************************************************	
	*Price indexes/ technology measures
	******************************************************************************	
	bys occ1d year: egen tot_ch2=total(average_eq1d)
	replace average_eq1=average_eq1d/tot_ch2
	
	preserve
	*bys nipa_code occ1d year: gen price_index_all=pipc*average_inv
	bys nipa_code occ1d year: gen price_index_all=pipc*average_eq1d
	bys occ1d year: egen k_price_indx=total(price_index_all)

	label var k_price_indx "Price index of Capital"
		
	*gen weigth2 = average_inv *pipc if nipa_code == 4
	gen weigth2 = average_eq1d *pipc if nipa_code == 4 | nipa_code==99
	egen k_price_comp_indx = sum(weigth2), by(occ1d year)
	label var k_price_comp_indx "Price index of Computers"


	gen weigth3 = average_eq1d* pipc if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	*gen weigth3 = average_inv * pipc if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	egen k_price_lowcetc_indx = sum(weigth3), by(occ1d year)
	label var k_price_lowcetc_indx "Price index of LCETC"

	gen weigth4 = average_eq1d* pipc  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	*gen weigth4 = average_inv * pipc  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	egen k_price_highcetc_indx = sum(weigth4), by(occ1d year)
	label var k_price_highcetc_indx "Price index of HCETC"
		
		
	collapse (mean) k*, by(occ1d year)

	save "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_1d_from3d_DOTONET_equipment_base85.dta", replace
	restore


 
	********************************************************************
	* Cost of Capital By 1 digit occupation
	*****************************************************
	preserve
	***GENERATE AGGREGATE SHARES
	duplicates drop nipa_code year, force

	 merge 1:1 nipa_code year using `shares'
	 egen nipa=group(nipa_code)
  

	bys nipa_code year: gen cost_all=usercost*share_eq_tot
	 bys year: egen usercost_agg=sum(cost_all)
	 
	 duplicates drop year, force
	 keep year usercost_agg
	  save "$intermediate_data/[12]usercost_agg_base85.dta", replace
	restore
	



	
	********************************************************************
	* Tornqvist usercost index
	*****************************************************
	preserve

	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)

	gen expense=total_stock*usercost/cpi_84 if year==1985

	sort occ1d nipa_code year

	replace expense=total_stock*usercost/cpi[_n-1] if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] & year>1984
	bys occ1d year: egen aux=total(expense)
	g share_eq_exp=expense/aux
	sort occ1d nipa_code year

		gen average_sh = 0.5*(share_eq_exp[_n] +share_eq_exp[_n-1])  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1]
		replace average_sh=share_eq_exp if year==1985
		sort occ1d nipa_code year
		gen usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi_84/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] & year==1986

		replace usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi[_n-2]/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1]  & year>1986
		bys occ1d year: egen user_gr=total(usercost_gr)
		sort nipa_code occ1d year

		duplicates drop occ1d year, force
				
		g usercost_index=1
		xtset occ1d year
	forvalues i=1986(1)2016{
		replace usercost_index=L.usercost_index*exp(user_gr) if year==`i'
	}
	save "$intermediate_data/[12]usercost_index_base85.dta", replace

	restore

	********************************************************************
	* Cost of Capital By 1 digit occupation
	*****************************************************
	preserve
	bys nipa_code occ1d year: gen cost_all=usercost*average_eq1d
	bys occ1d year: egen k_price1d=sum(cost_all)
	label var k_price1d "User cost of Capital 1digit"
		
	gen weigth2 = usercost*average_eq1d if nipa_code == 4 |nipa_code==99
	egen k_price_comp1d = sum(weigth2), by(occ1d year)
	label var k_price_comp1d "User cost of Computers 1digit"

	egen equip_nipa=total(average_eq1d) if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	gen weigth3 = usercost*average_eq1d/equip_nipa if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	egen k_price_lowcetc1d = sum(weigth3), by(occ1d year)
	label var k_price_lowcetc1d "User cost of LCETC 1digit"

	drop equip_nipa
	egen equip_nipa=total(average_eq1d) if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	gen weigth4 = usercost*average_eq1d/equip_nipa  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	egen k_price_highcetc1d = sum(weigth4), by(occ1d year)
	label var k_price_highcetc1d "User cost of HCETC 1digit"
		
	************************************************************************
	* Capital Expenses
	***********************************************************************

	*bys nipa_code occ1d year: gen expense_detail=usercost*total_stock
	gen cpi_1982=cpi if year==1984
	egen cpi_82=mean(cpi_1982)

	gen expense_detail=usercost*total_stock/cpi_82 if year==1985

	sort occ1d nipa_code year
	replace expense_detail=total_stock*usercost/cpi[_n-1] if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] & year>1983

	bys occ1d year: gen expense_detail_computers=usercost*total_stock if nipa_code==4 |nipa_code == 99
	bys occ1d year: gen expense_detail_hcetc=usercost*total_stock if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
	bys occ1d year: gen expense_detail_lcetc=usercost*total_stock if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 



	bys occ1d year: egen total_exp=total(expense_detail)
	bys occ1d year: egen total_exp_computer=total(expense_detail_computer)
	bys occ1d year: egen total_exp_lcetc=total(expense_detail_lcetc)
	bys occ1d year: egen total_exp_hcetc=total(expense_detail_hcetc)



	collapse (mean) k* total_exp*, by(occ1d year)
	save "$intermediate_data/[12]usercost_occ_by_equipment_upt_CPS_1d_from3d_DOTONET_base85.dta", replace

	restore

	
	
*************************
* 3) 2 Digit occupations
*************************
use "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_byhours_2d-elast_from3d_DOTONET_base85.dta", clear


merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
ren pcepi cpi
*
gen pipc = price_/cpi

drop _merge

******************************************************************************	
*Price indexes/ technology measures
******************************************************************************	
bys occ_2d year: egen tot_ch2=total(average_eq1d)

replace average_eq1=average_eq1d/tot_ch2

*
preserve
bys nipa_code occ_2d year: gen price_index_all=pipc*average_inv
bys occ_2d year: egen k_price_indx=total(price_index_all)

label var k_price_indx "Price index of Capital"
	
gen weigth2 = average_inv *pipc if nipa_code == 4 | nipa_code==99
egen k_price_comp_indx = sum(weigth2), by(occ_2d year)
label var k_price_comp_indx "Price index of Computers"


gen weigth3 = average_inv * pipc if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
egen k_price_lowcetc_indx = sum(weigth3), by(occ_2d year)
label var k_price_lowcetc_indx "Price index of LCETC"

gen weigth4 = average_inv * pipc  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
egen k_price_highcetc_indx = sum(weigth4), by(occ_2d year)
label var k_price_highcetc_indx "Price index of HCETC"
	


collapse (mean) k*, by(occ_2d year)

drop if occ_2d == .
save "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_2d-elast_from3d_DOTONET_base85.dta", replace

restore
*/


******************************************************************************	
*Price indexes/ technology measures using equipment weights (as in the usercost)
******************************************************************************	

preserve
bys nipa_code occ_2d year: gen price_index_all=pipc*average_eq1d
bys occ_2d year: egen k_price_indx=total(price_index_all)

label var k_price_indx "Price index of Capital"
	
gen weigth2 = average_eq1d *pipc if nipa_code == 4 | nipa_code==99
egen k_price_comp_indx = sum(weigth2), by(occ_2d year)
label var k_price_comp_indx "Price index of Computers"


gen weigth3 = average_eq1d* pipc if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
egen k_price_lowcetc_indx = sum(weigth3), by(occ_2d year)
label var k_price_lowcetc_indx "Price index of LCETC"

gen weigth4 = average_eq1d* pipc  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
egen k_price_highcetc_indx = sum(weigth4), by(occ_2d year)
label var k_price_highcetc_indx "Price index of HCETC"
	
drop if occ_2d == .
	save "$intermediate_data/[12]Prices_by_equipmentCPS_2d-elast_from3d_DOTONET_equipment_base85.dta", replace

	
collapse (mean) k*, by(occ_2d year)

save "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_2d-elast_from3d_DOTONET_equipment_base85.dta", replace

restore


********************************************************************
* Tornqvist usercost index
*****************************************************
preserve

gen cpi_1984=cpi if year==1984
egen cpi_84=mean(cpi_1984)

gen expense=total_stock*usercost/cpi_84 if year==1985

sort occ_2d nipa_code year

replace expense=total_stock*usercost/cpi[_n-1] if nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1] & year>1984
bys occ_2d year: egen aux=total(expense)
g share_eq_exp=expense/aux
sort occ_2d nipa_code year

	gen average_sh = 0.5*(share_eq_exp[_n] +share_eq_exp[_n-1])  if nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1]
	replace average_sh=share_eq_exp if year==1985
	sort occ_2d nipa_code year
	gen usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi_84/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1] & year==1986

	replace usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi[_n-2]/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1]  & year>1986
	bys occ_2d year: egen user_gr=total(usercost_gr)
	sort nipa_code occ_2d year

	duplicates drop occ_2d year, force
	
	g usercost_index=1

	xtset occ_2d year
forvalues i=1986(1)2016{
	replace usercost_index=L.usercost_index*exp(user_gr) if year==`i'
}


drop if occ_2d == .
save "$intermediate_data/[12]usercost_index_2d-elast_base85.dta", replace

restore

********************************************************************
* Cost of Capital By 1 digit occupation
*****************************************************
preserve
bys nipa_code occ_2d year: gen cost_all=usercost*average_eq1d
bys occ_2d year: egen k_price1d=sum(cost_all)
label var k_price1d "User cost of Capital 1digit"
	
	
gen weigth2 = usercost*average_eq1d if nipa_code == 4 |nipa_code==99
egen k_price_comp1d = sum(weigth2), by(occ_2d year)
label var k_price_comp1d "User cost of Computers 1digit"

egen equip_nipa=total(average_eq1d) if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
gen weigth3 = usercost*average_eq1d/equip_nipa if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
egen k_price_lowcetc1d = sum(weigth3), by(occ_2d year)
label var k_price_lowcetc1d "User cost of LCETC 1digit"

drop equip_nipa
egen equip_nipa=total(average_eq1d) if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
gen weigth4 = usercost*average_eq1d/equip_nipa  if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
egen k_price_highcetc1d = sum(weigth4), by(occ_2d year)
label var k_price_highcetc1d "User cost of HCETC 1digit"
	
************************************************************************
* Capital Expenses
***********************************************************************

gen cpi_1982=cpi if year==1984
egen cpi_82=mean(cpi_1982)

gen expense_detail=usercost*total_stock/cpi_82 if year==1985

sort occ_2d nipa_code year
replace expense_detail=total_stock*usercost/cpi[_n-1] if nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1] & year>1983

bys occ_2d year: gen expense_detail_computers=usercost*total_stock if nipa_code==4 |nipa_code == 99
bys occ_2d year: gen expense_detail_hcetc=usercost*total_stock if nipa_code == 5 | nipa_code == 6  | nipa_code == 9 | nipa_code ==26| nipa_code == 10 | nipa_code ==40| nipa_code == 18 | nipa_code ==14
bys occ_2d year: gen expense_detail_lcetc=usercost*total_stock if nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 



bys occ_2d year: egen total_exp=total(expense_detail)
bys occ_2d year: egen total_exp_computer=total(expense_detail_computer)
bys occ_2d year: egen total_exp_lcetc=total(expense_detail_lcetc)
bys occ_2d year: egen total_exp_hcetc=total(expense_detail_hcetc)

drop if occ_2d == .
save "$intermediate_data/[12]usercost_by_equipment_upt_CPS_2d-elast_from3d_DOTONET_base85.dta", replace
collapse (mean) k* total_exp*, by(occ_2d year)


save "$intermediate_data/[12]usercost_occ_by_equipment_upt_CPS_2d-elast_from3d_DOTONET_base85.dta", replace


	
	
	
