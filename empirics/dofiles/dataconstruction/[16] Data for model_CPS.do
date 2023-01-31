/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file prepara data on employment for model and descriptive figures

Data from previous files 
********************************************/

use "$intermediate_data/[15]usercost_implied_base85.dta", clear


* Loop by year
    foreach year of numlist 1985(1)2016{

use "$intermediate_data/[6]employmentCPS_`year'_byhours.dta",clear

		*** SKILL GROUPS TO CONSIDER
	*1 By gender
		gen g1_male =  1 if sex == 1
		replace g1_male =0 if sex == 2
		
	*2 By education 	
		gen g2_highed =  1 if educ >=2  // college or more
		*redefinition, see code [6]
		replace g2_highed =0 if educ <2  // less than college
		
	*3 By age
		gen     g3_age = 1 if age >= 16 & age <=29
		replace g3_age = 2 if age >= 30 & age <=49
		replace g3_age = 3 if age >= 50 & age <=65
	
	drop if educ==.
		
		keep occ2d hperwt perwt wage occ1990dd labor_inc g1_male g2_highed g3_age hours occ1d wkswork1
	

		replace hperwt=hperwt/perwt

		tab occ1d
	replace occ1d=8 if occ1d==12
	g aux=1
		collapse (sum) aux hperwt (mean) wage labor_inc occ1990dd (first) occ1d [pw = perwt], by(occ2d g1_male g2_highed g3_age)
				ren aux perwt


		capture drop year
		gen year = `year'
		merge m:1 occ2d year using  "$intermediate_data/[11]stocks_bydetailedequipmentCPS_DOTONET_base85.dta"
			
		
		keep if _merge == 3

	    drop _merge
	    merge m:1 occ1990dd using "$raw_data/Crosswalks/occ1990dd_task_alm.dta"
		
	    	
	   
	* Normalizing the indexes
		gen task_abstract_original = task_abstract
		gen task_routine_original = task_routine
		gen task_manual_original = task_manual

		summ task_abstract_original , det
		replace task_abstract_original = r(p5) if task_abstract_original < r(p5)
		summ task_manual_original , det
		replace task_manual_original = r(p5) if task_manual_original < r(p5)
		
		gen routine_index = ln(task_routine_original)-ln(task_abstract_original)-ln(task_manual_original)
		
		sum task_abstract
		replace task_abstract = (task_abstract-r(mean))/r(sd)
		sum task_routine
		replace task_routine = (task_routine-r(mean))/r(sd)
		sum task_manual
		replace task_manual = (task_manual-r(mean))/r(sd)
		
       
		keep occ1d g1_male routine_index g2_highed g3_age occ2d hperwt wage labor_inc computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts ///
		 other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts task_abstract task_routine task_manual computers communication med_ins non_med_ins photocopy office ///
		 metal_products engines metal_machinery special_machinery general_industry_machinery elctrical_trans aircraft ships rail ///
		 other_transport furniture agricultural construction mining service electrical cars_trucks software // Only keep variables that would be needed
		
		
		drop if occ1d==7 | occ1d==9
		


	
		saveold "$intermediate_data/[16]Data_for_model_CPS_`year'_DOTONET_base85.dta", replace
*/
	
	
		*Base 2** Collpase to have a dataset with Number of workers, wage, and capital stok by detail equipment by occupation 1 digit, skill,gender AND AGE

		use "$intermediate_data/[16]Data_for_model_CPS_`year'_DOTONET_base85.dta", clear
	


		*preserve
				*weights within 2 digit 
		bys occ2d: egen total_emp_group = sum(hperwt)
		
		gen share_emp = hperwt/total_emp_group
		
		

		foreach v in computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts ///
		 metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts ///
		 other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts{
			gen `v'_e = hperwt if `v'~= 0 & `v'~=.
			}
		
		preserve
		collapse (sum) total_emp = hperwt computers_ts_e communication_ts_e med_ins_ts_e non_med_ins_ts_e photocopy_ts_e office_ts_e ///
		 metal_products_ts_e engines_ts_e metal_machinery_ts_e special_machinery_ts_e general_industry_machinery_ts_e elctrical_trans_ts_e aircraft_ts_e ships_ts_e rail_ts_e ///
		 other_transport_ts_e furniture_ts_e agricultural_ts_e construction_ts_e mining_ts_e service_ts_e electrical_ts_e cars_trucks_ts_e software_ts_e, by(occ1d g1_male g2_highed g3_age)
		* return
		tempfile temp
    	save `temp', replace
    	restore

		

	**Distributes the stock across groups
		foreach v in computers communication med_ins non_med_ins photocopy office metal_products engines metal_machinery special_machinery general_industry_machinery elctrical_trans aircraft ships rail other_transport furniture agricultural construction mining service electrical cars_trucks software{
			replace `v'_ts =`v'_ts *share_emp
			replace `v' =`v' *share_emp
		}
		
		** Share for variables that vary within a 3d
		bys occ2d g1_male g2_highed g3_age: egen total_emp_group2 = sum(hperwt)
		gen share_emp2 = hperwt/total_emp_group2
		bys occ1d: egen total_emp_1group=sum(hperwt)
		gen share_emp3d=total_emp_group/total_emp_1group
		
		foreach v in task_abstract task_routine task_manual labor_inc wage{
		replace `v' =`v' *share_emp2*share_emp3d
		}
	

