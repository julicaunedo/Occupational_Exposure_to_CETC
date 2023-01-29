/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file prepares the data for the estimation of the elasticities

Data from previous files 
********************************************/



************************************************************************
*1- digit occupations	
************************************************************************	
	


*
foreach i of numlist 1985(1)2016{
	use "$intermediate_data/[6]employmentCPS_`i'_byhours.dta",clear	


	replace hperwt=hperwt/perwt
	gen hperwt_high=hperwt if educ==2
	gen hperwt_low=hperwt if educ==1
	

	preserve
	bys occ1d: egen total_emp=sum(hperwt)
	bys occ2d educ: egen emp_educ=sum(hperwt)
	gen sh_emp_educ=emp_educ/total_emp
	gen sh_emp_high=sh_emp_educ if educ==1
	gen sh_emp_low=sh_emp_educ if educ==2
	duplicates drop occ1d educ, force
	collapse (sum) sh_emp_* (first) year, by(occ1d)
    save "$intermediate_data/[14]adjustment_stocks_`i'_educ.dta", replace
	restore
	
	replace occ1d=8 if occ1d==12

		merge m:1 occ1d year using "$intermediate_data/[12]usercost_occ_by_equipment_upt_CPS_1d_from3d_DOTONET_base85.dta"   // Merge with prices
	drop if _merge !=3	
	drop _merge k_price1d
		 	merge m:1 occ1d year using "$intermediate_data/[12]usercost_index_base85.dta"   // Merge with prices
		ren usercost_index k_price1d
		
			drop if _merge !=3	
			drop _merge aux
	merge m:1 occ1d year using "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_1d_from3d_DOTONET_equipment_base85.dta"
	drop if _merge!=3
	
	gen ageg=3 if age >=50 & age <=65 
	replace ageg=2 if  age >=30 & age <=49 
	replace ageg=1 if age >=16 & age <=29 
	
	
	xi: reg log_wage i.sex exp exp2 i.educ [pw=perwt], robust
		predict resid if e(sample), residuals   // residuals
	
	*format wage_predicted_sex_age_educ
	gen wage_predicted_1_1_1 = _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons] // Wages for males-aged 24-with lt college completed
	gen wage_predicted_1_2_1 = _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons] // Wages for males-aged 40-with  lt college completed
	gen wage_predicted_1_3_1 = _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons] // Wages for males-aged 58-with  lt college completed
	gen wage_predicted_2_1_1 = _b[_Isex_2] + _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons] // Wages for females-aged 24-with  lt college completed
	gen wage_predicted_2_2_1 = _b[_Isex_2] + _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons] // Wages for females-aged 40-with  lt college completed
	gen wage_predicted_2_3_1 = _b[_Isex_2] + _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons] // Wages for females-aged 58-with  lt college completed
	
	gen wage_predicted_1_1_2 = _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 24-with college completed
	gen wage_predicted_1_2_2 = _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 40-with college completed
	gen wage_predicted_1_3_2 = _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 58-with  college completed
	gen wage_predicted_2_1_2 = _b[_Isex_2] + _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 24-with  college completed
	gen wage_predicted_2_2_2 = _b[_Isex_2] + _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 40-with  college completed
	gen wage_predicted_2_3_2 = _b[_Isex_2] + _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 58-with  college completed
	
	g aux=1
	
	*gen aver_wage_minc=wage_predicted_1_1_1 if educ==1 & sex==1 & ageg==1
	gen adj_wages_minc=.
	forvalues edui=1(1)2{
		forvalues sexi=1(1)2{
			forvalues agei=1(1)3{
				replace adj_wages_minc=wage_predicted_`sexi'_`agei'_`edui'/wage_predicted_1_1_1 if sex==`sexi' & ageg==`agei' & educ==`edui'
			}
		}
		}
		
	*******************************************************
	**** RAW wage
	*BASELINE GROUP, Low educ, young males
	gen aver_wage=wage if educ==1 & sex==1 & ageg==1
	bys occ1d: egen aver_wage_lowskill=mean(aver_wage)
	if `i'==1985{
		gen aver_wage_lowskill80=aver_wage_lowskill
		preserve
        keep aver_wage_lowskill80 occ1d educ sex ageg
		duplicates drop aver_wage_lowskill80 sex ageg occ1d educ, force
		tempfile temp
		save `temp', replace
		restore
	}
	drop aver_wage
	
	bys occ1d sex educ ageg: egen aver_wage=mean(wage)
	
	
	gen adj_wages=aver_wage/aver_wage_lowskill 
	replace adj_wages=1 if educ==1 & sex==1 & ageg==1
	
	gen adj_lab_minc=hperwt*adj_wages_minc
	gen adj_lab=hperwt*adj_wages
	gen adj_lab_high=adj_lab if educ==2
	gen adj_lab_low=adj_lab if educ==1
	
	 
	merge m:1 occ1d educ sex ageg using `temp', nogen
	gen adj_wages80=aver_wage/aver_wage_lowskill80 
	replace adj_wages80=1 if educ==1 & sex==1 & ageg==1 & year==1985
	gen adj_lab80=hperwt*adj_wages80
	**********************************************************************
	
	
	gen wage_bill=hperwt*wage
	
	collapse (sum) labor_inc hours hperwt hperwt_low hperwt_high adj_lab adj_lab80 adj_lab_high adj_lab_low aux wage_bill adj_lab_minc (mean) adj_wages adj_wages_minc wage_predicted wage_predicted_low wage_predicted_high wage_predicted_ocfe wage_predicted_ocfe_low wage_predicted_ocfe_high wage_predicted_by_occ wage_predicted_by_occ_low wage_predicted_by_occ_high year wage k_price* total_exp* [pw = perwt], by (occ1d)
	ren aux perwt
	
      save "$intermediate_data/[14]employmentforelasticity`i'_CPS_1d_from3d_DOTONET_base85.dta", replace
		}

		use "$intermediate_data/[14]employmentforelasticity1985_CPS_1d_from3d_DOTONET_base85.dta", clear		
		*
		foreach i of numlist 1986(1)2016{
		append using "$intermediate_data/[14]employmentforelasticity`i'_CPS_1d_from3d_DOTONET_base85.dta"
		}
	
	

