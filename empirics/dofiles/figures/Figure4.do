/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates figure 4

Data from previous files 
********************************************/

	
	
*1 ***** Baseline DATA preparation ********



 *******************ALPHAS**************
	preserve

	***************sotcks

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


	****CETC

	*FOR CETC weigh by investment
	use "$intermediate_data/[15]usercost_implied_base85.dta"
	ren implied_usercost k_price_indx
	keep k_price_indx occ1d year 
	tempfile prices_lev
	save `prices_lev'

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

	* employment correspond to hours for each worker type and occupation, tot_emp records the sum per group
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
		
		tempfile temp_1
		save `temp_1'
		
		keep if year==1985 | year==1990|year==2000|year==2010|year==2016
		egen meaninputratio=mean(capital_exp/(employ_exp))
		duplicates drop occ1d, force
		keep meaninputratio occ1d
		tempfile meaninput
		save `meaninput'
		
		use `temp_1', clear
		
		merge m:1 occ1d using `meaninput', nogen
		
		
		
	g inputratio=(capital_exp/(employ_exp))*(meaninputratio)^(-1)*`alpha'/(1-`alpha')
	g capsh=1/(1+inputratio^(-1))

	 g implied_priceratio=implicit_price/implicit_wage
	 
	 merge 1:1 occ1d year using `prices_lev'
	 graph drop _all
	bys year: egen memploy_year=total(employ_occu)
	g employ_sh=employ_occu/memploy_year

	keep if year==1985
	duplicates drop occ1d, force
	sort occ1d
	keep occ1d inputratio
	gen alpha = inputratio /(1+inputratio)
	tempfile alpha
	save `alpha'	
	
	restore	
		
		
	use "$final_data/[15]elasticity_data_CPS_1d.dta", clear	
	gen occ1d = general_occ
	duplicates drop general_occ year, force
 	egen id=group(general_occ)
	
	* Merge alpha with data
	merge m:1 occ1d using `alpha', nogen
	
	
	
	
	
 *3 ******************ESTIMATES**************
 sort general_occ year

 
 
 
	 * Instruments
	replace demand_IV_trade=log(demand_IV_trade)
	 ** Our IVs with counterfactual population growth
	replace supply_IV2_brt2=log(supply_IV2_brt2)
	 
	* Variables to store results 
 
	gen stock_assigment = . 
	gen stock_assigment_sd = .
	gen IV_coef = . 

	tempfile data_reg
	save `data_reg'

foreach i of numlist 1(1)5 10(1)11 {
   disp "Group " `i'
   *save alpha
   sum alpha if id==`i'
   local alpha = r(mean) 
      
 ivreg2 log_S_H year (log_W_P=supply_IV2_brt2)  if id==`i', first gmm2s robust
 replace IV_coef = _b[log_W_P]  if id==`i'
 *Estimates from paper parameters
 nlcom (coef: (.3*(1.34-_b[log_W_P])*`alpha')/(1.34+0.3+(_b[log_W_P]-1.34)*`alpha')), post  


 mat A = e(b)
 mat B = e(V)
 replace stock_assigment = A[1,1] if id==`i'
 replace stock_assigment_sd = sqrt(B[1,1]) if id==`i'
 
   
   }   


   
   foreach i of numlist 6 8{
   disp "Group " `i'
   *save alpha
   sum alpha if id==`i'
   local alpha = r(mean) 
      
 ivreg2 log_S_H year (log_W_P=demand_IV_trade)  if id==`i', first gmm2s 
 replace IV_coef = _b[log_W_P]  if id==`i'
 *Estimates from paper parameters
 nlcom (coef: (.3*(1.34-_b[log_W_P])*`alpha')/(1.34+0.3+(_b[log_W_P]-1.34)*`alpha')), post  

 mat A = e(b)
 mat B = e(V)
 replace stock_assigment = A[1,1] if id==`i'
 replace stock_assigment_sd = sqrt(B[1,1]) if id==`i'
 
 }
 
 
 *4 ****************** Figure **************
 
 keep general_occ stock_assigment stock_assigment_sd IV_coef alpha inputratio

duplicates drop general_occ stock_assigment stock_assigment_sd, force




    gen ci_up=stock_assigment+ invttail(3,0.1)* stock_assigment_sd 
    gen ci_dw=stock_assigment- invttail(3,0.1)* stock_assigment_sd 
	
	replace ci_up           = ci_up 
	replace ci_dw           = ci_dw 
	
	tab general_occ

ren general_occ occ1d
 gen occp = "Managers"             			if occ1d == 1
replace occp = "Professionals"     			if occ1d == 2
replace occp = "Mechanics and transp."      if occ1d == 8
replace occp = "Precision prod."         	if occ1d == 10
replace occp = "Technicians"       			if occ1d == 3
replace occp = "Sales"             			if occ1d == 4
replace occp = "Machine operators" 			if occ1d ==11
replace occp = "Admin. serv."     			if occ1d == 5
replace occp = "Low-skilled serv."  		if occ1d == 6
replace occ1d=7 if occ1d==8
replace occ1d=8 if occ1d==10
replace occ1d=9 if occ1d==11

*browse occ1d stock_assigment IV_coef alpha inputratio


gen order_pict=occ1d
replace order_pict=1 if occ1d==6
replace order_pict=2 if occ1d==7
replace order_pict=3 if occ1d==9
replace order_pict=4 if occ1d==8
replace order_pict=6 if occ1d==4
replace order_pict=7 if occ1d==3
replace order_pict=8 if occ1d==2
replace order_pict=9 if occ1d==1

gen round_est=round(stock_assigment, 0.0001)

sort occ1d
tw (scatter stock_assigment order_pict,  msize(small) mlabel(round_est)) (scatter ci_up order_pict, msize(small) mcolor(red) msymbol(plus)) (scatter ci_dw order_pict, msize(small)  mcolor(red) msymbol(plus)),  xtitle("") xmtick(1(1)9.5) yline(0, lcolor(black) lpattern(shortdash)) xlabel(1 "Low-skill serv." 2 "Mechanics and transp." 3 "Machine operators"  4 "Precision prod"  5 "Admin. serv." 6 "Sales" 7 "Technicians" 8 "Professionals" 9 "Managers" , angle(55)) ytitle("% change in employment for 1% CETC") legend(off) graphregion(margin(right) fcolor(white) lcolor(white)) 
graph export "$results/[Figure4]Occupational_exposure_CETC.pdf",as(pdf) replace


