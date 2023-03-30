
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file estimates elasticities 2 digit occupations

Data from previous files 
********************************************/




********************************************
*1) 1 Digit
********************************************


use "$final_data/[15]elasticity_data_CPS_2d.dta", replace
*keep if log_P_W~=. & log_L_S~=.
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
/********************* FIRST STAGE REGRESSIONS*******************
foreach i of numlist 8,12{
*local i=1
   disp "Group " `i'
*** good for all except 12
   reg log_W_P brt_rt_shifter_occ log_pswl year if id==`i'
   }
   
   foreach i of numlist 8,12{
*local i=1
   disp "Group " `i'
* gOOD FOR 10-12-5-4
   reg log_W_P supply_IV log_pswl year if id==`i'
   
   }
   return
  */
  *
   
   g log2_pswl=L.log_pswl
   g log3_pswl=L2.log_pswl
   






   *******************ESTIMATES**************
 *keep if year>1984
 
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
*
g ci_up=.
g ci_dw=.
drop if year<1984
*
foreach i of numlist 1(1)21 {
	*local i=1
   disp "Group " `i'
  
   preserve
   keep if id==`i'
   tsset year
  quietly: ivreg2 log_S_H log_W_P year if id==`i', robust
  *nlcom (coef:1-1/_b[log_W_P]), post
  quietly: replace rho_OR = _b[log_W_P]               if id==`i'
   quietly: replace rho_OR_se = _se[log_W_P]               if id==`i'
  
      
  quietly: ivreg2 log_S_H log_W_P year lag_S_H if id==`i', robust
  *nlcom (coef:1/_b[log_W_P]), post
  quietly: replace rho_OR_lag = _b[log_W_P]/(1-_b[lag_S_H])              if id==`i'
   quietly: replace rho_OR_lag_se = _se[log_W_P]                 if id==`i'
   
   quietly: ivreg2 log_W_P log_S_H year if id==`i', robust
  nlcom (coef:1/_b[log_S_H]), post
  quietly: replace rhobas = _b[coef]               if id==`i'
   quietly: replace rhobas_se = _se[coef]                 if id==`i'
   est store reg_iv_`i'
   
   *reg log_W_P demand_IV_trade year
 

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
   *
    
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
   
   

   foreach i of numlist 1(1)6{
*	local i=1
   disp "Group " `i'
  
   preserve
   keep if id==`i'
   tsset  year
  quietly: ivreg2 log_S_H log_W_P year if id==`i', robust
  *nlcom (coef:1-1/_b[log_W_P]), post
  quietly: replace rho_OR = _b[log_W_P]               if id==`i'
   quietly: replace rho_OR_se = _se[log_W_P]               if id==`i'
  
      
  quietly: ivreg2 log_S_H log_W_P year lag_S_H if id==`i', robust
  *nlcom (coef:1-1/_b[log_W_P]), post
  quietly: replace rho_OR_lag = _b[log_W_P]/(1-_b[lag_S_H])              if id==`i'
   quietly: replace rho_OR_lag_se = _se[log_W_P]                 if id==`i'
   

   ivreg2 log_S_H year (log_W_P=stock_ware)  if id==`i', first gmm2s 

      est store reg_iv_`i'  
      quietly: replace gam_OR = _b[year]/_b[log_W_P]          if id==`i'
   quietly: replace gam_OR_se = _se[year]                if id==`i'
quietly: replace rhobas_IVall=_b[log_W_P] if id==`i'
quietly: replace rhobas_IVall_se=_se[log_W_P]  if id==`i'
quietly: replace F_stat = `e(widstat)'   
 test _b[log_W_P]=1
   replace pvalue=`r(p)'
    
   *
         predict resid_spurr, resid
   dfuller resid_spurr, nocons lags(1)
    replace dfuller_z_raw=r(Zt)
   replace dfuller_vc_raw=r(cv_5)
   *
   quietly: ivreg2 log_S_H year  lag_S_H (log_W_P=demand_IV_trade), first gmm2s robust 

*nlcom (coef:1-1/_b[log_W_P]), post
   quietly: replace rho_ORIVall = _b[log_W_P]/(1-_b[lag_S_H])                if id==`i'
   quietly: replace rho_ORIVall_se = _se[log_W_P]               if id==`i'

*quietly: replace F_stat = `e(widstat)'                     
   local t = _b[log_W_P]/_se[log_W_P]
   *replace pvalue = 2*ttail(3,abs(`t'))    
     replace ci_up=_b[log_W_P]+ invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
    replace ci_dw=_b[log_W_P]- invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
   
         
  
   keep gam* rhobas_IVall* rho_OR* general_occ id F_stat over rho_y dfuller_* pvalue ci*
   tempfile output`i'
   save `output`i''

   restore
   
   }
   
    foreach i of numlist 17 18{
*	local i=1
   disp "Group " `i'
  
   preserve
   keep if id==`i'
   tsset  year
  quietly: ivreg2 log_S_H log_W_P year if id==`i', robust
  *nlcom (coef:1-1/_b[log_W_P]), post
  quietly: replace rho_OR = _b[log_W_P]               if id==`i'
   quietly: replace rho_OR_se = _se[log_W_P]               if id==`i'
  
      
  quietly: ivreg2 log_S_H log_W_P year lag_S_H if id==`i', robust
  *nlcom (coef:1-1/_b[log_W_P]), post
  quietly: replace rho_OR_lag = _b[log_W_P]/(1-_b[lag_S_H])              if id==`i'
   quietly: replace rho_OR_lag_se = _se[log_W_P]                 if id==`i'
   
   *reg log_W_P demand_IV_trade year
   *ivreg2 log_S_H year (log_W_P=demand_IV_tradecomp)  if id==`i', first gmm2s 
 ivreg2 log_S_H year (log_W_P=demand_IV_trade)  if id==`i', first gmm2s 
 *  ivreg2 log_S_H year (log_W_P=stock_ware)  if id==`i', first gmm2s 
   *robust 
   *nlcom (coef:1-1/_b[log_W_P]), post
      est store reg_iv_`i'  
      quietly: replace gam_OR = _b[year]/_b[log_W_P]          if id==`i'
   quietly: replace gam_OR_se = _se[year]                if id==`i'
quietly: replace rhobas_IVall=_b[log_W_P] if id==`i'
quietly: replace rhobas_IVall_se=_se[log_W_P]  if id==`i'
quietly: replace F_stat = `e(widstat)'   
 test _b[log_W_P]=1
   replace pvalue=`r(p)'
   
   *quietly: replace overid_Hstat = `e(jp)'               if id==`i'   
   *
         predict resid_spurr, resid
   dfuller resid_spurr, nocons lags(1)
    replace dfuller_z_raw=r(Zt)
   replace dfuller_vc_raw=r(cv_5)
   *
   quietly: ivreg2 log_S_H year  lag_S_H (log_W_P=demand_IV_trade), first gmm2s robust 

*nlcom (coef:1-1/_b[log_W_P]), post
   quietly: replace rho_ORIVall = _b[log_W_P]/(1-_b[lag_S_H])                if id==`i'
   quietly: replace rho_ORIVall_se = _se[log_W_P]               if id==`i'

*quietly: replace F_stat = `e(widstat)'                     
   local t = _b[log_W_P]/_se[log_W_P]
   *replace pvalue = 2*ttail(3,abs(`t'))    
     replace ci_up=_b[log_W_P]+ invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
    replace ci_dw=_b[log_W_P]- invttail(e(df_r),0.5)*_se[log_W_P] if id==`i'
         
  
   keep gam* rhobas_IVall* rho_OR* general_occ id F_stat over rho_y dfuller_* pvalue ci*
   tempfile output`i'
   save `output`i''

   restore
   
   }
  
   
   
  
   use `output1', clear
 foreach i of numlist 2(1)21{
	append using `output`i''

}

duplicates drop general_occ, force




    replace ci_up=rhobas_IVall+ invttail(3,0.1)* rhobas_IVall_se 
    replace ci_dw=rhobas_IVall- invttail(3,0.1)* rhobas_IVall_se 
	tab general_occ

	**elast aggregation 21 categories
	ren general_occ occ_2d
     gen occp = "housekeeping"             			if occ_2d == 1
replace occp = "protective"     			if occ_2d == 2
replace occp = "food prep."      if occ_2d == 3
replace occp = "health serv."         			if occ_2d == 4
replace occp = "cleaning"       			if occ_2d == 5
replace occp = "personal"             			if occ_2d == 6
replace occp = "child-care" 			if occ_2d ==7

replace occp = "managers"  			if occ_2d == 8
   replace occp = "mgmt relat."             			if occ_2d == 9
replace occp = "professionals"     			if occ_2d == 10
replace occp = "technicians"     if occ_2d == 11
replace occp = "financ. sales"         			if occ_2d == 12
replace occp = "retail"        			if occ_2d == 13
replace occp = "admin"             			if occ_2d == 14
replace occp =   "farm"  			if occ_2d == 15
replace occp = "other agric." 			if occ_2d ==16
replace occp = "mech. & transp."     			if occ_2d == 17
replace occp = "construction"  			if occ_2d == 18
replace occp = "mining"             			if occ_2d == 19
replace occp =   "precision"  			if occ_2d == 20
replace occp = "machine op." 			if occ_2d ==21


gen order_pict=occ_2d

drop if occ_2d==15|occ_2d==16|occ_2d==19

forvalues i=1(1)7{
replace order_pict=`i' if occ_2d==`i'
}
*mech and transp
replace order_pict=8 if occ_2d==17
*construct
replace order_pict=9 if occ_2d==18
*machine operator
replace order_pict=10 if occ_2d==21
**precision
replace order_pict=11 if occ_2d==20
**admin
replace order_pict=12 if occ_2d==14
**sales
replace order_pict=13 if occ_2d==12
replace order_pict=14 if occ_2d==13
**technicians
replace order_pict=15 if occ_2d==11
**professionals
replace order_pict=16 if occ_2d==10
**managers
replace order_pict=17 if occ_2d==8
replace order_pict=18 if occ_2d==9

