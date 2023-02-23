file_theta='../../empirics/modeldata/TailFrechet.xlsx';
file_gamma1='../../empirics/modeldata/ES_capital_goods.xlsx';
file_sigma='../../empirics/modeldata/Elasticities.xlsx';

[temp] = readtable(file_theta,'Sheet','average'); 
theta_w=round(temp{:,:},3);
[temp] = readtable(file_gamma1,'Sheet','gamma');temp=temp{:,:};
gamma_1=round(temp(1),3);
[temp] = readtable(file_sigma,'Sheet','1_digit');temp=temp{:,:};
est_iv=round(temp(:,2),3);
[temp] = readtable(file_sigma,'Sheet','Aggregate_Elasticity');temp=temp{:,:};
aggregate_elast=round(temp,3);

