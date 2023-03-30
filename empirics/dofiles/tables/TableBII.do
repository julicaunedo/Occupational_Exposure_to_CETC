/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates elasticities at 1 digit occupations for the appendix table B.II

Data from previous files 
********************************************/




********************************************
*1) 1 Digit
********************************************


use "$final_data/[15]elasticity_data_CPS_1d.dta", replace



egen id=group(general_occ)

xtset general_occ year
   g lag_wp=L.log_W_P
   g lag_pw=L.log_P_W
   g lag_S_H=L5.log_S_H
   g log2_pswl=L.log_pswl
   g log3_pswl=L2.log_pswl

 sort general_occ year

 replace demand_IV_trade=log(demand_IV_trade)
  replace demand_IV_tradecomp=log(demand_IV_tradecomp)
 replace demand_IV2_compgr=log(demand_IV2_compgr)
 replace inv_ware=log(inv_ware)
 replace stock_ware=log(stock_ware)
replace va=log(va)*trade
g t_brt_rt=L16.brt_rt
*
drop if year<1984


   
   foreach i of numlist 1(1)6 8 10(1)11 {
* local i=1
   disp "Group " `i'

  * Create x by id
  gen log_W_P`i' = 0
  replace log_W_P`i' = log_W_P if id == `i'

  * Create instrument by id
  gen supply_IV2_brt2`i' = 0
  replace supply_IV2_brt2`i' = supply_IV2_brt2 if id == `i'
   }
   *
   foreach i of numlist 6 8{
* local i=1
   disp "Group " `i'

  * Create x by id
  replace log_W_P`i' = 0
  replace log_W_P`i' = log_W_P if id == `i'

  * Create instrument by id
  replace supply_IV2_brt2`i' = 0
  replace supply_IV2_brt2`i' = demand_IV_trade if id == `i'
   }

  
   xi:ivreg2 log_S_H i.id*year (log_W_P1 log_W_P2 log_W_P3 log_W_P4 log_W_P5 log_W_P6 log_W_P8 log_W_P10 log_W_P11    =supply_IV2_brt21 supply_IV2_brt22 supply_IV2_brt23 supply_IV2_brt24 supply_IV2_brt25 supply_IV2_brt26 supply_IV2_brt28 supply_IV2_brt210 supply_IV2_brt211) , first gmm2s robust

mat pvalues = J(8,11,.)
   
   
	foreach t of numlist 1(1)5{
		local tt=`t'+1
	foreach i of numlist `tt'(1)6 8 10(1)11 {
		lincom log_W_P`t'-log_W_P`i'
			mat pvalues[`t',`i']= r(p)
	}
	}
	foreach i of numlist 8 10(1)11 {
		lincom log_W_P6-log_W_P`i'
		mat pvalues[6,`i']= r(p)
	}
	foreach i of numlist 10(1)11 {
		lincom log_W_P8-log_W_P`i'
		mat pvalues[7,`i']= r(p)
	}

		lincom log_W_P10-log_W_P11
		mat pvalues[8,11]= r(p)
	

	drop _all
	svmat double pvalues
	drop pvalues7 pvalues9
	
	* Format table
	
	ren pvalues2 Professionals
	ren pvalues3 Technicians
	ren pvalues4 Sales
	ren pvalues5 Admininstrative_services
	ren pvalues6 Low_skilled_services
	ren pvalues8 Mechanics_and_transportation
	ren pvalues10 Precision
	ren pvalues11 Machine_operators
	
	tostring pvalues1, replace
	replace pvalues1 = "Managers" in 1
	replace pvalues1 = "Professionals" in 2
	replace pvalues1 = "Technicians" in 3
	replace pvalues1 = "Sales" in 4
	replace pvalues1 = "Admin serv." in 5
	replace pvalues1 = "Low-skill services" in 6
	replace pvalues1 = "Mechanics & Transportation" in 7
	replace pvalues1 = "Precision" in 8
	
	replace Professionals=round(Professionals, 0.01)
    replace Technicians=round(Technicians, 0.01)
    replace Sales=round(Sales, 0.01)
    replace Admininstrative_services=round(Admininstrative_services, 0.01)
	replace Low_skilled_services=round(Low_skilled_services, 0.01)
	replace Mechanics_and_transportation=round(Mechanics_and_transportation, 0.01)
	replace Precision=round(Precision, 0.01)
	replace Machine_operators=round(Machine_operators, 0.01)
	
	
	outsheet using "$results/[TableB.II]P_values_elasticities.xls", replace
