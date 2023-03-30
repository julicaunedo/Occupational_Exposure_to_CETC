%%% This code calls the routines that load the data, run the exercises in
%%% sections 4.2, 5 and 6 of the paper and produce the corresponding tables
%%% and figures (tables are saved in tables_paper.xslx, sheet Tables_paper
%%% and figures are saved in .pdf and .eps with labels as in the paper).
tic
%% Data load and figures 5.1, BI, BII
run AA_data.m

%% Estimation of the elasticity across occupational goods (rho)
run AA_estimation_rho.m 

%% Calibration, main counterfactual, and prediction exercise
run AA_model_baseline.m

%% Alternative exercises: "identical elasticity" and "identical CETC"
run AA_alternative_exercise.m

%% Model with multiple capital goods
run AA_model_multiple_equipment.m
toc
%Elapsed time is 789.821885 seconds.