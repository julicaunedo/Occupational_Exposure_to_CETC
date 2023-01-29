


/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Estimates the stocks by nipa_code, 3 digit occupation and year

Data comes from previous files, except for depreciation data from BEA: https://apps.bea.gov/scb/account_articles/national/wlth2594/tableC.htm	
********************************************/



*********************************************************************

		
use  "$intermediate_data/[7]investmentCPS_by_occ_allyear_DOTONET.dta", clear
local savedat=1
***************************************
**TO AVOID MISTAKE
***********************************
drop if year<1985



* 0 * Fill in the gaps assuming linear trends for proportion of workers
drop age* wage_* nominal_labor_inc _merge
	drop count_t_t_ price_ naprice_ equip_ labor_inc
	*investment_occupation 
	
* Gen variable to start loop by tipe of capital per occupation  
	gen  loop_equipment1= 1   	// all equipment
	gen  loop_equipment2= 1  if  nipa_code == 5  | nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 
	gen  loop_equipment3= 1  if  nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	gen  loop_equipment4= 1  if nipa_code == 4
	gen  loop_equipment5= 1  if nipa_code == 4 | nipa_code == 5  | nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 

* loop by equipment 

	local e=1

		keep if loop_equipment`e' == 1

	
		drop cpi 
	*** Merge with capital stocks***
		merge m:1 year nipa_code using "$intermediate_data/[4]Investment_quantity_long.dta"

		drop if _merge == 2
		drop _merge
gen prop_t_t_t80=prop_t_t_ if year==1985
bys nipa_code occ2d: egen prop_t_t_80=mean(prop_t_t_t80)
bys nipa_code year: egen total_prop80=sum(prop_t_t_80)
replace prop_t_t_80=prop_t_t_80/total_prop80

gen equip_t80=equip_ if year==1985
bys nipa_code occ2d: egen equip_80=mean(equip_t80)

	* Investment in each occupation by equipment
	gen investment_occupation =  equip_ *1000000000
	gen investment_occshares=  equip_ *prop_t_t_*1000000000
	
	 gen investment_occupation_f_share=equip_*1000000000

	gen investment_occupation_f_agg=equip_80*1000000000

	gen investment_occupation_pure=equip_*1000000000

	gen investment_occupation_adj_share=equip_*1000000000

    
* 1 * Tormquist  index at the occupational level for 2 levels of agregation 


	* share of investment at the occupatinal level
	capture drop aux
	egen aux = sum(investment_occshares), by(occ2d year)  // total investment at the occupation-year level 
	gen share_inv = investment_occshares / aux  // share of each investment 
	sort occ2d nipa_code year
	gen average_inv = 0.5*(share_inv[_n] +share_inv[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1]  // average share between two years
	replace average_inv=share_inv if year==1985

	
	
	
	sort occ2d nipa_code year
	gen price_change = price_[_n]/price_[_n-1]- 1 if  nipa_code[_n] == nipa_code[_n-1]  // change in price
	gen relat_price_change = price_[_n]/cpi[_n]*cpi[_n-1]/price_[_n-1]- 1 if  nipa_code[_n] == nipa_code[_n-1]  // change in price
	



	**weighted average price change
gen occ_change_price_aux=price_change


* 2 * Price changes of equipment in each occupation 
gen occ_change_price = 1 if year ==  1985  // base year (as in the data, see Comparison of our stock) 100

	sort  occ2d nipa_code year
	forvalues i= 1986(1)2016 {

		replace occ_change_price = occ_change_price[_n-1] * (1+occ_change_price_aux) if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
	}
	preserve 
	keep occ2d nipa_code year price_change relat_price_change occ_change_price 
		save "$intermediate_data/[8]annual_price_change.dta", replace
	restore 
	
	
* 3 * merge with depreciation rates for all equipments
  
	*using BEA tables
	merge m:1 nipa_code using "$raw_data/BEA_NIPA/depreciation_rates.dta"

	drop if _merge == 2
	drop _merge
	
	*/
	

 *4 * Merge with nominal capital
	merge m:1 year nipa_code using "$intermediate_data/[2]stock_nominal_quantity_long.dta" 
	drop if _merge == 2
	drop _merge
	
*5* Construct adjusted depreciation rates

	gen relat_price_change_decade=relat_price_change
	*equation (9) in Cummins and Violante
	replace depreciation =1-(1-depreciation)/(relat_price_change_decade+1)
	

	replace depreciation=0 if depreciation<0
* 6* Nominal stock in the base year		
	gen stock = nominal_stock* 1000000000 if year == 1985 // nominal stock in base year 1980	multiplied by share of equipment use in each occup
	
	gen stock_f_share = nominal_stock*1000000000 if year == 1985
	gen stock_f_agg = nominal_stock*1000000000 if year == 1985
	gen stock_pure = nominal_stock*1000000000 if year == 1985
	gen stock_adj_share = nominal_stock*1000000000 if year == 1985
	
	capture drop aux

* 7 * Aggregate investment at the occupation level and construct the Fisher ideal index
ren occ_change_price_aux changeprice_occ
replace changeprice_occ=changeprice_occ+1 if changeprice_occ!=.

keep stock* investment_occupation* depreciation average_inv changeprice_occ relat_price_change occ_change_price total_workers total_hours low_skill_workers* high_skill_workers* female_workers wage occ2d nipa_code year prop*


if `savedat'==1{
*Compute average adjusted physical depreciation for the decade
gen decade=1 if year>=1970 & year<1980
replace decade=2 if year>=1980 & year<1990
replace decade=3 if year>=1990 & year<2000
replace decade=4 if year>=2000 & year<2010
replace decade=5 if year>=2010 & year<=2016

