function [lambda_o_eq,ddist]=solve_forlambdao(maxiter,para,mm_Th,mm_z,mm_omegas,elast_s,...
    alpha_mat,ii_cd,mm_lambda_j,dd_pi_type,bb,nn,ic_in,min_lo,max_lo)

options_fsolve=optimoptions(@fsolve,'Display','off','MaxFunEvals',10^10,'MaxIter',maxiter,'TolX',10^(-20));
o_b=bb(1);n_o=nn(1);rho=para(2);

%%relative price
ic_in_fun=ic_in.*(ic_in(o_b)).^(-1);ic_in_fun(o_b)=[];
[out1,out2]=fsolve(@(x) solve_forlambdao_help(x,para,mm_Th,mm_z,mm_omegas,elast_s,alpha_mat,ii_cd,mm_lambda_j,...
    dd_pi_type,bb,nn,min_lo,max_lo),...
       ic_in_fun,options_fsolve);
%%price level
lambdao_rel=out1;
index=[1:1:n_o];index(o_b)=[];
a_rel=mm_omegas(index)/mm_omegas(o_b);
rel_d=(a_rel.*(lambdao_rel).^(-rho));
tildeA=1+nansum(a_rel.^(1/rho).*(rel_d).^((rho-1)/rho),1);
lambdao_b=((mm_omegas(o_b).*tildeA).^(-1)).^(1/(1-rho));     
lambdao_rel_in=[lambdao_rel(1:o_b-1);1;lambdao_rel(o_b:n_o-1)];
lambda_o_eq=lambdao_b.*lambdao_rel_in;
%%distance
ddist=nansum(abs(out2));