gen round_est=round(rhobas_IVall, 0.05)
sort occ_2d
tw (scatter rhobas_IVall order_pict,  msize(small) mlabel(round_est)) (scatter ci_up order_pict, msize(small) mcolor(red) msymbol(plus)) (scatter ci_dw order_pict, msize(small)  mcolor(red) msymbol(plus)), ymtick(0(1)3) xtitle("") xmtick(1(1)9.5) xlabel(1 "house" 2"protect" 3"food" 4"health" 5"clean" 6"pers" 7"child" 8 "mech. & transp." 9 "const" 10 "machine op."  11 "precision"  12 "admin." 13 " fin sales" 14 "sales" 15 "technicians" 16 "profess." 17 "mgrs" 18"oth mgrs" , angle(55)) ytitle("elasticity of substitution") legend(off) graphregion(margin(right) fcolor(white) lcolor(white)) 
 graph export "$results/[FigureXX]elasticities_2d.pdf",as(pdf) replace
 
 
preserve
order occ_2d
replace rhobas_IVall=round(rhobas_IVall, 0.05)
keep F_stat   occp rho_OR rho_OR_se rhobas_IVall rhobas_IVall_se dfuller_z_raw

order  occp rho_OR rho_OR_se rhobas_IVall rhobas_IVall_se dfuller_z_raw F_stat 

outsheet using "$results/[TableXX]Elasticity of substitution 2 digit between capital and labor.xls", replace

restore

 
 
