%%% This code loads and organizes the data used in the quantitative 
%%% exercises. These data are all outcomes of the empirics block of the 
%%% replication files. In addition, this code produces figures BI and BII. 

%% General parameters
%%occupational labels 
clear all
clc
[in_w1980,occ_label_iso]=xlsread('occ_label.xlsx','label', 'a4:b12'); 
occ_label_iso_w1980=occ_label_iso(in_w1980);

for i=1:numel(in_w1980)
    oc_code_or{i,1}=strcat('O_{',num2str(i),'}');
end
oc_code=oc_code_or(in_w1980);
save occ_labels.mat oc_code occ_label_iso_w1980 in_w1980
%%baseline occupation 
o_b=6; %low-skill services
save baseo.mat o_b

%% Estimates from the empirics
%%estimates of theta (theta_w), rho, and phi (gamma_1)
run estimates_load.m
save theta_w.mat theta_w %%tail parameters in the Frechet efficiency draws
save sigma.mat est_iv aggregate_elast %%elasticity of substitution between capital and labor
save gamma.mat gamma_1 %%elasticity of substitution across capital goods in the model with multiple capital goods

%% Employment, capital stock, and usercost by occupation and capital good
%decennial frequency
clear all
close all
clc
c_years=[1985,1990,2000,2010,2016];
run data_load.m 
save data_main.mat rdata_census_age data_pi_s y_list data_usercost_occ data_stock_occ instrument_lev
save data_info.mat info_census_age list_o list_s list_k list_a list_g c_years ident 
clc
clear all
close all
load data_main.mat
load data_info.mat
run data_derive.m
save data_main.mat
%%annual frequency
clear all
close all
clc
c_years=[1985:1:2016];
run data_load.m 
save data_main_yby.mat rdata_census_age data_pi_s y_list data_usercost_occ data_stock_occ instrument_lev
save data_info_yby.mat info_census_age list_o list_s list_k list_a list_g c_years ident 
clc
clear all
close all
load data_main_yby.mat
load data_info_yby.mat
run data_derive.m
save data_main_yby.mat

%% Figures BI and BII
clc
clear all
close all
run figures_appendix.m

