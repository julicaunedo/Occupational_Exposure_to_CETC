
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Generate a series of investment quantities by NIPA equipment

Data from Bureau of Economic Analisys is public and comes from : https://apps.bea.gov/iTable/index_nipa.cfm (downloaded June 2021)
********************************************/

	
*********************************************************************



*1* Investment data
	import excel "$raw_data/BEA_NIPA/Table2.7_BEA_current_cost_investment.xls", sheet("Sheet0") firstrow cellrange (A6:DP86) clear 
*https://apps.bea.gov/iTable/iTable.cfm?0=16&isuri=1&reqid=10&step=3

	ren Line equipment
	destring equipment, replace

	* lines to nipa_codes
	gen nipa_code =. 
	replace nipa_code = 4 if equipment == 5
	replace nipa_code = 5 if equipment == 6
	replace nipa_code = 6 if equipment == 7
	replace nipa_code = 9 if equipment == 8
	replace nipa_code = 10 if equipment == 9
	replace nipa_code = 11 if equipment == 10
	replace nipa_code = 13 if equipment == 12
	replace nipa_code = 14 if equipment == 13
	replace nipa_code = 17 if equipment == 14
	replace nipa_code = 18 if equipment == 15
	replace nipa_code = 19 if equipment == 16
	replace nipa_code = 20 if equipment == 17
	replace nipa_code = 22 if equipment == 19
	replace nipa_code = 25 if equipment == 22
	replace nipa_code = 26 if equipment == 23
	replace nipa_code = 27 if equipment == 24
	replace nipa_code = 28 if equipment == 25
	replace nipa_code = 30 if equipment == 27
	replace nipa_code = 33 if equipment == 28
	replace nipa_code = 36 if equipment == 29
	replace nipa_code = 39 if equipment == 30
	replace nipa_code = 40 if equipment == 31
	replace nipa_code = 41 if equipment == 32
	replace nipa_code = 29 if equipment == 33
	replace nipa_code = 99 if equipment == 78


	drop if nipa_code == .


	*** Change columns by years *** 

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

	ren equipment nipa_line

	saveold "$intermediate_data/[4]Investment_by_asset_type_wide.dta", replace  // nominal investment  

	
	
	merge 1:1 nipa_code using "$raw_data/PriceKquality/prices_by_asset_type_with_software_091720.dta"
	drop if _merge != 3 // drop years without prices
	drop _merge
	
*** merge with non-quality adjusted prices of investment	
*
	merge 1:1 nipa_code using "$intermediate_data/[3]BEA_non_quality_ajusted_price.dta"
	drop if _merge != 3 // drop years without prices
	drop _merge
*DROP DETAIL
	
*3* Long format 
	reshape long equip_ price_ naprice_ , i(nipa_line nipa_code) j(year)
	
	*Merge with CPI
	merge m:1 year using "$raw_data/FED_PCEPI/pcepi_052021_base85.dta"
	drop if _merge != 3
	drop _merge	

	replace nipa_code = 2225 if nipa_code == 22
	replace nipa_code = 2225 if nipa_code == 25

	drop nipa_line
		*naprice_
		ren pcepi cpi
		
	collapse (sum)	equip_ (mean) price_ cpi naprice_, by(nipa_code year)  // collapse cars and trucks

	preserve
	keep price_ nipa_code year
	reshape wide price_, i(nipa_code) j(year)
	save "$intermediate_data/[4]prices_by_asset_type.dta", replace
	restore
	
* 4* Export data	
	drop if 	price_ == .
	saveold "$intermediate_data/[4]Investment_quantity_long.dta", replace

*naprice_
	reshape wide equip_ price_ cpi naprice_, i(nipa_code) j(year) 

	order nipa_code equip_*

	saveold "$intermediate_data/[4]Investment_quantity_wide.dta", replace


// End of do file
