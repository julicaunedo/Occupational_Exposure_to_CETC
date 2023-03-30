function [mm_omega,mm_yo_val]=solve_occprodshares(pi_h,para,mm_pi_oj_gh,mm_Th,mm_z,lambda_o,mm_lambda_j,mm_xtilda,elast_s,alpha_mat,ii_cd,bb,nn)

o_b=bb(1);n_o=nn(1);n_g=nn(3);
theta_w=para(1);rho=para(2);

dd_pi_type=permute(pi_h,[3,1,2]);
%%relative
T_h_st=repmat(permute(mm_Th,[3,1,2]),[n_o,1,1]);
eff_byt=(T_h_st).^(1/theta_w).*gamma(1-1/theta_w).*mm_pi_oj_gh.^(-1/theta_w+1);
mm_eeff=eff_byt.*repmat(dd_pi_type,[n_o,1,1]);
mm_k=mm_eeff.*(alpha_mat.*(1-alpha_mat).^(-1).*mm_xtilda.*mm_z.*repmat(mm_lambda_j,[1,n_g,1]).^(-1).*mm_z.^(-elast_s)).^((1-elast_s).^(-1));
mm_k(mm_z==0)=nan;
mm_y=(alpha_mat.*mm_k.^elast_s+(1-alpha_mat).*(mm_z.*mm_eeff).^elast_s).^((elast_s).^(-1));
mm_yo=nansum(mm_y,2);
mm_k_cd=mm_eeff.*mm_z.*(alpha_mat.*repmat(lambda_o,[1,n_g,1])...
    .*repmat(mm_lambda_j,[1,n_g,1]).^(-1)).^((1-alpha_mat).^(-1));
mm_k_cd(mm_z==0)=nan;
mm_y_cd=mm_k_cd.^alpha_mat.*(mm_z.*mm_eeff).^(1-alpha_mat);
mm_yo_cd=nansum(mm_y_cd,2);
mm_yo(ii_cd,:,:)=mm_yo_cd(ii_cd,:,:);
mm_yo_val=mm_yo.*lambda_o;
lambda_o_rel=lambda_o.*(repmat(lambda_o(o_b,:,:),[n_o,1,1])).^(-1);
dd_yo_rel_val=mm_yo_val.*(repmat(mm_yo_val(o_b,:,:),[n_o,1,1])).^(-1);
mm_omega_rel=(dd_yo_rel_val).*...
    (lambda_o_rel).^(rho-1);
%%level
dd_yo_rel=mm_yo.*(repmat(mm_yo(o_b,:,:),[n_o,1,1])).^(-1);
lambda_o_lev=lambda_o(o_b,:,:);
tildeA=nansum(mm_omega_rel.^(1/rho).*(dd_yo_rel).^((rho-1)/rho),1);
mm_omega_lev_A=tildeA.^(-1).*lambda_o_lev.^(rho-1);
mm_omega=mm_omega_rel.*(repmat(mm_omega_lev_A,[n_o,1,1,1]));
