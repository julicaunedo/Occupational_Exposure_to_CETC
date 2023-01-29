
/*********************************************************************

*	Occupational exposure to capital-embodied technical change

Generate a series of non-quality adjusted price series

Data from Bureau of Economic Analisys is public and comes from : https://apps.bea.gov/iTable/index_nipa.cfm (downloaded June 2021)
********************************************/

	

* A) price indexes for all Nipa except software

	*1* Price data
		import excel "$raw_data/BEA_NIPA/Table5.5.4_Price_Indexes_for_Private_Fixed_Investment_in_Equipment_by_Type.xls", sheet("Sheet0") firstrow cellrange (A6:CN41) clear 


		ren Line equipment
		destring equipment, replace

		* lines to nipa_codes
		gen nipa_code =. 
		replace nipa_code = 4 if equipment == 4
		replace nipa_code = 5 if equipment == 5
		replace nipa_code = 6 if equipment == 6
		replace nipa_code = 9 if equipment == 7
		replace nipa_code = 10 if equipment == 8
		replace nipa_code = 11 if equipment == 9
		replace nipa_code = 13 if equipment == 11
		replace nipa_code = 14 if equipment == 12
		replace nipa_code = 17 if equipment == 13
		replace nipa_code = 18 if equipment == 14
		replace nipa_code = 19 if equipment == 15
		replace nipa_code = 20 if equipment == 16
		*Allocated Transportation equipment
		replace nipa_code = 22 if equipment == 18
		replace nipa_code = 25 if equipment == 21
		replace nipa_code = 26 if equipment == 22
		replace nipa_code = 27 if equipment == 23
		replace nipa_code = 28 if equipment == 24
		replace nipa_code = 30 if equipment == 26
		replace nipa_code = 33 if equipment == 27
		replace nipa_code = 36 if equipment == 28
		replace nipa_code = 39 if equipment == 29
		replace nipa_code = 40 if equipment == 30
		replace nipa_code = 41 if equipment == 31
		replace nipa_code = 29 if equipment == 32


		drop if nipa_code == .


		*** Change columns by years*** 
		ren C naprice_1929
		ren D naprice_1930
		ren E naprice_1931
		ren F naprice_1932
		ren G naprice_1933
		ren H naprice_1934
		ren I naprice_1935
		ren J naprice_1936
		ren K naprice_1937
		ren L naprice_1938
		ren M naprice_1939
		ren N naprice_1940
		ren O naprice_1941
		ren P naprice_1942
		ren Q naprice_1943
		ren R naprice_1944
		ren S naprice_1945
		ren T naprice_1946
		ren U naprice_1947
		ren V naprice_1948
		ren W naprice_1949
		ren X naprice_1950
		ren Y naprice_1951
		ren Z naprice_1952
		ren AA naprice_1953
		ren AB naprice_1954
		ren AC naprice_1955
		ren AD naprice_1956
		ren AE naprice_1957
		ren AF naprice_1958
		ren AG naprice_1959
		ren AH naprice_1960
		ren AI naprice_1961
		ren AJ naprice_1962
		ren AK naprice_1963
		ren AL naprice_1964
		ren AM naprice_1965
		ren AN naprice_1966
		ren AO naprice_1967
		ren AP naprice_1968
		ren AQ naprice_1969
		ren AR naprice_1970
		ren AS naprice_1971
		ren AT naprice_1972
		ren AU naprice_1973
		ren AV naprice_1974
		ren AW naprice_1975
		ren AX naprice_1976
		ren AY naprice_1977
		ren AZ naprice_1978
		ren BA naprice_1979
		ren BB naprice_1980
		ren BC naprice_1981
		ren BD naprice_1982
		ren BE naprice_1983
		ren BF naprice_1984
		ren BG naprice_1985
		ren BH naprice_1986
		ren BI naprice_1987
		ren BJ naprice_1988
		ren BK naprice_1989
		ren BL naprice_1990
		ren BM naprice_1991
		ren BN naprice_1992
		ren BO naprice_1993
		ren BP naprice_1994
		ren BQ naprice_1995
		ren BR naprice_1996
		ren BS naprice_1997
		ren BT naprice_1998
		ren BU naprice_1999
		ren BV naprice_2000
		ren BW naprice_2001
		ren BX naprice_2002
		ren BY naprice_2003
		ren BZ naprice_2004
		ren CA naprice_2005
		ren CB naprice_2006
		ren CC naprice_2007
		ren CD naprice_2008
		ren CE naprice_2009
		ren CF naprice_2010
		ren CG naprice_2011
		ren CH naprice_2012
		ren CI naprice_2013
		ren CJ naprice_2014
		ren CK naprice_2015
		ren CL naprice_2016
		ren CM naprice_2017
		ren CN naprice_2018
		

		ren equipment nipa_line

		drop nipa_line
			
		collapse (mean) naprice_* , by(nipa_code)  // collapse cars and trucks
		
	* 3* Export data	
		saveold "$intermediate_data/[3]BEA_non_quality_ajusted_price_except_software.dta", replace

