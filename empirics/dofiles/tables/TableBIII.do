/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates elasticities at 1 digit occupations for the appendix table

Data from previous files 
********************************************/




********************************************
*1) 1 Digit
********************************************


use "$final_data/[15]elasticity_data_CPS_1d.dta", replace


duplicates drop general_occ year, force
 
 *
gen cons=.
gen cons_se=.

gen rhobas=.
gen rhobas_se=.

gen rho_OR=.
gen rho_OR_se=.
gen gam_OR=.
gen gam_OR_se=.
gen bias_OR=.
gen bias_OR_se=.
gen gamma_agg=.
gen gamma_agg_se=.

gen rhobas_IV=.
gen rhobas_IV_se=.
gen rho_ORIV=.
gen rho_ORIV_se=.

gen rho_OR_lag=.
gen rho_OR_lag_se=.
gen rho_OR_laglong=.
gen rho_OR_laglong_se=.
gen rho_ORIVall3_lag=.
gen rho_ORIVall3_lag_se=.
gen rho_ORIVall3_laglong=.
gen rho_ORIVall3_laglong_se=.

gen rho_OR_lag_kl=.
gen rho_OR_lag_kl_se=.
gen rho_ORIVall3_lag_kl=.
gen rho_ORIVall3_lag_kl_se=.

gen rho_ORIVdemand=.
gen rho_ORIVdemand_se=.
gen rho_ORIVsupply=.
gen rho_ORIVsupply_se=.
gen rho_ORIVsupply_brt=.
gen rho_ORIVsupply_brt_se=.
gen rho_ORIVsupply_brt2=.
gen rho_ORIVsupply_brt2_se=.

gen rho_ORIVpop=.
gen rho_ORIVpop_se=.
gen rho_ORIVbrt=.
gen rho_ORIVbrt_se=.

** Yield a different set of estimates
gen rhobas_IVall=.
gen rhobas_IVall_se=.
gen rho_ORIVall=.
gen rho_ORIVall_se=.

gen rhobas_IVall2=.
gen rhobas_IVall2_se=.
gen rho_ORIVall2=.
gen rho_ORIVall2_se=.

gen rhobas_IVall3=.
gen rhobas_IVall3_se=.
gen rho_ORIVall3=.
gen rho_ORIVall3_se=.


****** Economy wide estimatesgen rhobas_IVall=.

gen rhobasagg=.
gen rhobasagg_se=.
gen rho_ORagg=.
gen rho_ORagg_se=.

gen rhobas_IVagg=.
gen rhobas_IVagg_se=.
gen rho_ORIVagg=.
gen rho_ORIVagg_se=.

gen rho_ORagg_lag=.
gen rho_ORagg_lag_se=.
gen rho_ORagg_lag_kl=.
gen rho_ORagg_lag_kl_se=.
gen rho_ORagg_laglong=.
gen rho_ORagg_laglong_se=.

gen rho_ORIVdemandagg=.
gen rho_ORIVdemandagg_se=.

gen rho_ORIVsupplyagg=.
gen rho_ORIVsupplyagg_se=.

gen rho_ORIVsupply_brtagg=.
gen rho_ORIVsupply_brtagg_se=.
gen rho_ORIVsupply_brt2agg=.
gen rho_ORIVsupply_brt2agg_se=.

gen rho_ORIVpopagg=.
gen rho_ORIVpopagg_se=.
gen rho_ORIVbrtagg=.
gen rho_ORIVbrtagg_se=.

gen rhobas_IVallagg_se=.
gen rho_ORIVallagg=.
gen rho_ORIVallagg_se=.

gen rhobas_IVall2agg=.
gen rhobas_IVall2agg_se=.
gen rho_ORIVall2agg=.
gen rho_ORIVall2agg_se=.

gen rhobas_IVall3agg=.
gen rhobas_IVall3agg_se=.
gen rho_ORIVall3agg=.
gen rho_ORIVall3agg_se=.

gen rho_ORIVall3agg_lag=.
gen rho_ORIVall3agg_lag_se=.
gen rho_ORIVall3agg_lag_kl=.
gen rho_ORIVall3agg_lag_kl_se=.
gen rho_ORIVall3agg_laglong=.
gen rho_ORIVall3agg_laglong_se=.



egen id=group(general_occ)

xtset general_occ year
   g lag_wp=L.log_W_P
   g lag_pw=L.log_P_W
   g lag_S_H=L5.log_S_H
   g log2_pswl=L.log_pswl
   g log3_pswl=L2.log_pswl
 
 
  *******************ESTIMATES**************
 *With lagged pswl
*
 g F_stat=.
 g overid_Hstat=.
  g pvalue=.
 g rho_y=.
 g dfuller_z=.
