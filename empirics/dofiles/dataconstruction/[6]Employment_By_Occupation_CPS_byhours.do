
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Takes Data from IPUMS, generates employment and wage series by year and occupation
It also generates supply and demand IVs to be used in the computation of elasticities. 

Data from IPUMS CPS is public and comes from : https://cps.ipums.org/cps/ (downloaded June 2021)
********************************************/

	
*********************************************************************



*Loo by year
foreach i of numlist 1983(1)2016{

	use "$raw_data/IPUMS_CPS/cps_sample_`i'.dta",clear

		drop if asecwt<=0
		
		if year==2014{
		keep if hflag==0
		* keep 5/8 of the sample
		}
		
	egen emp=total(asecwt)
	*1* Labor income 
	* We follow here Acemoglu and Autor 2011 that only consider income from wages
		egen labor_inc = rsum(incwage)
		gen incwage2 = incwage if educ <= 9 & educ !=.
		egen labor_inc_low = rsum(incwage2)
		gen incwage3 = incwage if educ >= 10 & educ !=.
		egen labor_inc_high = rsum(incwage3)
				
	* Real earnings at 1999 
		merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
		ren pcepi cpi
		
		drop _merge
		gen nominal_labor_inc=labor_inc
		
		replace labor_inc = labor_inc/cpi
		


	*Following Acemoglu and Author, weeks of work in a year
	if year <1976{
	   
	replace wkswork1=7 if wkswork2==1  

	replace wkswork1=20 if wkswork2==2  

	replace wkswork1=33 if wkswork2==3  

	replace wkswork1=43.5 if wkswork2==4 

	replace wkswork1=48.5 if wkswork2==5 

	replace wkswork1=51 if wkswork2==6 
	}
	

 
	gen hours = .


	*using hours worked per week in all jobs! Can use just main
	replace hours=uhrsworkly if uhrsworkly~=999 & uhrsworkly~=997
		 
	replace hours = 80 if uhrsworkly > 80 & uhrsworkly~=999 & uhrsworkly~=997
	
	su hours, meanonly
	local meanh=`r(mean)'
	replace hours=`meanh' if hours==.

	* wage*
	gen wage = labor_inc / (hours* wkswork1)
	gen wage_week=labor_inc/(wkswork1)
			
**Autor (2015) Adjustment Figure4
	*48+ annual weeks worked and 35+ usual weekly hours.
	keep if wkswork1>=48
	keep if hours>=35
				
	su hours uhrswork1 uhrsworkt uhrsworkly year


* Merge with occ1990dd clasification
	if year>=1983 & year<=1991{
		    merge m:1 occ using "$raw_data/Crosswalks/occ1980_occ1990dd.dta"
				tab _merge
			drop if _merge == 2 
		}
		


		if year>=1992 & year<=2002{
		    merge m:1 occ using "$raw_data/Crosswalks/occ1990_occ1990dd.dta"
			tab _merge 		
			drop if _merge == 2 
		}
		
		if year>2002 & year<2005{
		    replace occ = occ/ 10
		merge m:1 occ using "$raw_data/Crosswalks/occ2000_occ1990dd.dta"
			tab _merge
			drop if _merge == 2 
		}
		if year>=2005 & year <= 2010{
		    replace occ = occ/ 10
		merge m:1 occ using "$raw_data/Crosswalks/occ2005_occ1990dd.dta"
			tab _merge
			drop if _merge == 2 
		}
		if year>2010 & year<= 2011{
		merge m:1 occ using "$raw_data/Crosswalks/occ2010_occ1990dd.dta"
			tab _merge
			drop if _merge == 2 
		}
		if year>=2012 {
		merge m:1 occ using "$raw_data/Crosswalks/occ2016_occ1990dd.dta"
			tab _merge
			drop if _merge == 2 
		}
		
		
		**** Change name of three occuaptions for which we do ot have many years of data
	/*
	489 Inspectors of agricultural products to  36 Inspectors and compliance officers, outside 
	462 Ushers to 459 Recreation facility attendants 
	583 Paperhangers to  599 Misc. construction and related occupations
	*/
	
	replace occ1990dd = 36 if occ1990dd == 489
	replace occ1990dd = 459 if occ1990dd == 462
	replace occ1990dd = 599 if occ1990dd == 583
	
	
        drop _merge

*Heathcote, Perry and Violante
	rename asecwt perwt

		**** Gen occupational dimention to be considered * 	HERE WE HAVE 3 DIGITS OCCUPATIONS ***
	
		gen occ2d = occ1990dd
		
		  gen hperwt = hours/40*wkswork1/51*perwt
		  
		  	egen total_workers_pre = sum(perwt), by(occ2d)
		egen total_hours_pre = sum(hperwt), by(occ2d)
		
		** Adjust Educational Variables
		ren educ edur
	gen educ = .
	replace educ = 1 if edur>=10 & edur<110 //lower than collage
	replace educ = 2 if edur>100 & edur<900 //col+


	drop edur
	drop if educ==.

	gen occ1d  = .
		replace occ1d = 1 if occ2d >= 4 & occ2d <= 37
		replace occ1d = 2 if occ2d >= 43 & occ2d <= 199
		replace occ1d = 3 if occ2d >= 203 & occ2d <= 235
		replace occ1d = 4 if occ2d >= 243 & occ2d <= 285
		replace occ1d = 5 if occ2d >= 303 & occ2d <= 389
		replace occ1d = 6 if occ2d >= 405 & occ2d <= 471
		replace occ1d = 7 if occ2d >= 472 & occ2d <= 498
		replace occ1d = 8 if occ2d >= 503 & occ2d <= 599
		replace occ1d = 9 if occ2d >= 614 & occ2d <= 617
		replace occ1d = 10 if occ2d >= 628 & occ2d <= 696
		replace occ1d = 11 if occ2d >= 699 & occ2d <= 799
		replace occ1d = 12 if occ2d >= 803 & occ2d <= 889
		
		
		drop if occ1d == . // drop military occupations 
		
		** Industry Demand for IV elasticities
	*
	gen sector = .
	replace sector = 1 if (ind1990>=10 & ind1990<=32) //agri
	replace sector = 2 if (ind1990>=40 & ind1990<=50) | (ind1990>=100 & ind1990<=392) | (ind1990==60)
	replace sector = 3 if (ind1990>=400 & ind1990<=691) | (ind1990>=721 & ind1990<=791) //low skill services
	replace sector = 4 if (ind1990>=700 & ind1990<=712) | (ind1990>=800 & ind1990<=893) //high skill services

	replace sector = 5 if ind1990 == . | occ2d ==. //Other sectors such as governemnt
	


	
	** Industrial composition of occupational employment in a base year. Use growth rate of total employment in the industry to construct counterfactual labor demand for an occupation. 
		
	** Skill supply for IV elasticities
	preserve
				gen edur=educ
			
	bys occ1d: egen total_emp_occ1d=total(hperwt)
	gen young=.
	replace young=1 if age<=24
	replace young=2 if age>24
	bys occ2d young edur: egen tot_age=total(hperwt)
	gen emp_sh_age=tot_age/total_emp_occ1d

	drop if age<=24

	egen emp2=total(perwt)
	egen emp2_noold=total(perwt) if age<=65
	*USE ONLY PEOPLE ABOVE 25
	bys edur: egen supply_skill=total(perwt) if age>24
	bys edur: egen supply_skill_young=total(perwt) if age>24 & age<=30

	bys edur occ2d: egen supply_skill_byocced=total(perwt) if age>24
	bys occ2d: egen supply_skill_byocc=total(perwt) if age>24
	bys edur occ2d: gen share_skill_byoccedur=supply_skill_byocced/supply_skill if age>24

	bys edur occ2d: gen share_skill_byoccedur2=supply_skill_byocced/supply_skill_byocc if age>24

	local year1=year


	keep perwt emp* supply_skill supply_skill_young supply_skill_byocc supply_skill_byocced share_skill_byoccedur* edur occ2d occ1d year
	 
	duplicates drop occ2d year edur, force
	sort occ2d year


	save "$intermediate_data/[6]supply_`i'_forIV_CPS_3d.dta", replace
	restore

	******3-digit instruments*****
	**demand**
	preserve	
		 bys sector: egen demand_ind=total(perwt)
		 bys sector occ1d: egen demand_ind_byoccind=total(perwt)
		 bys occ1d: egen demand_byocc=total(perwt)
		 bys sector occ1d: gen share_demand_byoccind=demand_ind_byoccind/demand_byocc
		 

		 keep occ1d year demand_ind demand_byocc demand_ind_byoccind share_demand_byoccind sector occ1d ind1990
		 tab sector
	duplicates drop occ1d year sector, force

		forvalues f=1(1)12{
		  bys sector: egen share_demand_byoccind_comp`f'=total(share_demand_byoccind) if occ1d~=`f'
		  }
		 
		  
	save "$intermediate_data/[6]demand_`i'_forIV_CPS_1d.dta", replace

	restore

	preserve
	
	gen edur=educ

	bys occ1d: egen total_emp_occ1d=total(hperwt)
	gen young=.
	replace young=1 if age<=24
	replace young=2 if age>24
	bys occ1d young edur: egen tot_age=total(hperwt)
	gen emp_sh_age=tot_age/total_emp_occ1d

	drop if age<=24

	egen emp2=total(perwt)
	egen emp2_noold=total(perwt) if age<=65
	*USE ONLY PEOPLE ABOVE 25
	bys edur: egen supply_skill=total(perwt) if age>24
	bys edur: egen supply_skill_young=total(perwt) if age>24 & age<=30

	bys edur occ1d: egen supply_skill_byocced=total(perwt) if age>24
	bys occ1d: egen supply_skill_byocc=total(perwt) if age>24
	bys edur occ1d: gen share_skill_byoccedur=supply_skill_byocced/supply_skill if age>24

	bys edur occ1d: gen share_skill_byoccedur2=supply_skill_byocced/supply_skill_byocc if age>24

	local year1=year


	keep perwt emp* supply_skill supply_skill_young supply_skill_byocc supply_skill_byocced share_skill_byoccedur* edur occ1d year
	 
	duplicates drop occ1d year edur, force
	 forvalues f=1(1)12{
		  bys edur: egen share_skill_byoccedur2_comp`f'=total(share_skill_byoccedur2) if occ1d~=`f'
		  }
		  
	sort occ1d year
	save "$intermediate_data/[6]supply_`i'_forIV_CPS_1d.dta", replace
	restore

	******2digit IV*****

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
	replace occ_2d=7 if (occ1990dd>=459 & occ1990dd<=467)
	/* child care workers */
	replace occ_2d=8 if (occ1990dd==468)
	/* misc. personal care and service occs */
	replace occ_2d=9 if (occ1990dd>=469 & occ1990dd<=472)

	***Non-service occupations
	/* executive, administrative and managerial occs */
	replace occ_2d=10 if (occ1990dd>=3 & occ1990dd<=22)
	/* management related occs */
	replace occ_2d=11 if (occ1990dd>=23 & occ1990dd<=37)
	/* professional specialty occs */
	replace occ_2d=12 if (occ1990dd>=43 & occ1990dd<=200)
	/* technicians and related support occs */
	replace occ_2d=13 if (occ1990dd>=203 & occ1990dd<=235)
	/* financial sales and related occs */
	replace occ_2d=14 if (occ1990dd>=243 & occ1990dd<=258)
	/* retail sales occs */
	replace occ_2d=15 if (occ1990dd>=274 & occ1990dd<=283)
	/* administrative support occs */
	replace occ_2d=16 if (occ1990dd>=303 & occ1990dd<=389)
	/* fire fighting, police, and correctional insitutions */
	**Included in  2 in David's file
	replace occ_2d=2 if (occ1990dd>=417 & occ1990dd<=423)
	/* farm operators and managers */
	replace occ_2d=17 if (occ1990dd>=473 & occ1990dd<=475)
	/* other agricultural and related occs */
	replace occ_2d=18 if (occ1990dd>=479 & occ1990dd<=498)
	/* mechanics and repairers */
	replace occ_2d=19 if (occ1990dd>=503 & occ1990dd<=549)
	/* construction trades */
	replace occ_2d=20 if (occ1990dd>=558 & occ1990dd<=599)
	/* extractive occs */
	replace occ_2d=21 if (occ1990dd>=614 & occ1990dd<=617)
	/* precision production occs */
	replace occ_2d=22 if (occ1990dd>=628 & occ1990dd<=699)
	/* machine operators, assemblers, and inspectors */
	replace occ_2d=23 if (occ1990dd>=703 & occ1990dd<=799)
	/* transportation and material moving occs */
	replace occ_2d=24 if (occ1990dd>=803 & occ1990dd<=889)

	**********Demand_IV
	preserve	

		 bys sector: egen demand_ind=total(perwt)
		 bys sector occ_2d: egen demand_ind_byoccind=total(perwt)
		 bys occ_2d: egen demand_byocc=total(perwt)
		 bys sector occ_2d: gen share_demand_byoccind=demand_ind_byoccind/demand_byocc
		 

		 keep occ_2d year demand_ind demand_byocc demand_ind_byoccind share_demand_byoccind sector occ_2d ind1990
		 tab sector
	duplicates drop occ_2d year sector, force

		forvalues f=1(1)24{
		  bys sector: egen share_demand_byoccind_comp`f'=total(share_demand_byoccind) if occ_2d~=`f'
		  }
		 
		  
	save "$intermediate_data/[6]demand_`i'_forIV_CPS_2d.dta", replace

	restore

	preserve	
	g occ_2d_elast=occ_2d
	replace occ_2d_elast=6 if occ_2d==7
	replace occ_2d_elast=7 if occ_2d==8
	replace occ_2d_elast=6 if occ_2d==9
	forvalues j=10(1)23{
	replace occ_2d_elast=`j'-2 if occ_2d==`j'
	}
	replace occ_2d_elast=17 if occ_2d==24

		 bys sector: egen demand_ind=total(perwt)
		 bys sector occ_2d_elast: egen demand_ind_byoccind=total(perwt)
		 bys occ_2d_elast: egen demand_byocc=total(perwt)
		 bys sector occ_2d_elast: gen share_demand_byoccind=demand_ind_byoccind/demand_byocc
		 

		 keep occ2d year demand_ind demand_byocc demand_ind_byoccind share_demand_byoccind sector occ_2d_elast ind1990
		 tab sector
		 ren occ_2d_elast occ_2d
	duplicates drop occ_2d year sector, force

		forvalues f=1(1)24{
		  bys sector: egen share_demand_byoccind_comp`f'=total(share_demand_byoccind) if occ_2d~=`f'
		  }
		 
		  
	save "$intermediate_data/[6]demand_`i'_forIV_CPS_2d-elast.dta", replace

	restore

	preserve
	gen edur=educ

	bys occ_2d: egen total_emp_occ_2d=total(hperwt)
	gen young=.
	replace young=1 if age<=24
	replace young=2 if age>24
	bys occ_2d young edur: egen tot_age=total(hperwt)
	gen emp_sh_age=tot_age/total_emp_occ_2d

	drop if age<=24

	egen emp2=total(perwt)
	egen emp2_noold=total(perwt) if age<=65
	*USE ONLY PEOPLE ABOVE 25
	bys edur: egen supply_skill=total(perwt) if age>24
	bys edur: egen supply_skill_young=total(perwt) if age>24 & age<=30

	bys edur occ_2d: egen supply_skill_byocced=total(perwt) if age>24
	bys occ_2d: egen supply_skill_byocc=total(perwt) if age>24
	bys edur occ_2d: gen share_skill_byoccedur=supply_skill_byocced/supply_skill if age>24

	bys edur occ_2d: gen share_skill_byoccedur2=supply_skill_byocced/supply_skill_byocc if age>24

	local year1=year


	keep perwt emp* supply_skill supply_skill_young supply_skill_byocc supply_skill_byocced share_skill_byoccedur* edur occ_2d year
	 
	duplicates drop occ_2d year edur, force
	 forvalues f=1(1)24{
		  bys edur: egen share_skill_byoccedur2_comp`f'=total(share_skill_byoccedur2) if occ_2d~=`f'
		  }
		  
	sort occ_2d year
	save "$intermediate_data/[6]supply_`i'_forIV_CPS_2d.dta", replace
	restore

	preserve

	g occ_2d_elast=occ_2d
	replace occ_2d_elast=6 if occ_2d==7
	replace occ_2d_elast=7 if occ_2d==8
	replace occ_2d_elast=6 if occ_2d==9
	forvalues j=10(1)23{
	replace occ_2d_elast=`j'-2 if occ_2d==`j'
	}
	replace occ_2d_elast=17 if occ_2d==24

	gen edur=educ

	bys occ_2d_elast: egen total_emp_occ_2d=total(hperwt)
	gen young=.
	replace young=1 if age<=24
	replace young=2 if age>24
	bys occ_2d_elast young edur: egen tot_age=total(hperwt)
	gen emp_sh_age=tot_age/total_emp_occ_2d

	drop if age<=24

	egen emp2=total(perwt)
	egen emp2_noold=total(perwt) if age<=65
	*USE ONLY PEOPLE ABOVE 25
	bys edur: egen supply_skill=total(perwt) if age>24
	bys edur: egen supply_skill_young=total(perwt) if age>24 & age<=30

	bys edur occ_2d_elast: egen supply_skill_byocced=total(perwt) if age>24
	bys occ_2d_elast: egen supply_skill_byocc=total(perwt) if age>24
	bys edur occ_2d_elast: gen share_skill_byoccedur=supply_skill_byocced/supply_skill if age>24

	bys edur occ_2d_elast: gen share_skill_byoccedur2=supply_skill_byocced/supply_skill_byocc if age>24

	local year1=year


	keep perwt emp* supply_skill supply_skill_young supply_skill_byocc supply_skill_byocced share_skill_byoccedur* edur occ_2d_elast year
	 ren occ_2d_elast occ_2d
	duplicates drop occ_2d year edur, force
	 forvalues f=1(1)24{
		  bys edur: egen share_skill_byoccedur2_comp`f'=total(share_skill_byoccedur2) if occ_2d~=`f'
		  }
		  
	sort occ_2d year
	save "$intermediate_data/[6]supply_`i'_forIV_CPS_2d-elast.dta", replace
	restore


	
	*** Trimming the sample ***
	drop if incwage==999999
  
	*T1 age 
	keep if age >=16 & age <= 65
	

	*T2 positive earnings
	keep if labor_inc !=. & labor_inc !=0
    
	*T3 Workers that work more than 30 hs 	
	keep if (hours >=30 &  hours !=.) 
	
	*T4 Outliers

	sum labor_inc if labor_inc !=0 & labor_inc !=., det
	drop if labor_inc <r(p1)
	drop if labor_inc >r(p99)	
	
	*** wage for low and high  skill
	gen wage_low = wage if educ <=1 & educ !=.
	gen wage_high = wage if educ >=2 & educ !=.

	* We keep potentially self employed people:  classwkrd.

	*** Employment variables ***
		
	egen total_workers = sum(perwt), by(occ2d)
	egen total_hours = sum(hperwt), by(occ2d)
     
	 
	* By education, NEED TO ADJUST THIS TO BE ONES AT THE 1-D occ2d

		gen aux_low = perwt if educ <=1 & educ !=.
		egen low_skill_workers = sum(aux_low) , by(occ2d)
		* college or more
		gen aux_hig =  perwt if educ >=2 & educ !=.
		egen high_skill_workers = sum(aux_hig) , by(occ2d)
	
		gen aux_lowh =  hperwt if educ <=1 & educ !=.
		egen low_skill_workers_hours = sum(aux_lowh) , by(occ2d)
		gen aux_high =  hperwt if educ >=2 & educ !=.
		egen high_skill_workers_hours = sum(aux_high) , by(occ2d)


	
	* By gender
		gen aux_female = hperwt if sex ==2 
		egen female_workers = sum(aux_female), by(occ2d)

	* By age	
		gen aux_25_34 = hperwt if age >=16 & age <=29 
		egen age_25_34 = sum(aux_25_34), by(occ2d)

		gen aux_35_44 = hperwt if age >=30 & age <=49 
		egen age_35_44 = sum(aux_35_44), by(occ2d)

		gen aux_45_55 = hperwt if age >=50 & age <=65 
		egen age_45_55 = sum(aux_45_55), by(occ2d)
		
	* Mincer equations to estimate wages by occupations 
		gen log_wage = log(wage)
		gen exp = age
		gen exp2 = age^2
		* Mincer reg
		gen male =  1 if sex == 1
		replace male =0 if sex == 2
		

		*
		xi: reg log_wage male exp exp2 i.educ [pw=perwt], robust
		predict resid if e(sample), residuals   // residuals
		
		gen wage_predicted = resid 
		replace wage_predicted = exp(wage_predicted)
		
		gen aux1 = resid 
		replace aux1 = exp(aux1)
		gen aux2 = resid 
		replace aux2 = exp(aux2)
		drop resid

		
		xi: reg log_wage male exp exp2 i.educ i.occ1d [pw=perwt], robust
		predict resid if e(sample), residuals   // residuals
		gen wage_predicted_ocfe = resid 
		replace wage_predicted_ocfe = exp(wage_predicted_ocfe)
		
		gen aux3 = resid 
		replace aux3 = exp(aux3)
		gen aux4 = resid 
		replace aux4 = exp(aux4)	
		drop resid
		
		xi: reg log_wage male i.male*i.occ1d exp i.occ1d*exp exp2 i.occ1d*exp2 i.educ*i.occ1d [pw=perwt], robust
		predict resid if e(sample), residuals   // residuals
		gen wage_predicted_by_occ = resid 
		replace wage_predicted_by_occ = exp(wage_predicted_by_occ)

		
		gen aux5 = resid 
		replace aux5 = exp(aux5)
		gen aux6 = resid 
		replace aux6 = exp(aux6)
		drop resid
		
		* Wages predicted by edu group
		gen wage_predicted_low = aux1 if educ <=9 & educ !=.
		gen wage_predicted_high = aux2 if educ >=10 & educ !=.
		gen wage_predicted_ocfe_low = aux3 if educ <=9 & educ !=.
		gen wage_predicted_ocfe_high = aux4 if educ >=10 & educ !=.
		gen wage_predicted_by_occ_low = aux5 if educ <=9 & educ !=.
		gen wage_predicted_by_occ_high = aux6 if educ >=10 & educ !=.
		*
		local year= year
		saveold "$intermediate_data/[6]employmentCPS_`year'_byhours.dta", replace
	
		}
	*/
use  "$intermediate_data/[6]employmentCPS_1983_byhours.dta", replace
forv t = 1984(1)2016{
	append using  "$intermediate_data/[6]employmentCPS_`t'_byhours.dta"
}
saveold  "$intermediate_data/[6]employmentCPS_allyears_byhours.dta", replace


use "$intermediate_data/[6]employmentCPS_allyears_byhours.dta", clear