*B* Add software

	*1* Investment data
		import excel "$raw_data/BEA_NIPA/Table5.6.4_Price_Indexes_for_Intellectual_property_product.xls", sheet("Sheet0") firstrow cellrange (A6:CN9) clear 
	

		ren Line equipment
		destring equipment, replace

		*Keep software
		gen nipa_code = 99 if equipment == 2

		drop if nipa_code == .


		*** Change columns by years*** 
		ren C naprice_1929
		ren D naprice_1930
		ren E naprice_1931
		ren F naprice_1932
		ren G naprice_1933
		ren H naprice_1934
		ren I naprice_1935
		ren J naprice_1936
		ren K naprice_1937
		ren L naprice_1938
		ren M naprice_1939
		ren N naprice_1940
		ren O naprice_1941
		ren P naprice_1942
		ren Q naprice_1943
		ren R naprice_1944
		ren S naprice_1945
		ren T naprice_1946
		ren U naprice_1947
		ren V naprice_1948
		ren W naprice_1949
		ren X naprice_1950
		ren Y naprice_1951
		ren Z naprice_1952
		ren AA naprice_1953
		ren AB naprice_1954
		ren AC naprice_1955
		ren AD naprice_1956
		ren AE naprice_1957
		ren AF naprice_1958
		ren AG naprice_1959
		ren AH naprice_1960
		ren AI naprice_1961
		ren AJ naprice_1962
		ren AK naprice_1963
		ren AL naprice_1964
		ren AM naprice_1965
		ren AN naprice_1966
		ren AO naprice_1967
		ren AP naprice_1968
		ren AQ naprice_1969
		ren AR naprice_1970
		ren AS naprice_1971
		ren AT naprice_1972
		ren AU naprice_1973
		ren AV naprice_1974
		ren AW naprice_1975
		ren AX naprice_1976
		ren AY naprice_1977
		ren AZ naprice_1978
		ren BA naprice_1979
		ren BB naprice_1980
		ren BC naprice_1981
		ren BD naprice_1982
		ren BE naprice_1983
		ren BF naprice_1984
		ren BG naprice_1985
		ren BH naprice_1986
		ren BI naprice_1987
		ren BJ naprice_1988
		ren BK naprice_1989
		ren BL naprice_1990
		ren BM naprice_1991
		ren BN naprice_1992
		ren BO naprice_1993
		ren BP naprice_1994
		ren BQ naprice_1995
		ren BR naprice_1996
		ren BS naprice_1997
		ren BT naprice_1998
		ren BU naprice_1999
		ren BV naprice_2000
		ren BW naprice_2001
		ren BX naprice_2002
		ren BY naprice_2003
		ren BZ naprice_2004
		ren CA naprice_2005
		ren CB naprice_2006
		ren CC naprice_2007
		ren CD naprice_2008
		ren CE naprice_2009
		ren CF naprice_2010
		ren CG naprice_2011
		ren CH naprice_2012
		ren CI naprice_2013
		ren CJ naprice_2014
		ren CK naprice_2015
		ren CL naprice_2016
		ren CM naprice_2017
		ren CN naprice_2018
		

		ren equipment nipa_line

		drop nipa_line
			
		forvalues i = 1929(1)1958{ 
		replace naprice_`i' = "."
		destring naprice_`i' , replace
		}

	
* C)  Append with prices from other equipment created in A	
	append using  "$intermediate_data/[3]BEA_non_quality_ajusted_price_except_software.dta"

*  Export data	
	*drop if 	price_ == .
	saveold "$intermediate_data/[3]BEA_non_quality_ajusted_price.dta", replace

	
// End of do file