merge m:1 occ1d year using "$final_data/[10]stocks_occuCPS_2020_byhours_1d_agg3d_DOTONET_base85_expnorm.dta"

 keep if _merge==3

gen log_computers = log(stock_per_worker_COMPUTERS)
gen log_hcetc = log(stock_per_worker_HCETC) 
gen log_lcetc = log(stock_per_worker_LCETC)

ren stock_per_worker_COMPUTERS computers
ren stock_per_worker_LCETC low_change_equip
ren stock_per_worker_HCETC high_chage_equip
ren stock_per_worker_occ stock_per_worker

drop if occ1d==. 


gen capital_bill = total_exp

ren k_price1d k_price_all

*With capital price and wages without adjustment
gen log_relative_exp1 = log(capital_bill/wage_bill)
gen log_wage_predicted1 = log(wage/k_price_all)  

sort occ1d year
	
replace wage_predicted=wage_predicted_by_occ
ren k_price_lowcetc1d k_price_LCETC
ren k_price_highcetc1d k_price_HCETC

	save  "$final_data/[14]Occ_Stock_prices_CPS_2020_1d_from3d_DOTONET_base85_expnorm.dta", replace
	
	
	
	
	
	
	
	
************************************************************************
*2- digit occupations	
************************************************************************	
	
	
	
	
	foreach i of numlist 1985(1)2016{
				
		use "$intermediate_data/[6]employmentCPS_`i'_byhours.dta",clear	

		drop occ_2d
		***Service Occupations
		g occ_2d=.
		/* housekeeping, cleaning, laundry */
		replace occ_2d=1 if     (occ1990dd>=405 & occ1990dd<=408)
		 /* all protective service */
		replace occ_2d=2 if (occ1990dd>=415 & occ1990dd<=427)
		/* supervisors of guards; guards */
		**Included under 2 in David's file
		replace occ_2d=2 if (occ1990dd==415 | (occ1990dd>=425 & occ1990dd<=427))
		 /* food preparation and service occs */
		replace occ_2d=3 if (occ1990dd>=433 & occ1990dd<=444)
		/* health service occs (dental ass., health/nursing aides) */
		replace occ_2d=4 if (occ1990dd>=445 & occ1990dd<=447)
		 /* building and grounds cleaning and maintenance occs */
		replace occ_2d=5 if (occ1990dd>=448 & occ1990dd<=455)
		/* personal appearance occs */
		replace occ_2d=6 if (occ1990dd>=457 & occ1990dd<=458)
		/* recreation and hospitality occs */
		replace occ_2d=6 if (occ1990dd>=459 & occ1990dd<=467)
		/* child care workers */
		replace occ_2d=7 if (occ1990dd==468)
		/* misc. personal care and service occs */
		replace occ_2d=6 if (occ1990dd>=469 & occ1990dd<=472)

		***Non-service occupations
		/* executive, administrative and managerial occs */
		replace occ_2d=8 if (occ1990dd>=3 & occ1990dd<=22)
		/* management related occs */
		replace occ_2d=9 if (occ1990dd>=23 & occ1990dd<=37)
		/* professional specialty occs */
		replace occ_2d=10 if (occ1990dd>=43 & occ1990dd<=200)
		/* technicians and related support occs */
		replace occ_2d=11 if (occ1990dd>=203 & occ1990dd<=235)
		/* financial sales and related occs */
		replace occ_2d=12 if (occ1990dd>=243 & occ1990dd<=258)
		/* retail sales occs */
		replace occ_2d=13 if (occ1990dd>=274 & occ1990dd<=283)
		/* administrative support occs */
		replace occ_2d=14 if (occ1990dd>=303 & occ1990dd<=389)
		/* fire fighting, police, and correctional insitutions */
		**Included in  2 in David's file
		replace occ_2d=2 if (occ1990dd>=417 & occ1990dd<=423)
		/* farm operators and managers */
		replace occ_2d=15 if (occ1990dd>=473 & occ1990dd<=475)
		/* other agricultural and related occs */
		replace occ_2d=16 if (occ1990dd>=479 & occ1990dd<=498)
		/* mechanics and repairers */
		replace occ_2d=17 if (occ1990dd>=503 & occ1990dd<=549)
		/* construction trades */
		replace occ_2d=18 if (occ1990dd>=558 & occ1990dd<=599)
		/* extractive occs */
		replace occ_2d=19 if (occ1990dd>=614 & occ1990dd<=617)
		/* precision production occs */
		replace occ_2d=20 if (occ1990dd>=628 & occ1990dd<=699)
		/* machine operators, assemblers, and inspectors */
		replace occ_2d=21 if (occ1990dd>=703 & occ1990dd<=799)
		/* transportation and material moving occs */
		replace occ_2d=17 if (occ1990dd>=803 & occ1990dd<=889)


			replace hperwt=hperwt/perwt
			gen hperwt_high=hperwt if educ==2
			gen hperwt_low=hperwt if educ==1
			
			
			merge m:1 occ_2d year using "$intermediate_data/[12]usercost_occ_by_equipment_upt_CPS_2d-elast_from3d_DOTONET_base85.dta"   // Merge with prices
			drop if _merge !=3	
			drop _merge k_price1d
					merge m:1 occ_2d year using "$intermediate_data/[12]usercost_index_2d-elast_base85.dta"   // Merge with prices
				ren usercost_index k_price1d
				
					drop if _merge !=3	
					drop _merge aux
			merge m:1 occ_2d year using "$intermediate_data/[12]Prices_indexes_occ_by_equipmentCPS_2d-elast_from3d_DOTONET_base85.dta"

			drop if _merge!=3
			
			gen ageg=3 if age >=50 & age <=65 
			replace ageg=2 if  age >=30 & age <=49 
			replace ageg=1 if age >=16 & age <=29 
			
			
			xi: reg log_wage i.sex exp exp2 i.educ [pw=perwt], robust
				predict resid if e(sample), residuals   // residuals
			
			*format wage_predicted_sex_age_educ
			gen wage_predicted_1_1_1 = _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons] // Wages for males-aged 24-with lt college completed
			gen wage_predicted_1_2_1 = _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons] // Wages for males-aged 40-with  lt college completed
			gen wage_predicted_1_3_1 = _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons] // Wages for males-aged 58-with  lt college completed
			gen wage_predicted_2_1_1 = _b[_Isex_2] + _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons] // Wages for females-aged 24-with  lt college completed
			gen wage_predicted_2_2_1 = _b[_Isex_2] + _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons] // Wages for females-aged 40-with  lt college completed
			gen wage_predicted_2_3_1 = _b[_Isex_2] + _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons] // Wages for females-aged 58-with  lt college completed
			
			gen wage_predicted_1_1_2 = _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 24-with college completed
			gen wage_predicted_1_2_2 = _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 40-with college completed
			gen wage_predicted_1_3_2 = _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons]+_b[_Ieduc_2] // Wages for males-aged 58-with  college completed
			gen wage_predicted_2_1_2 = _b[_Isex_2] + _b[exp] * 24 + _b[exp2] * 24^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 24-with  college completed
			gen wage_predicted_2_2_2 = _b[_Isex_2] + _b[exp] * 40 + _b[exp2] * 40^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 40-with  college completed
			gen wage_predicted_2_3_2 = _b[_Isex_2] + _b[exp] * 58 + _b[exp2] * 58^2 +_b[_cons]+_b[_Ieduc_2] // Wages for females-aged 58-with  college completed
			
			g aux=1
			
			*gen aver_wage_minc=wage_predicted_1_1_1 if educ==1 & sex==1 & ageg==1
			gen adj_wages_minc=.
			forvalues edui=1(1)2{
				forvalues sexi=1(1)2{
					forvalues agei=1(1)3{
						replace adj_wages_minc=wage_predicted_`sexi'_`agei'_`edui'/wage_predicted_1_1_1 if sex==`sexi' & ageg==`agei' & educ==`edui'
					}
				}
				}
				
			*******************************************************
			**** RAW wage
			*BASELINE GROUP, Low educ, young males
			gen aver_wage=wage if educ==1 & sex==1 & ageg==1
			bys occ_2d: egen aver_wage_lowskill=mean(aver_wage)
			if `i'==1985{
				gen aver_wage_lowskill80=aver_wage_lowskill
				preserve
				keep aver_wage_lowskill80 occ_2d educ sex ageg
				duplicates drop aver_wage_lowskill80 sex ageg occ_2d educ, force
				tempfile temp
				save `temp', replace
				restore
			}
			drop aver_wage
			
			bys occ_2d sex educ ageg: egen aver_wage=mean(wage)
			
			
			gen adj_wages=aver_wage/aver_wage_lowskill 
			replace adj_wages=1 if educ==1 & sex==1 & ageg==1
			
			gen adj_lab_minc=hperwt*adj_wages_minc
			gen adj_lab=hperwt*adj_wages
			gen adj_lab_high=adj_lab if educ==2
			gen adj_lab_low=adj_lab if educ==1
			
			 
			merge m:1 occ_2d educ sex ageg using `temp', nogen
			gen adj_wages80=aver_wage/aver_wage_lowskill80 
			replace adj_wages80=1 if educ==1 & sex==1 & ageg==1 & year==1985
			gen adj_lab80=hperwt*adj_wages80
			**********************************************************************
			
			
			gen wage_bill=hperwt*wage
			drop if occ_2d==. 

					collapse (sum) labor_inc hours hperwt hperwt_low hperwt_high adj_lab adj_lab80 adj_lab_high adj_lab_low aux wage_bill adj_lab_minc (mean) adj_wages adj_wages_minc wage_predicted wage_predicted_low wage_predicted_high wage_predicted_ocfe wage_predicted_ocfe_low wage_predicted_ocfe_high wage_predicted_by_occ wage_predicted_by_occ_low wage_predicted_by_occ_high year wage k_price* total_exp* [pw = perwt], by (occ_2d)
			ren aux perwt
			
			  save "$intermediate_data/[14]employmentforelasticity`i'_CPS_2d-elast_from3d_DOTONET_base85.dta", replace
		}
