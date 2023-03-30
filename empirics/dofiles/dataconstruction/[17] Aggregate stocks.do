/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file finish with the data preparation for the estimation of the elasticities at the aggregate level

Data from previous files 
********************************************/
		 

		use "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta", clear
			keep price_ usercost nipa_code year  cpi

			keep if year>=1985
			tempfile usercost
			save `usercost'


use "$intermediate_data/[8]test_stock_cps_base85.dta",clear
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
		
drop if occ1d==7 | occ1d==9
duplicates drop nipa_code year, force
replace stock=stock/1000000000
merge m:1 nipa_code year using `usercost'
drop _merge
merge m:1 year nipa_code using "$intermediate_data/[2]stock_nominal_quantity_long.dta" 


xtset nipa_code year
			
su usercost if year==1985
			
			
g usern=usercost if year==1985
bys nipa_code: egen usercostn=mean(usern)
replace usercost=usercost/usercostn
su usercost if year==1985
		
g exp_stock=usercost*stock
			
bys year: egen exp_stock_tot=total(exp_stock)	
g share_stock=exp_stock/exp_stock_tot
			

levelsof nipa_code, local(nipa)
keep if year>=1972

	
bys year: egen check=total(share_stock)
			
xtset nipa_code year
g average_share=(share_stock+L.share_stock)*1/2
gen stock_index_gr=log(stock/L.stock)*average_share
bys year: egen s_price_gr=total(stock_index_gr)

keep if year>=1985
egen stock_ag=total(stock) if year==1985
duplicates drop year, force
tsset year


sort year
forvalues i=1986(1)2016{
	replace stock_ag=L.stock_ag*exp(s_price_gr) if year==`i'
}

g growth_ag=(stock_ag/L.stock_ag-1)
g implied_user=exp_stock_tot/stock_ag
sort year

* Normalize 1985 =  100
g aux = stock_ag if year  == 1985 
egen aux2 = mean(aux)
replace stock_ag = stock_ag / aux2 * 100

keep stock_ag year
save "$intermediate_data/[17]stock_agg_052021_base85_tmech_woag.dta", replace


