/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates figure 2

Data from previous files 
********************************************/



***************sotck

use "$final_data/[10]stocks_occuCPS_2020_byhours_1d_agg3d_DOTONET_base85_expnorm.dta", clear
keep stock_occ   occ1d year

tempfile stocks_oc
save `stocks_oc'

*********USER COST
use "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta", clear
sort nipa_code year
g pipc=usercost/cpi[_n-1] if nipa_code[_n]==nipa_code[_n-1]
keep pipc cpi year nipa_code
tempfile prices
save `prices'

*/

****CETC
use "$intermediate_data/[15]usercost_implied_base85.dta"
ren implied_usercost k_price_indx
keep k_price_indx occ1d year 
tempfile prices_lev
save `prices_lev'
*/

use "$intermediate_data/[16]Data_CPS_by_age_skill_gender_occ1d_1985_DOTONET_base85.dta", replace

gen year=1985
foreach y of numlist 1986(1)2016{

append using "$intermediate_data/[16]Data_CPS_by_age_skill_gender_occ1d_`y'_DOTONET_base85.dta"
replace year=`y' if year==.
}


bys occ1d year: egen empl_occ=total(total_emp)
g sh_emp=total_emp/empl_occ
*****
*employment by group
egen demogr=group(g1 g2 g3)
bys demogr year: egen emp_gp=total(total_emp)
drop if demogr==.
g empl_prop=total_emp/emp_gp
bys year g1 g2 g3: egen mwage=total(wage*empl_prop)
bys year occ1d: egen mwage_occ=total(wage*sh_emp)

g employ_exp=total_emp*wage

collapse (sum) employ_occu=total_emp employ_exp computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts (mean) mwage_occ, by(occ1d year)

	ren computers_ts nipa_code4 
	ren communication_ts nipa_code5 
	ren med_ins_ts nipa_code6 
	ren non_med_ins_ts nipa_code9 
	ren photocopy_ts nipa_code10 
	ren office_ts nipa_code11  
	ren metal_products_ts nipa_code13  
	ren engines_ts nipa_code14  
	ren metal_machinery_ts nipa_code17  
	ren special_machinery_ts nipa_code18  
	ren general_industry_machinery_ts nipa_code19  
	ren elctrical_trans_ts nipa_code20  
	ren electrical_ts nipa_code41  
	ren cars_trucks_ts nipa_code2225  
	ren aircraft_ts nipa_code26  
	ren ships_ts nipa_code27  
	ren rail_ts nipa_code28  
	ren other_transport_ts nipa_code29  
	ren furniture_ts nipa_code30  
	ren agricultural_ts nipa_code33  
	ren construction_ts nipa_code36  
	ren mining_ts nipa_code39  
	ren service_ts nipa_code40  
	ren software_ts nipa_code99  
	
	reshape long nipa_code, i(year occ1d) j(nipacode)
	ren nipa_code stock
	ren nipacode nipa_code
	merge m:1 nipa_code year using `prices'
	
	g capital_exp=stock*pipc
	collapse (mean) employ_occu employ_exp (sum) capital_exp , by(occ1d year)


merge 1:1 occ1d year using `stocks_oc', nogen
ren stock_occ stock

merge 1:1 occ1d year using "$intermediate_data/[15]usercost_implied_base85.dta", nogen
	g implicit_price=implied_usercost
	g implicit_wage=employ_exp/employ_occu
	g inprat=stock/employ_occu
	
	local alpha=0.24
	preserve
	keep if year==1985 | year==1990|year==2000|year==2010|year==2016
	egen meaninputratio=mean(capital_exp/(employ_exp))
	duplicates drop occ1d, force
	keep meaninputratio occ1d
	tempfile meaninput
	save `meaninput'
	restore
	merge m:1 occ1d using `meaninput', nogen
	
g inputratio=(capital_exp/(employ_exp))*(meaninputratio)^(-1)*`alpha'/(1-`alpha')
g capsh=1/(1+inputratio^(-1))

 g implied_priceratio=implicit_price/implicit_wage
 
 merge 1:1 occ1d year using `prices_lev'
 graph drop _all

bys year: egen memploy_year=total(employ_occu)
g employ_sh=employ_occu/memploy_year

  
  

  keep if year==1985 |year==2016
  replace year=2015 if year==1985
  xtset occ1d year

  g change_kl=((inprat/L.inprat)^(1/31)-1)*100
  g change_inputratio=((inputratio/L.inputratio)^(1/31)-1)*100
  g  change_impliedprice=((implied_priceratio/L.implied_priceratio)^(1/31)-1)*100
  g change_employsh=((employ_sh-L.employ_sh))*100
  g change_cetc=-((k_price_indx/L.k_price_indx)^(1/31)-1)*100
  g change_usercost=((implicit_price/L.implicit_price)^(1/31)-1)*100
    g change_capsh= ((capsh-L.capsh))*100
  sort occ1d
    gen occp = "managers"             			if occ1d == 1
replace occp = "professionals"     			if occ1d == 2
replace occp = "mechanics and transp."      if occ1d == 8
replace occp = "precision"         			if occ1d == 10
replace occp = "technicians"       			if occ1d == 3
replace occp = "sales"             			if occ1d == 4
replace occp = "machine operators" 			if occ1d ==11
replace occp = "admin serv."     			if occ1d == 5
replace occp = "low-skilled serv."  			if occ1d == 6


*return
    scatter change_employsh change_cetc, xmtick(5(2)11) xlabel(5(2)11) msize(small) mlabel(occp) xtitle("") ytitle("change in employment share, p.p. 1984-2015") graphregion(margin(right) fcolor(white) lcolor(white)) 
   graph export "$results/[Figure2_panelA]employment_cetc_intuition_base85_tmech.pdf",as(pdf) replace
   
   
   scatter change_employsh change_inputratio, xmtick(-2(1.5)4) xlabel(-2(1.5)4) msize(small) mlabel(occp) msize(small) mlabel(occp) xtitle("") ytitle("change in employment share, p.p. 1984-2015") graphregion(margin(right) fcolor(white) lcolor(white)) 
   graph export "$results/[Figure2_panelB]inputratio_cetc_intuition_base85_tmech.pdf",as(pdf) replace
   
   