collapse (sum) computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts ///
		 metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts ///
		 other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts (mean) computers communication med_ins non_med_ins photocopy office ///
		 metal_products engines metal_machinery special_machinery general_industry_machinery elctrical_trans aircraft ships rail ///
		 other_transport furniture agricultural construction mining service electrical cars_trucks software ///
		 (sum) task_abstract task_routine task_manual labor_inc wage, by(occ1d g1_male g2_highed g3_age)

		 
	merge 1:1 occ1d g1_male g2_highed g3_age using `temp', keep(match) nogen
	
	foreach v in computers communication med_ins non_med_ins photocopy office metal_products engines metal_machinery special_machinery general_industry_machinery elctrical_trans aircraft ships rail other_transport furniture agricultural construction mining service electrical cars_trucks software{
			ren `v'_ts_e `v'_e 
		}
		* Save data with stock per worker
		order occ1d g1_male g2_highed g3_age computers communication med_ins non_med_ins photocopy office metal_products engines metal_machinery special_machinery general_industry_machinery ///
		elctrical_trans aircraft ships rail other_transport furniture agricultural construction mining service electrical cars_trucks software ///
		task_abstract task_routine task_manual labor_inc wage total_emp ///
		computers_ts communication_ts med_ins_ts non_med_ins_ts photocopy_ts office_ts ///
		 metal_products_ts engines_ts metal_machinery_ts special_machinery_ts general_industry_machinery_ts elctrical_trans_ts aircraft_ts ships_ts rail_ts ///
		 other_transport_ts furniture_ts agricultural_ts construction_ts mining_ts service_ts electrical_ts cars_trucks_ts software_ts ///
		 computers_e communication_e med_ins_e non_med_ins_e photocopy_e office_e ///
		 metal_products_e engines_e metal_machinery_e special_machinery_e general_industry_machinery_e elctrical_trans_e aircraft_e ships_e rail_e ///
		 other_transport_e furniture_e agricultural_e construction_e mining_e service_e electrical_e cars_trucks_e software_e

		saveold "$intermediate_data/[16]Data_CPS_by_age_skill_gender_occ1d_`year'_DOTONET_base85.dta", replace
		outsheet using "$intermediate_data/[16]Data_CPS_by_age_skill_gender_occ1d_`year'_DOTONET_base85.csv", replace comma
}