*/
		use "$intermediate_data/[14]employmentforelasticity1985_CPS_2d-elast_from3d_DOTONET_base85.dta", clear		
		*
		foreach i of numlist 1986(1)2016{
		append using "$intermediate_data/[14]employmentforelasticity`i'_CPS_2d-elast_from3d_DOTONET_base85.dta",	
		}
	
	
	

merge m:1 occ_2d year using "$final_data/[10]stocks_occuCPS_2020_byhours_2d_agg3d_DOTONET_base85_expnorm.dta"
 keep if _merge==3

gen log_computers = log(stock_per_worker_COMPUTERS)
gen log_hcetc = log(stock_per_worker_HCETC) 
gen log_lcetc = log(stock_per_worker_LCETC)

ren stock_per_worker_COMPUTERS computers
ren stock_per_worker_LCETC low_change_equip
ren stock_per_worker_HCETC high_chage_equip
ren stock_per_worker_occ stock_per_worker


***********************************************************
**Variables for regression

*** Total share estimates as in Oberfield and Raval (2014) ***

gen capital_bill = total_exp

ren k_price1d k_price_all

*1) with capital price and wages without adjustment
gen log_relative_exp1 = log(capital_bill/wage_bill)
gen log_wage_predicted1 = log(wage/k_price_all)  

sort occ_2d year


replace wage_predicted=wage_predicted_by_occ
ren k_price_lowcetc1d k_price_LCETC
ren k_price_highcetc1d k_price_HCETC

	save  "$final_data/[14]Occ_Stock_prices_CPS_2020_2d-elast_from3d_DOTONET_base85_expnorm.dta", replace

	
	
	
