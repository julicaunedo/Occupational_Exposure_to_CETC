function [cc_pi_oj_gh_j,cc_xtilda_j,cc_wh_p_j,temp2]=counter_help(pp,alpha_mat,elast_s,ii_cd,mm_lambda_o,alpha_bar,...
    cc_lambda_j,cc_z,cc_Th,cc_omegas,cc_pi_h,nn,bb,maxiter,para,c_ysel,y_sel,altx)
    
n_o=nn(1);n_y=nn(4);
theta_w=para(1);

%%min, max, and initial guess on eqm occupational prices
help1=alpha_mat.^(-1.*(elast_s).^(-1));help1(ii_cd,:,:)=nan;
scale=permute(help1(:,1,:),[1,3,2]); 
factor=scale.*permute(cc_lambda_j,[1,3,2]);
max_lj=permute(factor*1.01,[1,3,2]);min_lj=permute(factor*0.99,[1,3,2]); 
min_lo=max_lj;max_lo=10^20.*ones(size(min_lo)); 
ii_osub=find(elast_s(:,1,1)>0);
max_lo(ii_osub,:,:)=min_lj(ii_osub,:,:);
min_lo(ii_osub,:,:)=10^(-20);min_lo(ii_cd,:,:)=10^(-20);min_lo_in=min_lo;max_lo_in=max_lo;
mm_lambda_o_guess=mm_lambda_o;
mm_lambda_o_guess(mm_lambda_o_guess<min_lo_in)=min_lo_in(mm_lambda_o_guess<min_lo_in);
mm_lambda_o_guess(mm_lambda_o_guess>max_lo_in)=max_lo_in(mm_lambda_o_guess>max_lo_in);
%%solve for eqm occupational prices
temp1=nan(n_o,1,n_y);temp2=nan(1,n_y);
t=c_ysel; %%baseline year
    [out1,out2]=solve_forlambdao(maxiter,para,cc_Th(:,t),cc_z(:,:,t),cc_omegas(:,:,t),elast_s(:,:,t),alpha_mat(:,:,t),ii_cd,cc_lambda_j(:,:,t),cc_pi_h(:,t),bb,nn,mm_lambda_o_guess(:,:,t),min_lo_in(:,:,t),max_lo_in(:,:,t));
    temp1(:,1,t)=out1;temp2(1,t)=out2;   
t=y_sel; %%counterfactual year
    if altx==1 | pp>1
         [out1,out2]=solve_forlambdao(maxiter,para,cc_Th(:,t),cc_z(:,:,t),cc_omegas(:,:,t),elast_s(:,:,t),alpha_mat(:,:,t),ii_cd,cc_lambda_j(:,:,t),cc_pi_h(:,t),bb,nn,mm_lambda_o_guess(:,:,c_ysel),min_lo_in(:,:,t),max_lo_in(:,:,t));
       if out2>10^(-4)
            [out1_1,out2_1]=solve_forlambdao(maxiter,para,cc_Th(:,t),cc_z(:,:,t),cc_omegas(:,:,t),elast_s(:,:,t),alpha_mat(:,:,t),ii_cd,cc_lambda_j(:,:,t),cc_pi_h(:,t),bb,nn,mm_lambda_o_guess(:,:,t),min_lo_in(:,:,t),max_lo_in(:,:,t));
            if out2_1<out2
                out1=out1_1;out2=out2_1;
            end
       end

    else
        [out1,out2]=solve_forlambdao(maxiter,para,cc_Th(:,t),cc_z(:,:,t),cc_omegas(:,:,t),elast_s(:,:,t),alpha_mat(:,:,t),ii_cd,cc_lambda_j(:,:,t),cc_pi_h(:,t),bb,nn,mm_lambda_o_guess(:,:,t),min_lo_in(:,:,t),max_lo_in(:,:,t));
    end
    temp1(:,1,t)=out1;temp2(1,t)=out2;     
cc_lambda_o=temp1;
%%equilibrium outcomes
cc_xtilda_j=compute_xtilda(cc_lambda_o,cc_lambda_j,alpha_mat,elast_s,nn,alpha_bar);
[cc_xtilda_j]=corr_corner(cc_xtilda_j);
num=(cc_z.*cc_xtilda_j).^theta_w;
den=repmat(nansum(num,1),[n_o,1,1]);
cc_pi_oj_gh_j=num.*(den).^(-1);
Th_help=repmat(permute(cc_Th,[3,1,2]),[n_o,1,1]);
cc_wh_p_j=(nansum(Th_help.*(cc_z.*cc_xtilda_j).^(theta_w),1)).^(1/theta_w).*gamma(1-1/theta_w);
cc_wh_p_j=permute(cc_wh_p_j,[2,3,1]);