g dfuller_vc=.
g dfuller_z_raw=.
g dfuller_vc_raw=.

 sort general_occ year
 replace demand_IV_trade=log(demand_IV_trade)
  replace demand_IV_tradecomp=log(demand_IV_tradecomp)
 replace demand_IV2_compgr=log(demand_IV2_compgr)
 replace inv_ware=log(inv_ware)
 replace stock_ware=log(stock_ware)

replace va=log(va)*trade
g t_brt_rt=L16.brt_rt
g ci_up=.
g ci_dw=.
drop if year<1984


*
foreach i of numlist 1(1)6 8 10(1)11 {
   disp "Group " `i'
  
   preserve
   keep if id==`i'
   tsset year
   ivreg2 log_S_H log_W_P year if id==`i', robust
 
   quietly: replace rho_OR = _b[log_W_P]               if id==`i'
   quietly: replace rho_OR_se = _se[log_W_P]               if id==`i'
  
      
   quietly: ivreg2 log_S_H log_W_P year lag_S_H if id==`i', robust

   quietly: replace rho_OR_lag = _b[log_W_P]/(1-_b[lag_S_H])              if id==`i'
   quietly: replace rho_OR_lag_se = _se[log_W_P]                 if id==`i'
   
   quietly: ivreg2 log_W_P log_S_H year if id==`i', robust
   nlcom (coef:1/_b[log_S_H]), post
   quietly: replace rhobas = _b[coef]               if id==`i'
   quietly: replace rhobas_se = _se[coef]                 if id==`i'
   est store reg_iv_`i'
   
   
   ivreg2 log_S_H year (log_W_P=supply_IV2_brt2)  if id==`i', first gmm2s robust
   quietly: replace gam_OR = _b[year]/_b[log_W_P]                if id==`i'
   quietly: replace gam_OR_se = _se[year]                if id==`i'
   quietly: replace rhobas_IVall=_b[log_W_P] if id==`i'
   quietly: replace rhobas_IVall_se=_se[log_W_P]  if id==`i'
   quietly: replace F_stat = `e(widstat)'   
   predict resid_spurr, resid 
   dfuller resid_spurr, nocons lags(1)
   replace dfuller_z_raw=r(Zt)
   replace dfuller_vc_raw=r(cv_5)
   
   quietly: ivreg2 log_W_P (log_S_H=supply_IV2_brt2) year if id==`i', robust
   nlcom (coef:1/_b[log_S_H]), post
   quietly: replace rhobas_IV = _b[coef]               if id==`i'
   quietly: replace rhobas_IV_se = _se[coef]                 if id==`i'
   
   quietly: ivreg2 log_S_H year lag_S_H (log_W_P=supply_IV2_brt2), first gmm2s robust 
     
   quietly: replace rho_ORIVall = _b[log_W_P]/(1-_b[lag_S_H])                if id==`i'
   quietly: replace rho_ORIVall_se = _se[log_W_P]               if id==`i'

   local t = _b[log_W_P]/_se[log_W_P]

  
   keep gam* rhobas* rho_OR* general_occ id F_stat over rho_y dfuller_* pvalue ci*
   tempfile output`i'
   save `output`i''

   restore
   
   }
   */
   
   
   
   *
   
   foreach i of numlist 6 8{
   disp "Group " `i'
  
   preserve
   keep if id==`i'
   tsset  year
   quietly: ivreg2 log_S_H log_W_P year if id==`i', robust

   quietly: replace rho_OR = _b[log_W_P]               if id==`i'
   quietly: replace rho_OR_se = _se[log_W_P]               if id==`i'
  
      
   quietly: ivreg2 log_S_H log_W_P year lag_S_H if id==`i', robust
   quietly: replace rho_OR_lag = _b[log_W_P]/(1-_b[lag_S_H])              if id==`i'
   quietly: replace rho_OR_lag_se = _se[log_W_P]                 if id==`i'
   

   ivreg2 log_S_H year (log_W_P=demand_IV_trade)  if id==`i', first gmm2s 

   est store reg_iv_`i'  
   quietly: replace gam_OR = _b[year]/_b[log_W_P]          if id==`i'
   quietly: replace gam_OR_se = _se[year]                if id==`i'
   quietly: replace rhobas_IVall=_b[log_W_P] if id==`i'
   quietly: replace rhobas_IVall_se=_se[log_W_P]  if id==`i'
   quietly: replace F_stat = `e(widstat)'   
   test _b[log_W_P]=1
   replace pvalue=`r(p)'
   
  
   predict resid_spurr, resid
   dfuller resid_spurr, nocons lags(1)
   replace dfuller_z_raw=r(Zt)
   replace dfuller_vc_raw=r(cv_5)
   quietly: ivreg2 log_S_H year  lag_S_H (log_W_P=demand_IV_trade), first gmm2s robust 


   quietly: replace rho_ORIVall = _b[log_W_P]/(1-_b[lag_S_H])                if id==`i'
   quietly: replace rho_ORIVall_se = _se[log_W_P]               if id==`i'
             
   local t = _b[log_W_P]/_se[log_W_P]
   replace ci_up=_b[log_W_P]+ invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
   replace ci_dw=_b[log_W_P]- invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
         
  
   keep gam* rhobas_IVall* rho_OR* general_occ id F_stat over rho_y dfuller_* pvalue ci*
   tempfile output`i'
   save `output`i''

   restore
   
   }
   

    
  use `output1', clear
 foreach i of numlist 2(1)6{
	append using `output`i''

}
append using `output8'
forvalues i=10(1)11{
	append using `output`i''

}


duplicates drop general_occ, force

keep F_stat   general_occ rho_OR rho_OR_se rhobas_IVall rhobas_IVall_se dfuller_z_raw

order  general_occ rho_OR rho_OR_se rhobas_IVall rhobas_IVall_se dfuller_z_raw F_stat 

outsheet using "$results/[TableB.III]Elasticity of substitution between capital and labor.xls", replace
keep general_occ rhobas_IVall
 export excel using "$model_data/Elasticities.xlsx", sheet(1_digit) sheetreplace firstrow(variables)

 
 
 * Aggregates estimations 
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
		


collapse (mean) k_price1d k_price_indx k_price_HCETC k_price_comp1d wage wage_predicted adj_wages adj_wages_minc population brt_rt total_exp* stock_occ share*  trade demand_ind (sum) supply_IV*  demand_IV* lag_supply_IV stock_all stock_HCETC stock_COMPUTERS hperwt* adj_lab wage_bill* perwt lag_share* lag_supply_skill lag_demand*, by( year)	

local alpha=0.24
g meaninputratio=44.79371
g inputratio=(total_exp/(wage_bill))*(meaninputratio)^(-1)*`alpha'/(1-`alpha')
g capsh=1/(1+inputratio^(-1))
g laborsh=1-capsh
	
