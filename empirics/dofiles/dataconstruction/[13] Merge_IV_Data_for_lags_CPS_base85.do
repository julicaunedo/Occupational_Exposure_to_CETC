/*********************************************************************

*	Occupational exposure to capital-embodied technical change

This file construct supply and demand IVS for the estimations of elasticities

Data from trade comes from World Development Indicators (serie code NE.EXP.GNFS.ZS, retrieved on June 2021)
Data from population and birth rate from fed (serie code SPDYNCBRTINUSA LFWA64TTUSM647S, retrieved on June 2021).
Daat from warehouse comes from BEA Nipa tables (retrieved on June 2021).
Data from previous files and from World Development Indicators
********************************************/


	
*********************************************************************


*********************************************************************
*1) Preliminaries (build data on trade, population and warehouse IV)
*********************************************************************


	***** Population data and birth rates fro FED **********************
	* 1 digit
	use "$raw_data/FED_working_age_population/working_age_pop.dta",clear // Merge with working age population for instrument
ren workingage population
	merge 1:1 year using  "$raw_data/FED_working_age_population/crudebirthrate.dta"
	forvalues i=1(1)11{		
			  gen occ`i'=1	  
	}
	reshape long occ, i(year population brt_rt) j(occ1d)
	gen edur=1
	save "$intermediate_data/[13]pop_all.dta", replace
	gen edurap=2
	append using "$intermediate_data/[13]pop_all.dta"
	replace edur=2 if edurap==.
	drop edurap
	save "$intermediate_data/[13]pop_all.dta", replace

	*2 digit
	use "$raw_data/FED_working_age_population/working_age_pop.dta",clear // Merge with working age population for instrument
ren workingage population
	merge 1:1 year using  "$raw_data/FED_working_age_population/crudebirthrate.dta"
	forvalues i=1(1)21{		
			  gen occ`i'=1	  
	}
	reshape long occ, i(year population brt_rt) j(occ_2d)
	gen edur=1
	save "$intermediate_data/[13]pop_all_2d.dta", replace
	gen edurap=2
	append using "$intermediate_data/[13]pop_all_2d.dta"
	replace edur=2 if edurap==.
	drop edurap
	save "$intermediate_data/[13]pop_all_2d.dta", replace
	
	
	
	*****trade data for IV **********************************
		use "$raw_data/WDI/Data_trade_US.dta", clear
	*return
	keep if seriescode=="NE.EXP.GNFS.ZS"
	ren series trade
	tempfile tradedata
	save `tradedata'
*/
	use "$intermediate_data/[13]pop_all.dta", clear
	keep population year
	duplicates drop year, force
	tsset year
	g pop_gr_16yr=(population/L16.population)^(1/16)-1

	drop population
	tempfile pop_gr16
	save `pop_gr16'

	
	**** Werehouse data for IV*******


		import excel "$raw_data/BEA_NIPA/Table2.7_BEA_current_cost_investment.xls", sheet("Sheet0") firstrow cellrange (A6:DP86) clear 

		keep if Line=="46"
		ren B Category
		replace Category="investment warehouse" if Category=="Warehouses"


		ren C equip_1901
			ren D equip_1902
			ren E equip_1903
			ren F equip_1904
			ren G equip_1905
			ren H equip_1906
			ren I equip_1907
			ren J equip_1908
			ren K equip_1909
			ren L equip_1910
			ren M equip_1911
			ren N equip_1912
			ren O equip_1913
			ren P equip_1914
			ren Q equip_1915
			ren R equip_1916
			ren S equip_1917
			ren T equip_1918
			ren U equip_1919
			ren V equip_1920
			ren W equip_1921
			ren X equip_1922
			ren Y equip_1923
			ren Z equip_1924
			ren AA equip_1925
			ren AB equip_1926
			ren AC equip_1927
			ren AD equip_1928
			ren AE equip_1929
			ren AF equip_1930
			ren AG equip_1931
			ren AH equip_1932
			ren AI equip_1933
			ren AJ equip_1934
			ren AK equip_1935
			ren AL equip_1936
			ren AM equip_1937
			ren AN equip_1938
			ren AO equip_1939
			ren AP equip_1940
			ren AQ equip_1941
			ren AR equip_1942
			ren AS equip_1943
			ren AT equip_1944
			ren AU equip_1945
			ren AV equip_1946
			ren AW equip_1947
			ren AX equip_1948
			ren AY equip_1949
			ren AZ equip_1950
			ren BA equip_1951
			ren BB equip_1952
			ren BC equip_1953
			ren BD equip_1954
			ren BE equip_1955
			ren BF equip_1956
			ren BG equip_1957
			ren BH equip_1958
			ren BI equip_1959
			ren BJ equip_1960
			ren BK equip_1961
			ren BL equip_1962
			ren BM equip_1963
			ren BN equip_1964
			ren BO equip_1965
			ren BP equip_1966
			ren BQ equip_1967
			ren BR equip_1968
			ren BS equip_1969
			ren BT equip_1970
			ren BU equip_1971
			ren BV equip_1972
			ren BW equip_1973
			ren BX equip_1974
			ren BY equip_1975
			ren BZ equip_1976
			ren CA equip_1977
			ren CB equip_1978
			ren CC equip_1979
			ren CD equip_1980
			ren CE equip_1981
			ren CF equip_1982
			ren CG equip_1983
			ren CH equip_1984
			ren CI equip_1985
			ren CJ equip_1986
			ren CK equip_1987
			ren CL equip_1988
			ren CM equip_1989
			ren CN equip_1990
			ren CO equip_1991
			ren CP equip_1992
			ren CQ equip_1993
			ren CR equip_1994
			ren CS equip_1995
			ren CT equip_1996
			ren CU equip_1997
			ren CV equip_1998
			ren CW equip_1999
			ren CX equip_2000
			ren CY equip_2001
			ren CZ equip_2002
			ren DA equip_2003
			ren DB equip_2004
			ren DC equip_2005
			ren DD equip_2006
			ren DE equip_2007
			ren DF equip_2008
			ren DG equip_2009
			ren DH equip_2010
			ren DI equip_2011
			ren DJ equip_2012
			ren DK equip_2013
			ren DL equip_2014
			ren DM equip_2015
			ren DN equip_2016
			ren DO equip_2017
			ren DP equip_2018
			
			reshape long equip_, i(Category) j(year)

			ren equip_ investment
			drop Line
			keep if year>=1984
			collapse (sum) investment, by(year)
			saveold "$intermediate_data/[13]Investmentwarehouse.dta", replace 
			
		******************STOCKS	
		import excel "$raw_data/BEA_NIPA/Table2.1_BEA_current_cost_stock.xls", sheet("Sheet0") firstrow cellrange (A6:CR86) clear 

		keep if Line=="46"
		ren B Category
		replace Category="stock warehouse" if Category=="Warehouses"


			ren C equip_1925
			ren	D	equip_1926
		ren	E	equip_1927
		ren	F	equip_1928
		ren	G	equip_1929
		ren	H	equip_1930
		ren	I	equip_1931
		ren	J	equip_1932
		ren	K	equip_1933
		ren	L	equip_1934
		ren	M	equip_1935
		ren	N	equip_1936
		ren	O	equip_1937
		ren	P	equip_1938
		ren	Q	equip_1939
		ren	R	equip_1940
		ren	S	equip_1941
		ren	T	equip_1942
		ren	U	equip_1943
		ren	V	equip_1944
		ren	W	equip_1945
		ren	X	equip_1946
		ren	Y	equip_1947
		ren	Z	equip_1948
		ren	AA	equip_1949
		ren	AB	equip_1950
		ren	AC	equip_1951
		ren	AD	equip_1952
		ren	AE	equip_1953
		ren	AF	equip_1954
		ren	AG	equip_1955
		ren	AH	equip_1956
		ren	AI	equip_1957
		ren	AJ	equip_1958
		ren	AK	equip_1959
		ren	AL	equip_1960
		ren	AM	equip_1961
		ren	AN	equip_1962
		ren	AO	equip_1963
		ren	AP	equip_1964
		ren	AQ	equip_1965
		ren	AR	equip_1966
		ren	AS	equip_1967
		ren	AT	equip_1968
		ren	AU	equip_1969
		ren	AV	equip_1970
		ren	AW	equip_1971
		ren	AX	equip_1972
		ren	AY	equip_1973
		ren	AZ	equip_1974
		ren	BA	equip_1975
		ren	BB	equip_1976
		ren	BC	equip_1977
		ren	BD	equip_1978
		ren	BE	equip_1979
		ren	BF	equip_1980
		ren	BG	equip_1981
		ren	BH	equip_1982
		ren	BI	equip_1983
		ren	BJ	equip_1984
		ren	BK	equip_1985
		ren	BL	equip_1986
		ren	BM	equip_1987
		ren	BN	equip_1988
		ren	BO	equip_1989
		ren	BP	equip_1990
		ren	BQ	equip_1991
		ren	BR	equip_1992
		ren	BS	equip_1993
		ren	BT	equip_1994
		ren	BU	equip_1995
		ren	BV	equip_1996
		ren	BW	equip_1997
		ren	BX	equip_1998
		ren	BY	equip_1999
		ren	BZ	equip_2000
		ren	CA	equip_2001
		ren	CB	equip_2002
		ren	CC	equip_2003
		ren	CD	equip_2004
		ren	CE	equip_2005
		ren	CF	equip_2006
		ren	CG	equip_2007
		ren	CH	equip_2008
		ren	CI	equip_2009
		ren	CJ	equip_2010
		ren	CK	equip_2011
		ren	CL	equip_2012
		ren	CM	equip_2013
		ren	CN	equip_2014
		ren	CO	equip_2015
		ren	CP	equip_2016
		ren	CQ	equip_2017
		ren	CR	equip_2018
				

			reshape long equip_, i(Category) j(year)
			ren equip_ stock
			drop Line
			keep if year>=1984
			collapse (sum) stock, by(year)
			saveold "$intermediate_data/[13]Stockwarehouse.dta", replace 

			************************Value_added_warehouses**************
			import excel "$raw_data/BEA_NIPA/Table6.1D_BEA_valueadded_ind.xls", sheet("download (6)") firstrow cellrange (A5:Y27) clear 

		keep if Line=="13"
		ren B Category
		replace Category="Valueadded_ware" if Category=="Transportation and warehousing"


		   ren	C	equip_1998
		ren	D	equip_1999
		ren	E	equip_2000
		ren	F	equip_2001
		ren	G	equip_2002
		ren	H	equip_2003
		ren	I	equip_2004
		ren	J	equip_2005
		ren	K	equip_2006
		ren	L	equip_2007
		ren	M	equip_2008
		ren	N	equip_2009
		ren	O	equip_2010
		ren	P	equip_2011
		ren	Q	equip_2012
		ren	R	equip_2013
		ren	S	equip_2014
		ren	T	equip_2015
		ren	U	equip_2016
		ren	V	equip_2017
		ren	W	equip_2018
		ren	X	equip_2019
		ren	Y	equip_2020

				

			reshape long equip_, i(Category) j(year)
			ren equip_ va
			drop Line
			keep if year>=1984
			collapse (sum) va, by(year)
			saveold "$intermediate_data/[13]vawarehouset.dta", replace 
			
			************************Value_added_warehouses**************
			import excel "$raw_data/BEA_NIPA/TableHistorical_BEA_valueadded_ind.xls", sheet("download (5)") firstrow cellrange (A5:T107) clear 

		keep if Line==40
		ren B Category
		replace Category="Valueadded_ware" if Category=="Transportation and warehousing"


		 ren	C	equip_1980
		ren	D	equip_1981
		ren	E	equip_1982
		ren	F	equip_1983
		ren	G	equip_1984
		ren	H	equip_1985
		ren	I	equip_1986
		ren	J	equip_1987
		ren	K	equip_1988
		ren	L	equip_1989
		ren	M	equip_1990
		ren	N	equip_1991
		ren	O	equip_1992
		ren	P	equip_1993
		ren	Q	equip_1994
		ren	R	equip_1995
		ren	S	equip_1996
		ren	T	equip_1997
				

			reshape long equip_, i(Category) j(year)
			ren equip_ va
			drop Line
			keep if year>=1984
			destring va, replace
			collapse (sum) va, by(year)
			append using "$intermediate_data/[13]vawarehouset.dta"
		save "$intermediate_data/[13]vawarehouse.dta", replace

			
		********************gdp***************************************	
		import excel "$raw_data/BEA_NIPA/Table115_BEA_GDP.xls", sheet("download (4)") firstrow cellrange (A5:AO32) clear 

		keep if Line=="1"
		ren B Category
		ren	C	equip_1980
		ren	D	equip_1981
		ren	E	equip_1982
		ren	F	equip_1983
		ren	G	equip_1984
		ren	H	equip_1985
		ren	I	equip_1986
		ren	J	equip_1987
		ren	K	equip_1988
		ren	L	equip_1989
		ren	M	equip_1990
		ren	N	equip_1991
		ren	O	equip_1992
		ren	P	equip_1993
		ren	Q	equip_1994
		ren	R	equip_1995
		ren	S	equip_1996
		ren	T	equip_1997
		ren	U	equip_1998
		ren	V	equip_1999
		ren	W	equip_2000
		ren	X	equip_2001
		ren	Y	equip_2002
		ren	Z	equip_2003
		ren	AA	equip_2004
		ren	AB	equip_2005
		ren	AC	equip_2006
		ren	AD	equip_2007
		ren	AE	equip_2008
		ren	AF	equip_2009
		ren	AG	equip_2010
		ren	AH	equip_2011
		ren	AI	equip_2012
		ren	AJ	equip_2013
		ren	AK	equip_2014
		ren	AL	equip_2015
		ren	AM	equip_2016
		ren	AN	equip_2017
		ren	AO	equip_2018

				

			reshape long equip_, i(Category) j(year)
			ren equip_ GDP
			drop Line
			keep if year>=1984
			saveold "$intermediate_data/[13]GDP.dta", replace 
			
			merge 1:1 year using "$intermediate_data/[13]Stockwarehouse.dta", nogen
			merge 1:1 year using "$intermediate_data/[13]Investmentwarehouse.dta", nogen
			merge 1:1 year using "$intermediate_data/[13]vawarehouse.dta", nogen
			
			g inv_ware_gdp=investment/GDP
			g stock_ware_gdp=stock/GDP
			g va_gdp=va/GDP
			ren stock stock_ware
			ren investment inv_ware
			
			keep year stock_ware* inv_ware* GDP va_*
			save "$intermediate_data/[13]warehouse_IV.dta", replace
	
	
