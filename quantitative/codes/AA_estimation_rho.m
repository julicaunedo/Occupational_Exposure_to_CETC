%%% This code estimates the elasticity of substitution across occupational 
%%% goods (rho) using annual data and saves it in rho.mat

%%select the elasticity of subtitution between capital and labor
clear all
close all
clc
ii_cdsd=0; %%=0 occupational elasticities, =1 aggregate elasticity
run sel_elast.m
%%initiate rho
rho=nan;
save rho.mat rho
%%prepare the data for the calibration
clear all
close all
clc
yby=1; %%=0 decennial data, =1 yearly data
run data_for_model.m
%%run the calibration
clc
clear all
close all
same_pk=0; %%=0 occupational usercosts, =1 aggregate usercost   
yby=1; %%=0 decennial data, =1 yearly data
model_me=0; %%=0 baseline model, ==1 model with multiple capital goods
run model_solve.m
%%run the estimation
clear all 
clc
run est_rho.m
rho=rho_est(2); %%IV estimate
save rho.mat rho

