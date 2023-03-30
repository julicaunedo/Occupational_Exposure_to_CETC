function [mm_y,mm_y_alt]=compute_output(pi_h,para,mm_pi_oj_gh,mm_Th,mm_z,mm_lambda_o,mm_omegas,mm_lambda_j,mm_xtilda,elast_s,alpha_mat,ii_cd,bb,nn)

n_o=nn(1);n_g=nn(3);
theta_w=para(1);rho=para(2);

dd_pi_type=permute(pi_h,[3,1,2]);
T_h_st=repmat(permute(mm_Th,[3,1,2]),[n_o,1,1]);
eff_byt=(T_h_st).^(1/theta_w).*gamma(1-1/theta_w).*mm_pi_oj_gh.^(-1/theta_w+1);
mm_eeff=eff_byt.*repmat(dd_pi_type,[n_o,1,1]);
mm_k=mm_eeff.*(alpha_mat.*(1-alpha_mat).^(-1).*mm_xtilda.*mm_z.*repmat(mm_lambda_j,[1,n_g,1]).^(-1).*mm_z.^(-elast_s)).^((1-elast_s).^(-1));
mm_k(mm_z==0)=nan;
mm_y=(alpha_mat.*mm_k.^elast_s+(1-alpha_mat).*(mm_z.*mm_eeff).^elast_s).^((elast_s).^(-1));
mm_yo=nansum(mm_y,2);
mm_k_cd=mm_eeff.*mm_z.*(alpha_mat.*repmat(mm_lambda_o,[1,n_g,1])...
    .*repmat(mm_lambda_j,[1,n_g,1]).^(-1)).^((1-alpha_mat).^(-1));
mm_k_cd(mm_z==0)=nan;
mm_y_cd=mm_k_cd.^alpha_mat.*(mm_z.*mm_eeff).^(1-alpha_mat);
mm_yo_cd=nansum(mm_y_cd,2);
mm_yo(ii_cd,:,:)=mm_yo_cd(ii_cd,:,:);
mm_y=sum(mm_omegas.^(1/rho).*mm_yo.^((rho-1)/rho),1).^(rho/(rho-1));
mm_y=permute(mm_y,[3,2,1]);
mm_y_alt=nansum(mm_yo.*mm_lambda_o,1);
mm_y_alt=permute(mm_y_alt,[3,2,1]);

