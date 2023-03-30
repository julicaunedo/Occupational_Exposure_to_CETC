/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file finish with the data preparation for the estimation of the elasticities

Data from previous files 
********************************************/


* Preliminaries
* Population for 2 digit occ
use "$raw_data/FED_working_age_population/working_age_pop.dta",clear // Merge with working age population for instrument
ren workingage population
	merge 1:1 year using  "$raw_data/FED_working_age_population/crudebirthrate.dta"
	forvalues i=1(1)11{		
			  gen occ`i'=1	  
	}
	reshape long occ, i(year population brt_rt) j(occ1d)
	save "$intermediate_data/[15]pop_all.dta", replace

********************************************
*1)  1 Digit occupations
********************************************


use "$final_data/[14]Occ_Stock_prices_CPS_2020_1d_from3d_DOTONET_base85_expnorm.dta", clear


drop hours
ren k_price_all k_price1d
		drop _merge
	merge 1:1 occ1d year using "$intermediate_data/[13]supply_allyears_forIV_CPS_1d.dta"
	
	tab _merge

	
	keep if _merge==3
	drop _merge
	*
	merge 1:1 occ1d year using "$intermediate_data/[13]demand_allyears_forIV_CPS_1d.dta"

	
	tab _merge
	keep if _merge==3
	drop _merge

merge 1:1 year occ1d using "$intermediate_data/[15]pop_all.dta", nogen  // Merge with population for instrument
tab occ1d

drop adj_lab
ren adj_lab_minc adj_lab
		


		collapse (mean) k_price1d k_price_indx k_price_HCETC k_price_comp1d wage wage_predicted adj_wages adj_wages_minc population brt_rt total_exp* stock_occ share* trade demand_ind (sum) supply_IV*  demand_IV* lag_supply_IV stock_all stock_HCETC stock_COMPUTERS hperwt* adj_lab wage_bill* perwt lag_share* lag_supply_skill lag_demand*, by(occ1d year)	


					merge m:1 year using "$intermediate_data/[13]warehouse_IV.dta", nogen
					gen implied_usercost=total_exp/stock_occ
					gen stock=stock_occ
					ren occ1d general_occ

					gen heads = perwt
					gen hours = hperwt

					bys year: egen tot_employ  = total(heads)
					gen employment_share = heads/tot_employ


					bys year: egen tot_hours  = total(hours)
					gen hours_share = hours/tot_employ

					bys year: egen tot_stock= total(stock)

					gen emp_share = employment_share

	preserve
	ren general_occ occ1d
	keep implied_usercost occ1d year
	save "$intermediate_data/[15]usercost_implied_base85.dta", replace
	restore	
					
	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	ren pcepi cpi
	xtset general_occ year

	gen price= implied_usercost

	gen wage_emp = wage_bill/adj_lab


	gen log_wagebill=ln(wage_bill)

	gen P_W=price/wage_emp

	gen log_w=log(wage_emp)
	gen log_p=log(price)

	gen log_P_W = ln(P_W)
	gen log_L_S = ln(heads/stock)
	gen log_H_S = ln(adj_lab/stock)
	gen log_S_H= ln(stock/adj_lab)
	gen log_stock=ln(stock)
	gen log_heads=ln(heads)
	gen log_hours=ln(hours)
	gen log_W_P=ln(P_W^(-1))


	gen log_PS_WL=ln(P_W*stock/adj_lab)
	gen capshare=(1/(1+adj_lab/P_W*stock))
	gen log_tot_exp_WL=ln(total_exp/(adj_lab*wage_emp))
	replace log_PS_WL=log_tot_exp_WL

	** PANEL STRUCT
	tsset general_occ year

	*/
	**IVs Aggregate

	gen log_stock_lag=L.log_H_S
	gen log_pswl=L.log_PS_WL
	gen log_stock_lag5=L5.log_S_H
	gen log_stock_lag10=L6.log_S_H
	gen log_stock_lag1=L.log_S_H


	gen log_lab_lag=L.log_hours
	gen population_shifter=L16.population
	gen brt_rt_shifter=L16.brt_rt 


	replace population_shifter=ln(population_shifter)
	replace brt_rt_shifter=ln(brt_rt_shifter)

	gen log_stock_1980=log_L_S if year==1985
	bys general_occ: egen stock_1980=mean(log_stock_1980)
	** IV
	gen employ_share1980=employment_share if year==1985
	bys general_occ: egen employment_share1980=mean(employ_share1980)


	by general_occ: gen population_shifter_occ=L16.population*employment_share1980 
	by general_occ: gen population_shifter_occ_trade=L16.population*employment_share1980*L.trade 
	replace population_shifter_occ=log(population_shifter_occ)

	by general_occ: gen brt_rt_shifter_occ=L16.brt_rt*L.employment_share1980
	sort general_occ  year 


		** Our IVs with counterfactual population growth
	replace supply_IV=log(supply_IV)
	replace demand_IV=log(demand_IV)
	replace demand_IV2=log(demand_IV2)
	replace demand_IV2=log(demand_IV2_comp)


	replace supply_IV_brt=log(supply_IV_brt)
	replace supply_IV2_brt=log(supply_IV2_brt)
	replace supply_IV2_brt2=log(supply_IV2_brt2)
	replace supply_IV_comp=log(supply_IV_comp)
	drop if stock==0
	drop if general_occ==.

	save "$final_data/[15]elasticity_data_CPS_1d.dta", replace


	
	
	
************************************************************************
*2- digit occupations	
************************************************************************	
	
	
	use "$raw_data/FED_working_age_population/working_age_pop.dta",clear // Merge with working age population for instrument
	ren workingage population
		merge 1:1 year using  "$raw_data/FED_working_age_population/crudebirthrate.dta"
		forvalues i=1(1)21{
			gen occ`i'=1
		}
		reshape long occ, i(year population brt_rt) j(occ_2d)
		save "$intermediate_data/[15]pop_all_2d.dta", replace

	use "$final_data/[14]Occ_Stock_prices_CPS_2020_2d-elast_from3d_DOTONET_base85_expnorm.dta", clear


	drop hours
	ren k_price_all k_price1d
	drop _merge
	merge 1:1 occ_2d year using "$intermediate_data/[13]supply_allyears_forIV_CPS_nooccadj_2d-elast.dta"
		
	tab _merge

		
	keep if _merge==3
	drop _merge
	

	merge 1:1 occ_2d year using "$intermediate_data/[13]demand_allyears_forIV_CPS_2d-elast.dta"

		
	tab _merge
	keep if _merge==3
	drop _merge

	merge 1:1 year occ_2d using "$intermediate_data/[15]pop_all_2d.dta", nogen  // Merge with population for instrument
	tab occ_2d

	drop adj_lab
	ren adj_lab_minc adj_lab
			


	collapse (mean) k_price1d k_price_indx k_price_HCETC k_price_comp1d wage wage_predicted adj_wages adj_wages_minc population brt_rt total_exp* stock_occ share* trade demand_ind (sum) supply_IV*  demand_IV* lag_supply_IV stock_all stock_HCETC stock_COMPUTERS hperwt* adj_lab wage_bill* perwt lag_share* lag_supply_skill lag_demand*, by(occ_2d year)	

	merge m:1 year using "$intermediate_data/[13]warehouse_IV.dta", nogen
	gen implied_usercost=total_exp/stock_occ
	gen stock=stock_occ
	ren occ_2d general_occ
	gen heads = perwt
	gen hours = hperwt

	bys year: egen tot_employ  = total(heads)
	gen employment_share = heads/tot_employ


	bys year: egen tot_hours  = total(hours)
	gen hours_share = hours/tot_employ

	bys year: egen tot_stock= total(stock)

	gen emp_share = employment_share


	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	ren pcepi cpi
	xtset general_occ year

	gen price= implied_usercost
	gen wage_emp = wage_bill/adj_lab
	gen log_wagebill=ln(wage_bill)

	gen P_W=price/wage_emp

	gen log_w=log(wage_emp)
	gen log_p=log(price)

	gen log_P_W = ln(P_W)
	gen log_L_S = ln(heads/stock)
	gen log_H_S = ln(adj_lab/stock)
	gen log_S_H= ln(stock/adj_lab)
	gen log_stock=ln(stock)
	gen log_heads=ln(heads)
	gen log_hours=ln(hours)
	gen log_W_P=ln(P_W^(-1))


	gen log_PS_WL=ln(P_W*stock/adj_lab)
	gen capshare=(1/(1+adj_lab/P_W*stock))
	gen log_tot_exp_WL=ln(total_exp/(adj_lab*wage_emp))
	replace log_PS_WL=log_tot_exp_WL


	tsset general_occ year

	*/
	**IVs Aggregate

	gen log_stock_lag=L.log_H_S
	gen log_pswl=L.log_PS_WL
	gen log_stock_lag5=L5.log_S_H
	gen log_stock_lag10=L6.log_S_H
	gen log_stock_lag1=L.log_S_H


	gen log_lab_lag=L.log_hours
	gen population_shifter=L16.population
	gen brt_rt_shifter=L16.brt_rt 


	replace population_shifter=ln(population_shifter)
	replace brt_rt_shifter=ln(brt_rt_shifter)

	gen log_stock_1980=log_L_S if year==1985
	bys general_occ: egen stock_1980=mean(log_stock_1980)
	** IV
	gen employ_share1980=employment_share if year==1985
	bys general_occ: egen employment_share1980=mean(employ_share1980)


	by general_occ: gen population_shifter_occ=L16.population*employment_share1980 
	by general_occ: gen population_shifter_occ_trade=L16.population*employment_share1980*L.trade 

	replace population_shifter_occ=log(population_shifter_occ)

	by general_occ: gen brt_rt_shifter_occ=L16.brt_rt*L.employment_share1980
	sort general_occ  year 

	replace supply_IV=log(supply_IV)

	replace demand_IV=log(demand_IV)
	replace demand_IV2=log(demand_IV2)
	replace demand_IV2=log(demand_IV2_comp)
	replace supply_IV_brt=log(supply_IV_brt)
	replace supply_IV2_brt=log(supply_IV2_brt)
	replace supply_IV2_brt2=log(supply_IV2_brt2)

	replace supply_IV_comp=log(supply_IV_comp)

	drop if stock==0

	drop if general_occ==.
		
	save "$final_data/[15]elasticity_data_CPS_2d.dta", replace
		
		
		




