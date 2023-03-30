%% Loading
load model_calib.mat
load data_info.mat
load mm_z_dec.mat
maxiter=maxiter_in;
n_y=nn(4);

%% Counterfactual paramters
cc_lambda_j=repmat(mm_lambda_j(:,:,c_ysel),[1,1,n_y]);
if model_me==1 %%model with multiple capital goods
    if shift_cg==1 %%counterfactual: computers
        cc_pk_k_oj=pk_k_oj;cc_pk_k_oj(:,1,:)=repmat(cc_pk_k_oj(:,1,c_ysel),[1,1,n_y]);
    elseif shift_cg==2 %%counterfactual: communication equipment
        cc_pk_k_oj=pk_k_oj;cc_pk_k_oj(:,2,:)=repmat(cc_pk_k_oj(:,2,c_ysel),[1,1,n_y]);
    elseif shift_cg==3 %%counterfactual: software
        cc_pk_k_oj=pk_k_oj;cc_pk_k_oj(:,24,:)=repmat(cc_pk_k_oj(:,24,c_ysel),[1,1,n_y]);
    end
    rescale=[];cc_lambda_j=[];rescale=[];
    gamma_1=para(4);
    if gamma_1>0
        if gamma_1==1
            for i=1:n_o
                for t=1:n_y
                    pk_k_oj_sel=cc_pk_k_oj(i,:,t);sh_oj_sel=sh_oj(i,:,t);
                    pk_k_oj_sel(sh_oj_sel==0)=[];sh_oj_sel(sh_oj_sel==0)=[];
                    pk_k_oj_sel(isnan(pk_k_oj_sel)==1)=1;
                    rescale(i,:,t)=prod(sh_oj_sel.^(-sh_oj_sel),2);
                    cc_lambda_j(i,:,t)=rescale(i,:,t).*prod(pk_k_oj_sel.^(sh_oj_sel),2);
                end
            end
        else
           cc_lambda_j=nansum(sh_oj.*cc_pk_k_oj.^(1-gamma_1),2).^(1/(1-gamma_1));
        end
    end
end
cc_z_o_in=repmat(z_o(:,c_ysel),[1,n_y]);
cc_z_g_in=repmat(z_g(:,c_ysel),[1,n_y]);
cc_z_resi=repmat(z_resi(:,:,c_ysel),[1,1,n_y]);
cc_Th=repmat(mm_Th(:,c_ysel),[1,n_y]);
cc_omegas=repmat(mm_omegas(:,:,c_ysel),[1,1,n_y]);
cc_pi_h=repmat(dd_pi_h(:,c_ysel),[1,n_y]);
%%counterfactual list
load order_in.mat %%counterfactual order
if altx==1 | model_me==1 %%alternative experiment and multiple capital goods model, we only report the effect of CETC
    aaout=[1,2,3,5,9,12,13,14,15,16,17,20,21,22,23,24];
    order_in(aaout,:)=[];
end

%% Run the counterfactuals
for zz=1:size(order_in,1)
    cc_lambda_j_sel=repmat(nan(size(cc_lambda_j)),[1,1,1,5]);
    cc_z_o_in_sel=repmat(nan(size(z_o)),[1,1,1,5]);
    cc_z_g_in_sel=repmat(nan(size(z_g)),[1,1,1,5]);
    cc_z_resi_sel=repmat(nan(size(z_resi)),[1,1,1,5]);
    cc_Th_sel=repmat(nan(size(mm_Th)),[1,1,1,5]);
    cc_omegas_sel=repmat(nan(size(mm_omegas)),[1,1,1,5]);
    cc_pi_h_sel=repmat(nan(size(dd_pi_h)),[1,1,1,5]);
    order_in_to=order_in(zz,:);
    %%counter1
    sel_pp_in=find(order_in_to==1);
    cc_lambda_j_sel(:,:,:,1:sel_pp_in-1)=repmat(mm_lambda_j,[1,1,1,sel_pp_in-1]);
    cc_lambda_j_sel(:,:,:,sel_pp_in:5)=repmat(cc_lambda_j,[1,1,1,6-sel_pp_in]);
    %%counter2
    sel_pp_in=find(order_in_to==2);
    cc_z_o_in_sel(:,:,:,1:sel_pp_in-1)=repmat(z_o,[1,1,1,sel_pp_in-1]);
    cc_z_o_in_sel(:,:,:,sel_pp_in:5)=repmat(cc_z_o_in,[1,1,1,6-sel_pp_in]);
    cc_omegas_sel(:,:,:,1:sel_pp_in-1)=repmat(mm_omegas,[1,1,1,sel_pp_in-1]);
    cc_omegas_sel(:,:,:,sel_pp_in:5)=repmat(cc_omegas,[1,1,1,6-sel_pp_in]);
    %%counter3
    sel_pp_in=find(order_in_to==3);
    cc_z_g_in_sel(:,:,:,1:sel_pp_in-1)=repmat(z_g,[1,1,1,sel_pp_in-1]);
    cc_z_g_in_sel(:,:,:,sel_pp_in:5)=repmat(cc_z_g_in,[1,1,1,6-sel_pp_in]);
    cc_Th_sel(:,:,:,1:sel_pp_in-1)=repmat(mm_Th,[1,1,1,sel_pp_in-1]);
    cc_Th_sel(:,:,:,sel_pp_in:5)=repmat(cc_Th,[1,1,1,6-sel_pp_in]);
    %%counter4
    sel_pp_in=find(order_in_to==4);
    cc_pi_h_sel(:,:,:,1:sel_pp_in-1)=repmat(dd_pi_h,[1,1,1,sel_pp_in-1]);
    cc_pi_h_sel(:,:,:,sel_pp_in:5)=repmat(cc_pi_h,[1,1,1,6-sel_pp_in]);
    %%counter5
    cc_z_resi_sel(:,:,:,1:4)=repmat(z_resi,[1,1,1,4]);
    cc_z_resi_sel(:,:,:,5)=repmat(cc_z_resi,[1,1,1,1]);
    run counterfactuals.m
    %%counterfactual stats
    run temp_stats.m  
    %%save outcomes
    ss_cc_prob(:,:,zz)=cc_prob;
    ss_cc_prob_e(:,:,:,zz)=cc_prob_e;
    ss_cc_prob_g(:,:,:,zz)=cc_prob_g;
    ss_cc_prob_a(:,:,:,zz)=cc_prob_a;
    ss_cc_skp(:,:,zz)=cc_skp;
    ss_cc_gwg(:,:,zz)=cc_gwg;
    ss_cc_ag(:,:,zz)=cc_ag;
    ss_cc_op(:,:,zz)=cc_op;
    ss_cc_op_main(:,:,zz)=cc_op_main;
    ss_eqm_conv(:,:,zz)=eqm_conv;
end
save model_counter.mat