file_theta='../../empirics/modeldata/TailFrechet.xlsx';
file_gamma1='../../empirics/modeldata/ES_capital_goods.xlsx';
file_sigma='../../empirics/modeldata/Elasticities.xlsx';

[theta_w] = xlsread(file_theta,'average','a2'); 
theta_w=round(theta_w,3);
[gamma_1] = xlsread(file_gamma1,'gamma','a2'); 
gamma_1=round(gamma_1,3);
[est_iv] = xlsread(file_sigma,'1_digit','b2:b10'); 
est_iv=round(est_iv,3);
[aggregate_elast] = xlsread(file_sigma,'Aggregate_Elasticity','a2'); 
aggregate_elast=round(aggregate_elast,3);