forvalues i=1985(1)2016{

	use "$intermediate_data/[16]Data_CPS_by_age_skill_gender_occ1d_`i'_DOTONET_base85.dta"
	export excel using "$model_data/empstocks_byocc.xlsx", sheet(`i') sheetreplace firstrow(variables)

}

****Creating Stocks and Prices*****



use "$final_data/[10]stocks_occuCPS_2020_byhours_1d_agg3d_DOTONET_base85_expnorm.dta", clear

keep year occ1d stock_occ 
drop if year<1985
drop if year>2016
sort year occ1d 
export excel using "$model_data/CETCstocks_byocc.xlsx", sheet("Stock") sheetreplace firstrow(variables)


********************************************************************
* Cost of Capital By 1 digit occupation, Bartiks
*****************************************************
use "$intermediate_data/[11]stocks_bydetailedequipmentCPS_noreshape_byhours_1d_from3d_DOTONET_base85.dta", clear

	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	ren pcepi cpi
	gen pipc = price_/cpi

	drop _merge


	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)

	gen expense=total_stock*usercost/cpi_84 if year==1985
	bys occ1d: egen aux=total(expense) if year==1985
	g share_eq_exp_85=expense/aux
	bys occ1d nipa_code: egen share_eq_exp=mean(share_eq_exp_85)
	sort occ1d nipa_code year

	gen average_sh = 0.5*(share_eq_exp[_n] +share_eq_exp[_n-1])  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1]
	replace average_sh=share_eq_exp if year==1985
	sort occ1d nipa_code year
	gen usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi_84/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] & year==1986

	replace usercost_gr=log(usercost[_n]/usercost[_n-1]*cpi[_n-2]/cpi[_n-1])*average_sh  if nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1]  & year>1986
	bys occ1d year: egen user_gr=total(usercost_gr)
	keep occ1d year user_gr
	duplicates drop
	drop if year<1985
	drop if year>2016
	export excel using "$model_data/CETCstocks_byocc.xlsx", sheet("Instrument") sheetreplace firstrow(variables)

	

use "$intermediate_data/[15]usercost_implied_base85.dta", clear

drop if year<1985
drop if year>2016
export excel using "$model_data/CETCstocks_byocc.xlsx", sheet("Pk") sheetreplace firstrow(variables)

ren implied_usercost k_price

sort occ1d year

bys occ1d: gen normp=k_price if year==1985
    bys occ1d: egen normalize=mean(normp)

levelsof(occ1d), local(locc1d)
foreach i of local locc1d{
gen level_total_`i'=log(k_price)-log(normalize) if occ1d==`i'
}
keep if year>=1985 & year<=2016

keep k_price year occ1d
reshape wide k_price, i(occ1d) j(year)
gen g_kprice=(k_price2016/k_price1985)^(1/31)-1
edit occ1d g_kprice
ren g_kprice implied

keep implied occ1d
export excel using "$model_data/CETC_data.xlsx", sheet("Sheet1") sheetreplace firstrow(variables)
clear



****CAPITAL PRICES

use "$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"

keep nipa_code year usercost
export excel using "$model_data/CETC_bycapitaltype.xlsx", sheet("usercost") sheetreplace firstrow(variables)
clear

use "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
export excel using "$model_data/CETC_bycapitaltype.xlsx", sheet("pc") sheetreplace firstrow(variables)
clear



**** Elasticity of substitution across capital goods


use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear



merge m:1 year nipa_code using"$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"
	drop if year<1984 | year>2016
	drop if nipa_code==99
sort occ2d nipa_code year



sort occ2d nipa_code year
gen stockexp=stock*usercost/cpi[_n-1] if occ2d[_n]==occ2d[_n-1] & nipa_code[_n]==nipa_code[_n-1]
egen cpi84=mean(cpi) if year==1984
egen cpi_84=mean(cpi84)
replace stockexp=stock*usercost/cpi_84 if year==1985

** One per 3-digit nipa_code
replace occ1d=8 if occ1d==12

collapse (sum) stockexp (mean) usercost, by(occ1d nipa_code year)
drop if occ1d==.
bys occ1d year: gen stockexp_COMPUTERS=stockexp if  nipa_code == 4  
bys occ1d year: gen usercost_COMPUTERS=usercost if  nipa_code == 4 
bys occ1d year: egen base_exp=mean(stockexp_COMPUTERS)
bys occ1d year: egen base_userc=mean(usercost_COMPUTERS)

gen log_expratio=ln(stockexp/base_exp)
*
gen log_priceratio=ln(usercost/base_userc)

gen log_usercost=ln(usercost)
gen log_baseuserc=ln(base_userc)
gen log_base_exp=ln(base_exp)

sort occ1d nipa_code year
gen lag_log_expratio=log_priceratio[_n-1] if nipa_code[_n]==nipa_code[_n-1] & occ1d[_n]==occ1d[_n-1]

sort occ1d nipa_code year
gen dif_log_priceratio=log_priceratio[_n]-log_priceratio[_n-1] if nipa_code[_n]==nipa_code[_n-1] & occ1d[_n]==occ1d[_n-1]
gen dif_log_expratio=log_expratio[_n]-log_expratio[_n-1] if nipa_code[_n]==nipa_code[_n-1] & occ1d[_n]==occ1d[_n-1]


* Variables to store estimations

gen gammaagg_cap=.
gen gammaagg_cap_se=.



levelsof nipa_code, local(gnipa) 
   forvalues i=1(1)11{
   gen dumocc_`i'=0
   replace dumocc_`i'=1 if occ1d==`i'
   gen yearocc_`i'=0
   replace yearocc_`i'=year if occ1d==`i'
   foreach s of local gnipa{
 gen yearnipa_`i'_`s'=0
   replace yearnipa_`i'_`s'=year if nipa_code==`s' & occ1d==`i'

}
}


*without trend, with capital-specific trend
reg log_expratio log_priceratio 
 quietly: replace gammaagg_cap = 1-_b[log_priceratio]               
   quietly: replace gammaagg_cap_se = _se[log_priceratio] 
   
keep gammaagg_cap gammaagg_cap_se
duplicates drop

export excel using "$model_data/ES_capital_goods.xlsx", sheet("gamma") sheetreplace firstrow(variables)



**** Tail of the Frechet distribution
clear

	foreach i of numlist 1983(1)2016{
		*local i=1980
	use "$intermediate_data/[6]employmentCPS_`i'_byhours.dta",clear	

	replace hperwt=hperwt/perwt
	gen hperwt_high=hperwt if educ==2
	gen hperwt_low=hperwt if educ==1

	gen ageg=3 if age >=50 & age <=65 
	replace ageg=2 if  age >=30 & age <=49 
	replace ageg=1 if age >=16 & age <=29 
	
		xi: reg log_wage i.sex i.ageg i.educ i.occ1d [pw=perwt], robust
		predict resid if e(sample), residuals   // residuals
		gen eresid=exp(-resid)
		*negative becausse this should be the inverse of the residual.
		keep eresid sex ageg educ occ1d perwt log_wage resid year
		*	save "`path_base'/wageresiduals`i'_CPS_52021_jme.dta", replace
		gen bcoef=.
		gen ccoef=.
			gen bcoef_se=.
		gen ccoef_se=.
		weibullfit eresid, cluster(occ1d)
		mat res=e(b)
		mat reses=e(V)

		replace bcoef=res[1,1]
		replace bcoef_se=reses[1,1]
		replace ccoef=res[1,2]
		replace ccoef_se=reses[2,2]

		matrix drop _all
		duplicates drop bcoef, force
		keep bcoef* ccoef* year
	save "$intermediate_data/[16]theta_estimates`i'_CPS.dta", replace
			
	}
	*/
	use "$intermediate_data/[16]theta_estimates1983_CPS.dta", clear
	forvalues i=1984(1)2016{
		append using  "$intermediate_data/[16]theta_estimates`i'_CPS.dta"
	}
	

export excel using "$model_data/TailFrechet.xlsx", sheet("yearly") sheetreplace firstrow(variables)

egen av_bcoef = mean(bcoef)

keep av_bcoef
duplicates drop 
export excel using "$model_data/TailFrechet.xlsx", sheet("average") sheetreplace firstrow(variables)
	