merge 1:1 year using "$intermediate_data/[17]stock_agg_052021_base85_tmech_woag.dta", nogen
replace stock_occ=stock_ag
		
gen implied_usercost=total_exp/stock_occ
gen stock=stock_occ

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
tsset year

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
tsset year
gen lag_S_H=L5.log_S_H
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


replace supply_IV=log(supply_IV)

replace demand_IV=log(demand_IV)
replace demand_IV2=log(demand_IV2)
replace demand_IV2=log(demand_IV2_comp)



replace supply_IV_brt=log(supply_IV_brt)
replace supply_IV2_brt=log(supply_IV2_brt)
replace supply_IV2_brt2=log(supply_IV2_brt2)

replace supply_IV_comp=log(supply_IV_comp)

drop if stock==0

duplicates drop year, force
 
 *
gen cons=.
gen cons_se=.

gen rhobas=.
gen rhobas_se=.

gen rho_OR=.
gen rho_OR_se=.
gen gam_OR=.
gen gam_OR_se=.
gen bias_OR=.
gen bias_OR_se=.
gen gamma_agg=.
gen gamma_agg_se=.

gen rhobas_IV=.
gen rhobas_IV_se=.
gen rho_ORIV=.
gen rho_ORIV_se=.

gen rho_OR_lag=.
gen rho_OR_lag_se=.
gen rho_OR_laglong=.
gen rho_OR_laglong_se=.
gen rho_ORIVall3_lag=.
gen rho_ORIVall3_lag_se=.
gen rho_ORIVall3_laglong=.
gen rho_ORIVall3_laglong_se=.

gen rho_OR_lag_kl=.
gen rho_OR_lag_kl_se=.
gen rho_ORIVall3_lag_kl=.
gen rho_ORIVall3_lag_kl_se=.


gen rho_ORIVdemand=.
gen rho_ORIVdemand_se=.

gen rho_ORIVsupply=.
gen rho_ORIVsupply_se=.
gen rho_ORIVsupply_brt=.
gen rho_ORIVsupply_brt_se=.
gen rho_ORIVsupply_brt2=.
gen rho_ORIVsupply_brt2_se=.
gen rho_ORIVpop=.
gen rho_ORIVpop_se=.
gen rho_ORIVbrt=.
gen rho_ORIVbrt_se=.

** Yield a different set of estimates
gen rhobas_IVall=.
gen rhobas_IVall_se=.
gen rho_ORIVall=.
gen rho_ORIVall_se=.

gen rhobas_IVall2=.
gen rhobas_IVall2_se=.
gen rho_ORIVall2=.
gen rho_ORIVall2_se=.

gen rhobas_IVall3=.
gen rhobas_IVall3_se=.
gen rho_ORIVall3=.
gen rho_ORIVall3_se=.