*********************************************************************
*2)1-digit
*********************************************************************
	
	*2.1 Demand IV
	
		use "$intermediate_data/[6]demand_1983_forIV_CPS_1d.dta", clear

		foreach i of numlist 1984(1)2016{
			append using "$intermediate_data/[6]demand_`i'_forIV_CPS_1d.dta"
			
		}

		save "$intermediate_data/[13]demand_allyears_forIV_CPS_nooccadj.dta", replace


		reshape long share_demand_byoccind_comp, i(demand_ind year occ1d sector share_demand_byoccind demand_ind_byoccind) j(occup)

		bys occup sector year: egen share_demand_comp=mean(share_demand_byoccind_comp)
		sort year occ1d occup 
		drop if occup~=occ1d

		g share_demand_comp12=share_demand_comp if occ1d==12
		bys year sector: egen shares_demand_comp_12=mean(share_demand_comp12)
		replace share_demand_comp=share_demand_comp+shares_demand_comp_12 if occ1d==8
		replace occ1d=8 if occ1d==12



		bys year sector: egen abstract_dem=total(demand_ind_byoccind) if occ1d==8
		bys year sector: egen abs_dem=mean(abstract_dem)


		collapse (mean) demand_ind (sum) share_demand_byoccind demand_ind_byoccind share_demand_comp, by(year occ1d sector)


		merge m:1 year using "`tradedata'"
		keep if _merge==3
		drop _merge

		local lag=5

		sort occ1d sector year
		gen lag_demand_ind=demand_ind[_n-`lag'] if occ1d[_n]==occ1d[_n-`lag'] & sector[_n]==sector[_n-`lag']
		gen lag_share_ind_byocc=share_demand_byoccind[_n-`lag'] if occ1d[_n]==occ1d[_n-`lag'] & sector[_n]==sector[_n-`lag']

		gen share_ind_byocc1980=share_demand_byoccind if year==1985
		bys occ1d sector: egen share_ind_1980=mean(share_ind_byocc1980)

		gen share_ind_1980comp=share_demand_comp if year==1985
		bys occ1d sector: egen share_ind_80comp=mean(share_ind_1980comp)


		merge m:1 year using "$raw_data/FED_working_age_population/working_age_pop.dta"
		ren workingage population
		drop _merge
		merge m:1 year using `pop_gr16'
		merge m:1 year using "$intermediate_data/[13]warehouse_IV.dta", nogen

		bys occ1d year: egen demand_IV=total(share_ind_1980*lag_demand_ind*(1+pop_gr_16yr)^10)
		bys occ1d year: egen demand_IV2=total(share_ind_1980*demand_ind)
		bys occ1d year: egen demand_IV2_comp=total(share_ind_80comp*demand_ind)
		bys occ1d year: egen demand_IV_trade=total(share_ind_80*demand_ind*trade)
		bys occ1d year: egen demand_IV_tradecomp=total(share_ind_80comp*demand_ind*trade)

		local lagd=10
		sort sector occ1d year
		gen gr_demand_ind=log(demand_ind[_n])-log(demand_ind[_n-`lagd']) if sector[_n]==sector[_n-`lagd'] & occ1d[_n]==occ1d[_n-`lagd']
		bys occ1d year: egen demand_IV2_compgr=total(share_ind_80comp*gr_demand_ind)



		bys occ1d year: egen lag_demand=total(share_ind_1980*lag_demand_ind)
		drop _merge
		duplicates drop occ1d year, force


		save "$intermediate_data/[13]demand_allyears_forIV_CPS_1d.dta", replace


	*2.2 Supply IV



	
		use "$intermediate_data/[6]supply_1983_forIV_CPS_3d.dta", clear


			foreach i of numlist 1984(1)2016{
				

				append using "$intermediate_data/[6]supply_`i'_forIV_CPS_3d.dta"
			}



			save "$intermediate_data/[13]supply_allyears_forIV_CPS_edur_3d.dta", replace



		preserve
		collapse (sum) emp_sh_age, by(year occ2d)
		save "$intermediate_data/[13]adjustment_stocks_noyoung.dta", replace
		restore



		use "$intermediate_data/[6]supply_1983_forIV_CPS_1d.dta", clear

			foreach i of numlist 1984(1)2016{
				

				append using "$intermediate_data/[6]supply_`i'_forIV_CPS_1d.dta"
			}


			save "$intermediate_data/[13]supply_allyears_forIV_CPS_edur_1d.dta", replace


		reshape long share_skill_byoccedur2_comp, i(supply_skill year occ1d edur emp_sh_age supply_skill_byocced share_skill_byoccedur share_skill_byoccedur2) j(occup)
		bys occup edur year: egen share_skill_comp=mean(share_skill_byoccedur2_comp)
		sort year occ1d occup 
		drop if occup~=occ1d


		replace occ1d=8 if occ1d==12


		collapse (mean) supply_skill (sum) emp_sh_age supply_skill_byocced share_skill_byoccedur* share_skill_comp, by(year occ1d edur)


		merge m:1 year using "`tradedata'"
		keep if _merge==3
		drop _merge


		merge 1:1 year occ1d edur using "$intermediate_data/[13]pop_all.dta", nogen  // Merge with population for instrument

		local lagbrt=16
		local lag=5
		sort occ1d edur year
		gen lag_supply_skill=supply_skill[_n-`lag'] if occ1d[_n]==occ1d[_n-`lag'] & edur[_n]==edur[_n-`lag']
		bys year: egen tot_supply_skill=total(supply_skill)
		bys year edur: egen tot_supply_skilledur=total(supply_skill)
		gen share_supply_skill=tot_supply_skilledur/tot_supply_skill

		sort occ1d edur year
		gen lag_share_supply_skill=share_supply_skill[_n-`lag'] if occ1d[_n]==occ1d[_n-`lag'] & edur[_n]==edur[_n-`lag']
		gen lag_share_skill_byocc=share_skill_byoccedur2[_n-`lag'] if occ1d[_n]==occ1d[_n-`lag'] & edur[_n]==edur[_n-`lag']

		sort occ1d edur year
		gen lag_brt= brt_rt[_n-`lagbrt'] if occ1d[_n]==occ1d[_n-`lagbrt'] & edur[_n]==edur[_n-`lagbrt']


		gen supply_skill1980=supply_skill if year==1985
		bys occ1d edur: egen supply_1980=mean(supply_skill1980)

		gen share_skill_byocc1980=share_skill_byoccedur if year==1985
		bys occ1d edur: egen share_1980=mean(share_skill_byocc1980)

		bys occ1d year: egen share_emp_noyoung=total(emp_sh_age) 

		drop _merge
		merge m:1 year using `pop_gr16'
		bys occ1d year: egen lag_supply_IV=total(lag_share_skill_byocc*lag_supply_skill)

		** The idea here is that the brt_rt gives us the new workers availage `lag' periods into the future.
		bys occ1d year: egen supply_IV_brt=total(lag_share_skill_byocc*lag_supply_skill*lag_brt)

		bys occ1d year: egen supply_IV_brt_sh=total(lag_share_skill_byocc*lag_share_supply_skill*lag_brt)


		**** SHARES IN 1980
		bys occ1d year: egen supply_IV2=total(share_1980*supply_1980*(1+pop_gr_16yr)^(`lagbrt'-1))

		** The idea here is that the brt_rt gives us the new workers availage `lag' periods into the future.
		bys occ1d year: egen supply_IV2_brt=total(share_1980*supply_1980*lag_brt)

		gen share_skill_byocc19802=share_skill_byoccedur2 if year==1985
		bys occ1d edur: egen share_1980_2=mean(share_skill_byocc19802)

		gen share_skill_byocc1980comp=share_skill_comp if year==1985
		bys occ1d edur: egen share_1980_comp=mean(share_skill_byocc1980comp)

		bys occ1d year: egen supply_IV=total(share_1980_comp*supply_skill)

		bys occ1d year: egen supply_IV_comp=total(share_1980_comp*supply_skill)

		bys occ1d year: egen supply_IV2_brt2=total(share_1980_2*supply_skill*lag_brt)

		bys occ1d year: egen supply_IV_trade=total(share_1980_comp*supply_skill*trade)

		duplicates drop occ1d year, force
		drop if year>2016
		drop _merge
		save "$intermediate_data/[13]supply_allyears_forIV_CPS_1d.dta", replace

		
		
*********************************************************************
*3)2-digit
*********************************************************************		
		
		
			
	use "$intermediate_data/[6]demand_1983_forIV_CPS_2d-elast.dta", clear

	foreach i of numlist 1984(1)2016{
			append using "$intermediate_data/[6]demand_`i'_forIV_CPS_2d-elast.dta"
			
		}



	*
	reshape long share_demand_byoccind_comp, i(demand_ind year occ_2d sector share_demand_byoccind demand_ind_byoccind) j(occup)

	bys occup sector year: egen share_demand_comp=mean(share_demand_byoccind_comp)
	sort year occ_2d occup 
	drop if occup~=occ_2d

	g share_demand_comp12=share_demand_comp if occ_2d==12
	bys year sector: egen shares_demand_comp_12=mean(share_demand_comp12)
	replace share_demand_comp=share_demand_comp+shares_demand_comp_12 if occ_2d==8




	bys year sector: egen abstract_dem=total(demand_ind_byoccind) if occ_2d==8
	bys year sector: egen abs_dem=mean(abstract_dem)

	collapse (mean) demand_ind (sum) share_demand_byoccind demand_ind_byoccind share_demand_comp, by(year occ_2d sector)




	merge m:1 year using "`tradedata'"
	keep if _merge==3
	drop _merge



	local lag=5

	sort occ_2d sector year
	gen lag_demand_ind=demand_ind[_n-`lag'] if occ_2d[_n]==occ_2d[_n-`lag'] & sector[_n]==sector[_n-`lag']
	gen lag_share_ind_byocc=share_demand_byoccind[_n-`lag'] if occ_2d[_n]==occ_2d[_n-`lag'] & sector[_n]==sector[_n-`lag']

	gen share_ind_byocc1980=share_demand_byoccind if year==1985
	bys occ_2d sector: egen share_ind_1980=mean(share_ind_byocc1980)

	gen share_ind_1980comp=share_demand_comp if year==1985
	bys occ_2d sector: egen share_ind_80comp=mean(share_ind_1980comp)



	merge m:1 year using "$raw_data/FED_working_age_population/working_age_pop.dta"
	ren workingage population
	drop _merge
	merge m:1 year using `pop_gr16'
	merge m:1 year using "$intermediate_data/[13]warehouse_IV.dta", nogen

	bys occ_2d year: egen demand_IV=total(share_ind_1980*lag_demand_ind*(1+pop_gr_16yr)^10)
	bys occ_2d year: egen demand_IV2=total(share_ind_1980*demand_ind)
	bys occ_2d year: egen demand_IV2_comp=total(share_ind_80comp*demand_ind)
	bys occ_2d year: egen demand_IV_trade=total(share_ind_80*demand_ind*trade)
	bys occ_2d year: egen demand_IV_tradecomp=total(share_ind_80comp*demand_ind*trade)

	local lagd=10
	sort sector occ_2d year
	gen gr_demand_ind=log(demand_ind[_n])-log(demand_ind[_n-`lagd']) if sector[_n]==sector[_n-`lagd'] & occ_2d[_n]==occ_2d[_n-`lagd']
	bys occ_2d year: egen demand_IV2_compgr=total(share_ind_80comp*gr_demand_ind)



	bys occ_2d year: egen lag_demand=total(share_ind_1980*lag_demand_ind)
	drop _merge
	duplicates drop occ_2d year, force


	save "$intermediate_data/[13]demand_allyears_forIV_CPS_2d-elast.dta", replace


	***** Supply**********************


		use "$intermediate_data/[6]supply_1983_forIV_CPS_2d-elast.dta", clear

		foreach i of numlist 1984(1)2016{
			

			append using "$intermediate_data/[6]supply_`i'_forIV_CPS_2d-elast.dta"
		}




	reshape long share_skill_byoccedur2_comp, i(supply_skill year occ_2d edur emp_sh_age supply_skill_byocced share_skill_byoccedur share_skill_byoccedur2) j(occup)
	bys occup edur year: egen share_skill_comp=mean(share_skill_byoccedur2_comp)
	sort year occ_2d occup 
	drop if occup~=occ_2d



	collapse (mean) supply_skill (sum) emp_sh_age supply_skill_byocced share_skill_byoccedur* share_skill_comp, by(year occ_2d edur)


	merge m:1 year using "`tradedata'"
	keep if _merge==3
	drop _merge



	merge 1:1 year occ_2d edur using "$intermediate_data/[13]pop_all_2d.dta", nogen  // Merge with population for instrument

	local lagbrt=16
	local lag=5
	sort occ_2d edur year
	gen lag_supply_skill=supply_skill[_n-`lag'] if occ_2d[_n]==occ_2d[_n-`lag'] & edur[_n]==edur[_n-`lag']
	bys year: egen tot_supply_skill=total(supply_skill)
	bys year edur: egen tot_supply_skilledur=total(supply_skill)
	gen share_supply_skill=tot_supply_skilledur/tot_supply_skill

	sort occ_2d edur year
	gen lag_share_supply_skill=share_supply_skill[_n-`lag'] if occ_2d[_n]==occ_2d[_n-`lag'] & edur[_n]==edur[_n-`lag']
	gen lag_share_skill_byocc=share_skill_byoccedur2[_n-`lag'] if occ_2d[_n]==occ_2d[_n-`lag'] & edur[_n]==edur[_n-`lag']

	sort occ_2d edur year
	gen lag_brt= brt_rt[_n-`lagbrt'] if occ_2d[_n]==occ_2d[_n-`lagbrt'] & edur[_n]==edur[_n-`lagbrt']


	gen supply_skill1980=supply_skill if year==1985
	bys occ_2d edur: egen supply_1980=mean(supply_skill1980)

	gen share_skill_byocc1980=share_skill_byoccedur if year==1985
	bys occ_2d edur: egen share_1980=mean(share_skill_byocc1980)

	bys occ_2d year: egen share_emp_noyoung=total(emp_sh_age) 

	drop _merge
	merge m:1 year using `pop_gr16'
	**** LAGGED SHARES
	bys occ_2d year: egen lag_supply_IV=total(lag_share_skill_byocc*lag_supply_skill)

	** The idea here is that the brt_rt gives us the new workers availage `lag' periods into the future.
	bys occ_2d year: egen supply_IV_brt=total(lag_share_skill_byocc*lag_supply_skill*lag_brt)

	bys occ_2d year: egen supply_IV_brt_sh=total(lag_share_skill_byocc*lag_share_supply_skill*lag_brt)


	**** SHARES IN 1980
	bys occ_2d year: egen supply_IV2=total(share_1980*supply_1980*(1+pop_gr_16yr)^(`lagbrt'-1))

	** The idea here is that the brt_rt gives us the new workers availage `lag' periods into the future.
	bys occ_2d year: egen supply_IV2_brt=total(share_1980*supply_1980*lag_brt)

	gen share_skill_byocc19802=share_skill_byoccedur2 if year==1985
	bys occ_2d edur: egen share_1980_2=mean(share_skill_byocc19802)

	gen share_skill_byocc1980comp=share_skill_comp if year==1985
	bys occ_2d edur: egen share_1980_comp=mean(share_skill_byocc1980comp)

	bys occ_2d year: egen supply_IV=total(share_1980_comp*supply_skill)

	bys occ_2d year: egen supply_IV_comp=total(share_1980_comp*supply_skill)

	bys occ_2d year: egen supply_IV2_brt2=total(share_1980_2*supply_skill*lag_brt)

	bys occ_2d year: egen supply_IV_trade=total(share_1980_comp*supply_skill*trade)

	duplicates drop occ_2d year, force
	drop if year>2016

	drop _merge
	save "$intermediate_data/[13]supply_allyears_forIV_CPS_nooccadj_2d-elast.dta", replace

			
		
		
		
