/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates figure B.III

Data from previous files 
********************************************/


********************************************
*1) Figure B.III: Panel A 
********************************************


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

egen demogr=group(g1)

bys demogr year: egen emp_gp=total(total_emp)
drop if demogr==.
g empl_prop=total_emp/emp_gp
bys year g1: egen mwage=total(wage*empl_prop)
bys year occ1d: egen mwage_occ=total(wage*sh_emp)
* employment correspond to hours for each worker type and occupation, tot_emp records the sum per group

*without model adjustement
g employ_exp=total_emp*wage

collapse (sum) employ_occu=total_emp employ_exp computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts (mean) mwage_occ, by(occ1d demogr year)

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
	
	reshape long nipa_code, i(year occ1d demogr) j(nipacode)
	ren nipa_code stock
	ren nipacode nipa_code
	merge m:1 nipa_code year using `prices'
	
	g capital_exp=stock*pipc
	collapse (mean) employ_occu employ_exp (sum) capital_exp , by(occ1d demogr year)


merge m:1 occ1d year using "$intermediate_data/[15]usercost_implied_base85.dta", nogen
	g implicit_price=implied_usercost
	g implicit_wage=employ_exp/employ_occu
	
	local alpha=0.24
	preserve
	keep if year==1985 | year==1990|year==2000|year==2010|year==2016
	egen meaninputratio=mean(capital_exp/(employ_exp))
	duplicates drop occ1d demogr, force
	keep meaninputratio occ1d demogr
	tempfile meaninput
	save `meaninput'
	restore
	merge m:1 occ1d demogr using `meaninput', nogen
	
	
	
g inputratio=(capital_exp/(employ_exp))*(meaninputratio)^(-1)*`alpha'/(1-`alpha')
g capsh=1/(1+inputratio^(-1))

 g implied_priceratio=implicit_price/implicit_wage
 
 merge m:1 occ1d year using `prices_lev'
 graph drop _all

bys year demogr: egen memploy_year=total(employ_occu)
g employ_sh=employ_occu/memploy_year


   drop if year<1985 | year>2016

  keep if year==1985 |year==2016
  replace year=2015 if year==1985


sort demogr occ1d year

  g change_inputratio=((inputratio/inputratio[_n-1])^(1/31)-1)*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
  g change_employsh=((employ_sh-employ_sh[_n-1]))*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
  g change_capsh= ((capsh-capsh[_n-1]))*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
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

 tw (scatter change_employsh change_inputratio if demogr==2, msize(small) mlabel(occp) msize(small) mlabel(occp)) (scatter change_employsh change_inputratio if demogr==1, msize(small) mlabel(occp) msize(small) mlabel(occp)), xmtick(-4.5(1.5)4) xlabel(-4.5(1.5)4) xtitle("ratio of capital expenses to labor expenses") ytitle("change in employment share, p.p. 1984-2015") legend(label(1 "male") label(2 "female")) graphregion(margin(right) fcolor(white) lcolor(white))  
 graph export "$results/[FigureB.III]inputratio_cetc_intuition_base85_tmech_demog.pdf",as(pdf) replace
   
  
********************************************
*1) Figure B.III: Panel B
******************************************** 


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

egen demogr=group(g2)

bys demogr year: egen emp_gp=total(total_emp)
drop if demogr==.
g empl_prop=total_emp/emp_gp
bys year g1: egen mwage=total(wage*empl_prop)
bys year occ1d: egen mwage_occ=total(wage*sh_emp)

g employ_exp=total_emp*wage

collapse (sum) employ_occu=total_emp employ_exp computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts (mean) mwage_occ, by(occ1d demogr year)

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
	
	reshape long nipa_code, i(year occ1d demogr) j(nipacode)
	ren nipa_code stock
	ren nipacode nipa_code
	merge m:1 nipa_code year using `prices'
	
	g capital_exp=stock*pipc
	collapse (mean) employ_occu employ_exp (sum) capital_exp , by(occ1d demogr year)

merge m:1 occ1d year using "$intermediate_data/[15]usercost_implied_base85.dta", nogen
	g implicit_price=implied_usercost
	g implicit_wage=employ_exp/employ_occu
	
	local alpha=0.24
	preserve
	keep if year==1985 | year==1990|year==2000|year==2010|year==2016
	egen meaninputratio=mean(capital_exp/(employ_exp))
	duplicates drop occ1d demogr, force
	keep meaninputratio occ1d demogr
	tempfile meaninput
	save `meaninput'
	restore
	merge m:1 occ1d demogr using `meaninput', nogen
	
	
	
	
g inputratio=(capital_exp/(employ_exp))*(meaninputratio)^(-1)*`alpha'/(1-`alpha')
g capsh=1/(1+inputratio^(-1))

 g implied_priceratio=implicit_price/implicit_wage
 
 merge m:1 occ1d year using `prices_lev'
 graph drop _all

bys year demogr: egen memploy_year=total(employ_occu)
g employ_sh=employ_occu/memploy_year


   drop if year<1985 | year>2016

  keep if year==1985 |year==2016
  replace year=2015 if year==1985


sort demogr occ1d year

 g change_inputratio=((inputratio/inputratio[_n-1])^(1/31)-1)*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
  g change_employsh=((employ_sh-employ_sh[_n-1]))*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
  g change_capsh= ((capsh-capsh[_n-1]))*100 if demogr==demogr[_n-1] & occ1d==occ1d[_n-1]
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

   tw (scatter change_employsh change_inputratio if demogr==2, msize(small) mlabel(occp) msize(small) mlabel(occp)) (scatter change_employsh change_inputratio if demogr==1, msize(small) mlabel(occp) msize(small) mlabel(occp)), xmtick(-2(1.5)4) xlabel(-2(1.5)4) xtitle("ratio of capital expenses to labor expenses") ytitle("change in employment share, p.p. 1984-2015") legend(label(1 "high-education") label(2 "low-education")) graphregion(margin(right) fcolor(white) lcolor(white))  name(inputs)  
   graph export "$results/[FigureB.III]inputratio_cetc_intuition_base85_tmech_demogsk.pdf",as(pdf) replace
   


  