****** Economy wide estimatesgen rhobas_IVall=.

gen rhobasagg=.
gen rhobasagg_se=.
gen rho_ORagg=.
gen rho_ORagg_se=.

gen rhobas_IVagg=.
gen rhobas_IVagg_se=.
gen rho_ORIVagg=.
gen rho_ORIVagg_se=.

gen rho_ORagg_lag=.
gen rho_ORagg_lag_se=.
gen rho_ORagg_lag_kl=.
gen rho_ORagg_lag_kl_se=.
gen rho_ORagg_laglong=.
gen rho_ORagg_laglong_se=.

gen rho_ORIVdemandagg=.
gen rho_ORIVdemandagg_se=.

gen rho_ORIVsupplyagg=.
gen rho_ORIVsupplyagg_se=.

gen rho_ORIVsupply_brtagg=.
gen rho_ORIVsupply_brtagg_se=.
gen rho_ORIVsupply_brt2agg=.
gen rho_ORIVsupply_brt2agg_se=.

gen rho_ORIVpopagg=.
gen rho_ORIVpopagg_se=.
gen rho_ORIVbrtagg=.
gen rho_ORIVbrtagg_se=.

gen rhobas_IVallagg_se=.
gen rho_ORIVallagg=.
gen rho_ORIVallagg_se=.

gen rhobas_IVall2agg=.
gen rhobas_IVall2agg_se=.
gen rho_ORIVall2agg=.
gen rho_ORIVall2agg_se=.

gen rhobas_IVall3agg=.
gen rhobas_IVall3agg_se=.
gen rho_ORIVall3agg=.
gen rho_ORIVall3agg_se=.

gen rho_ORIVall3agg_lag=.
gen rho_ORIVall3agg_lag_se=.
gen rho_ORIVall3agg_lag_kl=.
gen rho_ORIVall3agg_lag_kl_se=.
gen rho_ORIVall3agg_laglong=.
gen rho_ORIVall3agg_laglong_se=.



   
gen rho_ORIVallaggcollapse=.
gen rho_ORIVallaggcollapse_se=.
gen rho_ORIVall2aggcollapse=.
gen rho_ORIVall2aggcollapse_se=.
gen rho_ORIVall3aggcollapse=.
gen rho_ORIVall3aggcollapse_se=.
gen rho_basIVall3aggcollapse=.
gen rho_basIVall3aggcollapse_se=.
gen  rho_ORallcollapse =.
g rho_ORallcollapse_se =.
g  rho_basallcollapse=.
g  rho_basallcollapse_se=.
   
gen rho_ORIVall3aggcoll_lag=.
gen rho_ORIVall3aggcoll_lag_se=.
gen rho_ORIVall3aggcoll_lag_kl=.
gen rho_ORIVall3aggcoll_lag_kl_se=.
   
gen rho_ORIVall3aggcoll_laglong=.
gen rho_ORIVall3aggcoll_laglong_se=.
   
g bias_agg=.
g bias_agg_se=.
g dfuller_z_raw=.
g dfuller_vc_raw=.
g F_stat=.
      
	ivreg2 log_S_H log_W_P  year 
   quietly: replace rho_basallcollapse = _b[log_W_P]               
   quietly: replace rho_basallcollapse_se = _se[log_W_P]
   
   ivreg2 log_S_H  (log_W_P=brt_rt_shifter)  year, gmm2s robust

   quietly: replace F_stat = `e(widstat)'  
   quietly: replace rho_ORIVall2aggcollapse = _b[log_W_P]                 
   quietly: replace rho_ORIVall2aggcollapse_se = _se[log_W_P]  
   quietly: replace gamma_agg = _b[year]/_b[log_W_P]                      
   quietly: replace gamma_agg_se = _se[year]  
   
   g cap_share=_b[_cons]+log_S_H*(_b[log_W_P])-_b[year]*year
   g cap_sh=expm1(cap_share)+1

   
	predict resid_spurr, resid
    dfuller resid_spurr, nocons lags(1)
    replace dfuller_z_raw=r(Zt)
    replace dfuller_vc_raw=r(cv_5)
   


keep   rho_basallcollapse rho_basallcollapse_se rho_ORIVall2aggcollapse rho_ORIVall2aggcollapse_se dfuller_z_raw F_stat

 duplicates drop

order   rho_basallcollapse rho_basallcollapse_se rho_ORIVall2aggcollapse rho_ORIVall2aggcollapse_se dfuller_z_raw F_stat 

outsheet using "$results/[TableB.III]Elasticity of substitution between capital and labor_aggregates.xls", replace

keep rho_ORIVall2aggcollapse
export excel using "$model_data/Elasticities.xlsx", sheet(Aggregate_Elasticity) sheetreplace firstrow(variables)


  