bys nipa_code decade: egen depreciation_decade=mean(depreciation)

preserve 
keep depreciation_decade depreciation nipa_code year
collapse (median) depreciation_decade depreciation, by(nipa_code year)
save "$intermediate_data/[8]depreciation_adjusted_DOTONET.dta", replace
restore
}

ren depreciation depreciation_weighted
gen investment_occupationr=investment_occupation/occ_change_price
   gen investment_occupation_f_sharer=investment_occupation_f_share/occ_change_price
    gen investment_occupation_adj_sharer=investment_occupation_adj_share/occ_change_price
	gen investment_occupation_f_aggr=investment_occupation_f_agg/occ_change_price
	
	gen occ_change_price_pure=1
	gen investment_occupation_purer=investment_occupation_pure/occ_change_price_pure

*Fisher
	sort occ2d nipa_code year
	
gen inv_ch = ((investment_occupationr*occ_change_price)*(investment_occupationr*occ_change_price[_n-1])/(investment_occupationr[_n-1]*occ_change_price) /(investment_occupationr[_n-1]*occ_change_price[_n-1]) )^(1/2) if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]

gen inv_ch_f_share = ((investment_occupation_f_sharer*occ_change_price)*(investment_occupation_f_sharer*occ_change_price[_n-1])/(investment_occupation_f_sharer[_n-1]*occ_change_price) /(investment_occupation_f_sharer[_n-1]*occ_change_price[_n-1]) )^(1/2) if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]

gen inv_ch_adj_share = ((investment_occupation_adj_sharer*occ_change_price)*(investment_occupation_adj_sharer*occ_change_price[_n-1])/(investment_occupation_adj_sharer[_n-1]*occ_change_price) /(investment_occupation_adj_sharer[_n-1]*occ_change_price[_n-1]) )^(1/2) if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]

gen inv_ch_f_agg = ((investment_occupation_f_aggr*occ_change_price)*(investment_occupation_f_aggr*occ_change_price[_n-1])/(investment_occupation_f_aggr[_n-1]*occ_change_price) /(investment_occupation_f_aggr[_n-1]*occ_change_price[_n-1]) )^(1/2) if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]

gen inv_ch_pure = ((investment_occupation_purer*occ_change_price_pure)*(investment_occupation_purer*occ_change_price_pure[_n-1])/(investment_occupation_purer[_n-1]*occ_change_price_pure) /(investment_occupation_purer[_n-1]*occ_change_price_pure[_n-1]) )^(1/2) if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]

	*Real series of investment	
gen total_investment = investment_occupation if year == 1985 // base year
gen total_investment_f_share = investment_occupation_f_share if year == 1985 // base year
gen total_investment_adj_share = investment_occupation_adj_share if year == 1985 // base year
gen total_investment_f_agg = investment_occupation_f_agg if year == 1985 // base year
gen total_investment_pure = investment_occupation_pure if year == 1985 // base year

sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
		replace total_investment = total_investment[_n-1] * inv_ch if year == `i' & occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
	}
	
	sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
		replace total_investment_f_share = total_investment_f_share[_n-1] * inv_ch_f_share if year == `i' & occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
	}
	
	sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
		replace total_investment_adj_share = total_investment_adj_share[_n-1] * inv_ch_adj_share if year == `i' & occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
	}
	
	sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
		replace total_investment_f_agg = total_investment_f_agg[_n-1] * inv_ch_f_agg if year == `i' & occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
	}
	
	sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
		replace total_investment_pure = total_investment_pure[_n-1] * inv_ch_pure if year == `i' & occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
	}
	
	sort occ2d nipa_code year	
		forvalues i= 1984(-1)1970 {
		replace total_investment = total_investment[_n+1] / inv_ch[_n+1] if year == `i' & occ2d[_n]==occ2d[_n+1] & nipa_code[_n]==nipa_code[_n+1]
	}

* 6 * Stocks by Permanent inventory method 	
	
	sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
			replace stock = stock[_n-1] * (1-depreciation_weighted) + total_investment if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
		}
		
		sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
			replace stock_f_share = stock_f_share[_n-1] * (1-depreciation_weighted) + total_investment_f_share if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
		}
		
		sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
			replace stock_adj_share = stock_adj_share[_n-1] * (1-depreciation_weighted) + total_investment_adj_share if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
		}
		
		sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
			replace stock_f_agg = stock_f_agg[_n-1] * (1-depreciation_weighted) + total_investment_f_agg if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
		}
		
		sort occ2d nipa_code year	
		forvalues i= 1986(1)2016 {
			replace stock_pure = stock_pure[_n-1] * (1-depreciation_weighted) + total_investment_pure if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
		}

	forvalues i= 1984(-1)1970 {
		replace stock = (stock[_n+1] - total_investment[_n+1])/(1-depreciation_weighted[_n+1])  if year == `i' & occ2d[_n]==occ2d[_n+1] & nipa_code[_n]==nipa_code[_n+1]
	}
	
	preserve
	keep stock nipa_code year occ2d
	save "$intermediate_data/[8]test_stock_cps_base85.dta",replace
	restore
	
 
	bys nipa_code year: egen tot_prop_t_t_=total(prop_t_t_)
	bys nipa_code year: egen tot_prop_t_t_80=total(prop_t_t_80)
	bys nipa_code year: egen tot_prop_adj_t_t_=total(prop_adj_t_t_)
	replace prop_t_t_=prop_t_t_/tot_prop_t_t_
	replace prop_t_t_80=prop_t_t_80/tot_prop_t_t_80
	replace prop_adj_t_t_=prop_adj_t_t_/tot_prop_adj_t_t_
	drop tot_prop_*
	*replace total_workers=. if stock==0
	replace stock=stock*prop_t_t_
	replace stock_f_share=stock_f_share*prop_t_t_80
	replace stock_f_agg=stock_f_agg*prop_t_t_
	replace stock_pure=stock_pure*prop_t_t_
	replace stock_adj_share=stock_adj_share*prop_adj_t_t_
	
		* share of investment at the occupational level
	capture drop aux
	egen aux = sum(stock), by(occ2d year)  // total investment at the occupation-year level 
	gen share_eq = stock / aux  // share of each investment 
	sort occ2d nipa_code year
	gen average_eq = 0.5*(share_eq[_n] +share_eq[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1]  // average share between two years
	replace average_eq=share_eq if year==1985
	
	
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
		
		
		
	capture drop aux
	egen aux = sum(stock), by(occ1d year)  // total investment at the occupation-year level 
	gen share_eq1d = stock / aux  // share of each investment 
	sort occ1d occ2d nipa_code year
	gen average_eq1d = 0.5*(share_eq1[_n] +share_eq1[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1] & occ1d[_n]== occ1d[_n-1]  // average share between two years
	
	replace average_eq1d=share_eq1 if year==1985
	replace average_eq=share_eq if year==1985

	
		
	save "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", replace		
		
		
		
		
