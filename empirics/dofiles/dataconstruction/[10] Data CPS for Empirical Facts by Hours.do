
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Construcs stocks by worker by occupation (3 digit and 1 digit) and year

Data from previous files
********************************************/

	
*********************************************************************



*1) *** 3 digit occupation 
	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear


	merge m:1 year nipa_code using"$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"

	
	******* AGGREGATION ***************

	sort occ2d nipa_code year
	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)


	gen stockexp=stock*usercost/cpi[_n-1] if  nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1] 
	replace stockexp=stock*usercost/cpi_84 if year==1985
		
				bys year occ2d: egen exp_stock_tot=total(stockexp)
				g share_stock=stockexp/exp_stock_tot
				
				sort occ2d nipa_code year	
				gen average_sh = 0.5*(share_stock[_n] +share_stock[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ2d[_n]== occ2d[_n-1] 
				replace average_sh=share_stock if year==1983
				
					gen stock_index_gr=.
			forvalues i= 1984(1)2016 {
			replace stock_index_gr=log(stock[_n]/stock[_n-1])*average_sh if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ2d[_n]==occ2d[_n-1]
				
			}
			
			
			
	bys occ2d year: gen stock_HCETC=stock if   nipa_code == 5 | nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 
	bys occ2d year: gen stock_HCETC_nocom=stock if   nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 
	bys occ2d year: gen stock_rest=stock if  nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 | nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	bys occ2d year: gen stock_LCETC=stock if  nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	bys occ2d year: gen stock_COMPUTERS=stock if nipa_code == 4 | nipa_code==99
	bys occ2d year: gen stock_COMMUN=stock if nipa_code == 5

		
	collapse (sum) s_price_gr=stock_index_gr stock* total_investment* (mean) exp_stock_tot total_hours total_workers low_skill_workers* high_skill_workers* female_workers wage, by(occ2d year)

	g stock_occ=exp_stock_tot if year==1985
			sort occ2d year 
	forvalues i=1986(1)2016{
		replace stock_occ=stock_occ[_n-1]*exp(s_price_gr) if year==`i' & occ2d[_n]==occ2d[_n-1]
	}


	replace stock=. if stock==0
	replace stock_COMPUTERS=. if stock_COMPUTERS==0
	replace stock_HCETC=. if stock_HCETC==0
	replace stock_LCETC=. if stock_LCETC==0
	replace stock_COMMUN=. if stock_COMMUN==0
	replace stock_HCETC_nocom=. if stock_HCETC_nocom==0
	replace stock_rest=. if stock_rest==0

		su stock_COMPUTERS if year==2000
	disp r(sum)
	*return	
			* STOCK PER WORKER total equipment
			gen stock_per_worker_LCETC= stock_LCETC/total_hours
			gen stock_per_worker_HCETC= stock_HCETC/total_hours
			gen stock_per_worker_COMPUTERS= stock_COMPUTERS/total_hours
			gen stock_per_worker_COMMUN= stock_COMMUN/total_hours
			gen stock_per_worker= stock/total_hours
			gen stock_per_worker_f_agg= stock_f_agg/total_hours
			gen stock_per_worker_f_share= stock_f_share/total_hours
			gen stock_per_worker_pure= stock_pure/total_hours
			gen stock_per_worker_adj_share= stock_adj_share/total_hours
			gen stock_per_worker_exp=stockexp/total_hours
			

	rename stock stock_all
	rename stock_per_worker stock_per_worker_all

	keep occ2d year exp_stock* stock* total_investment* total_hours total_workers low_skill_workers* high_skill_workers* female_workers wage

	*SAVE MAIN DTA FOR EMPIRICAL FACTS' GENERATION

	saveold "$final_data/[10]stocks_occuCPS_2020_DOTONET_base85.dta", replace


	**** OUTPUT FOR THE WEB
	sort occ2d year
	rename total_hours full_time_equiv
	keep occ2d year stock_occ exp_stock* full_time_equiv wage
	order occ2d year stock_occ exp_stock* full_time_equiv wage
	g implied_price=exp_stock/stock_occ
	drop if occ2d==.
	keep if year>=1985 & year<=2016
	replace year=year-1
	saveold "$final_data/[10]web_data_3digit.dta", replace
	outsheet using "$final_data/[10]web_data_3digit.csv", replace comma

	
	
		
	
	
	
*2) *** 1 digit occupation	
	
	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear

	collapse (sum) stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers (mean) wage, by(occ1d nipa_code year)

	merge m:1 year nipa_code using"$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"	

	

	******* AGGREGATION ***************

	sort occ1d nipa_code year
	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)


	gen stockexp=stock*usercost/cpi[_n-1] if  nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] 
	replace stockexp=stock*usercost/cpi_84 if year==1985
		
				bys year occ1d: egen exp_stock_tot=total(stockexp)
				g share_stock=stockexp/exp_stock_tot
				
				sort occ1d nipa_code year	
				gen average_sh = 0.5*(share_stock[_n] +share_stock[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ1d[_n]== occ1d[_n-1] 
				replace average_sh=share_stock if year==1983
				
					gen stock_index_gr=.
			forvalues i= 1984(1)2016 {
			replace stock_index_gr=log(stock[_n]/stock[_n-1])*average_sh if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ1d[_n]==occ1d[_n-1]
				
			}
			
			
		
	bys occ1d year: gen stock_HCETC=stock if  nipa_code == 5  | nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 
	bys occ1d year: gen stock_LCETC=stock if  nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	bys occ1d year: gen stock_COMPUTERS=stock if nipa_code == 4 | nipa_code==99

		
	collapse (sum) s_price_gr=stock_index_gr stock* total_investment (mean) total_hours total_workers low_skill_workers* high_skill_workers* female_workers exp_stock* wage, by(occ1d year)


			g stock_occ=stockexp if year==1985

			sort occ1d year 
	forvalues i=1986(1)2016{
		replace stock_occ=stock_occ[_n-1]*exp(s_price_gr) if year==`i' & occ1d[_n]==occ1d[_n-1]
	}

	replace stock=. if stock==0
	replace stock_COMPUTERS=. if stock_COMPUTERS==0
	replace stock_HCETC=. if stock_HCETC==0
	replace stock_LCETC=. if stock_LCETC==0

		su stock_COMPUTERS if year==2000
	disp r(sum)
	*return	
			* STOCK PER WORKER total equipment
			gen stock_per_worker_LCETC= stock_LCETC/total_hours
			gen stock_per_worker_HCETC= stock_HCETC/total_hours
			gen stock_per_worker_COMPUTERS= stock_COMPUTERS/total_hours
			gen stock_per_worker= stock/total_hours
			gen stock_per_worker_occ= stock_occ/total_hours
			gen stock_per_worker_exp=stockexp/total_hours
			

	rename stock stock_all
	rename stock_per_worker stock_per_worker_all

	keep occ1d year exp_stock* stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers wage

	*SAVE MAIN DTA FOR EMPIRICAL FACTS' GENERATION

	saveold "$final_data/[10]stocks_occuCPS_2020_byhours_1d_agg3d_DOTONET_base85_expnorm.dta", replace

	**** OUTPUT FOR THE WEB
	sort occ1d year
	rename total_hours full_time_equiv
	keep occ1d year stock_occ exp_stock* full_time_equiv wage
	order occ1d year stock_occ exp_stock* full_time_equiv wage
	g implied_price=exp_stock/stock_occ
	drop if occ1d==.
	keep if year>=1985 & year<=2016
	replace year=year-1

	saveold "$final_data/[10]web_data_1digit.dta", replace
	outsheet using "$final_data/[10]web_data_1digit.csv", replace comma

	
*3) *** 2 digit occupation			

	use "$intermediate_data/[8]Growth rates for investmentCPS_DOTONET_base85.dta", clear

	ren occ2d occ1990dd
	***Service Occupations
	g occ_2d=.
	/* housekeeping, cleaning, laundry */
	replace occ_2d=1 if     (occ1990dd>=405 & occ1990dd<=408)
	 /* all protective service */
	replace occ_2d=2 if (occ1990dd>=415 & occ1990dd<=427)
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

	ren occ1990dd occ2d

		
	collapse (sum) stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers (mean) wage, by(occ_2d nipa_code year)

	merge m:1 year nipa_code using"$intermediate_data/[9]usercost_equipment_CPS_DOTONET_base85.dta"	

	******* AGGREGATION ***************

	sort occ_2d nipa_code year
	gen cpi_1984=cpi if year==1984
	egen cpi_84=mean(cpi_1984)


	gen stockexp=stock*usercost/cpi[_n-1] if  nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1] 
	replace stockexp=stock*usercost/cpi_84 if year==1985
		
				bys year occ_2d: egen exp_stock_tot=total(stockexp)
				g share_stock=stockexp/exp_stock_tot
				
				sort occ_2d nipa_code year	
				gen average_sh = 0.5*(share_stock[_n] +share_stock[_n-1]) if  nipa_code[_n] == nipa_code[_n-1] & occ_2d[_n]== occ_2d[_n-1] 
				replace average_sh=share_stock if year==1983
				
					gen stock_index_gr=.
			forvalues i= 1984(1)2016 {
			replace stock_index_gr=log(stock[_n]/stock[_n-1])*average_sh if year == `i' & nipa_code[_n]==nipa_code[_n-1] & occ_2d[_n]==occ_2d[_n-1]
				
			}
			
			
		
	bys occ_2d year: gen stock_HCETC=stock if  nipa_code == 5  | nipa_code == 26  | nipa_code == 6  | nipa_code == 9 | nipa_code == 10 |  nipa_code == 40 |  nipa_code == 18 |nipa_code == 14 
	bys occ_2d year: gen stock_LCETC=stock if  nipa_code == 20  | nipa_code == 2225  | nipa_code == 11 | nipa_code == 13 |  nipa_code == 27  | nipa_code == 29 |  nipa_code == 19 | nipa_code == 41 |  nipa_code == 39 |  nipa_code == 28 |  nipa_code == 17 |  nipa_code == 30 |  nipa_code == 33 |  nipa_code == 36 
	bys occ_2d year: gen stock_COMPUTERS=stock if nipa_code == 4 | nipa_code==99

		
	collapse (sum) s_price_gr=stock_index_gr stock* total_investment (mean) total_hours total_workers low_skill_workers* high_skill_workers* female_workers exp_stock* wage, by(occ_2d year)


			g stock_occ=stockexp if year==1985

			sort occ_2d year 
	forvalues i=1986(1)2016{
		replace stock_occ=stock_occ[_n-1]*exp(s_price_gr) if year==`i' & occ_2d[_n]==occ_2d[_n-1]
	}

	replace stock=. if stock==0
	replace stock_COMPUTERS=. if stock_COMPUTERS==0
	replace stock_HCETC=. if stock_HCETC==0
	replace stock_LCETC=. if stock_LCETC==0

		su stock_COMPUTERS if year==2000
	disp r(sum)
	
			* STOCK PER WORKER total equipment
			gen stock_per_worker_LCETC= stock_LCETC/total_hours
			gen stock_per_worker_HCETC= stock_HCETC/total_hours
			gen stock_per_worker_COMPUTERS= stock_COMPUTERS/total_hours
			gen stock_per_worker= stock/total_hours
			gen stock_per_worker_occ= stock_occ/total_hours
			gen stock_per_worker_exp=stockexp/total_hours
			

	rename stock stock_all
	rename stock_per_worker stock_per_worker_all


	keep occ_2d year exp_stock* stock* total_investment total_hours total_workers low_skill_workers* high_skill_workers* female_workers wage

	*SAVE MAIN DTA FOR EMPIRICAL FACTS' GENERATION
	
	drop if occ_2d==. 
	
	saveold "$final_data/[10]stocks_occuCPS_2020_byhours_2d_agg3d_DOTONET_base85_expnorm.dta", replace


	sort occ_2d year
	rename total_hours full_time_equiv
	keep occ_2d year stock_occ exp_stock* full_time_equiv wage
	order occ_2d year stock_occ exp_stock* full_time_equiv wage
	g implied_price=exp_stock/stock_occ
	drop if occ_2d==.
	keep if year>=1985 & year<=2016
	replace year=year-1

	saveold "$final_data/[10]web_data_2digit.dta", replace
	outsheet using "$final_data/[10]web_data_2digit.csv", replace comma
	
