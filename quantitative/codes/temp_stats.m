%% Loading
load model_calib.mat
load data_info.mat
load temp_counter.mat;

%% Eqm convergence (this could be eliminated)
eqm_conv=[cc_ddist_1(:,[1,n_y]);...
    cc_ddist_2(:,[1,n_y]);...
    cc_ddist_3(:,[1,n_y]);...
    cc_ddist_4(:,[1,n_y]);...
    cc_ddist_5(:,[1,n_y])];

%% Unconditional probabilities
dd_pi_oj=dd_pi_oj_gh.*repmat(permute(dd_pi_h,[3,1,2]),[n_o,1,1]);
mm_pi_oj=mm_pi_oj_gh.*repmat(permute(dd_pi_h,[3,1,2]),[n_o,1,1]);

%% Baseline
group_id=1; %%edu
ss_tpx=dd_pi_oj;ss_tpy=mm_wh_p; 
[mm_wo]=mean_wageo_bylist(ss_tpx,ss_tpy,[],ident,nn,group_id);
[mm_poe(:,:,3)]=mean_bylist_prob(ss_tpx,[],ident,nn,[],group_id);
[mm_poe(:,:,1:2)]=mean_bylist_prob(ss_tpx,list_s,ident,nn,[],group_id);
ss_tpx=mm_wh_p;ss_tpx_d=dd_wa_h;
[mm_we,mm_we_1]=mean_bylist(ss_tpx,dd_pi_h,list_s,ident,nn,group_id);
group_id=2; %%gender
ss_tpx=dd_pi_oj;ss_tpy=mm_wh_p; 
[mm_pog(:,:,1:2)]=mean_bylist_prob(ss_tpx,list_g,ident,nn,[],group_id);
ss_tpx=mm_wh_p;ss_tpx_d=dd_wa_h;
[mm_wg,mm_wg_1]=mean_bylist(ss_tpx,dd_pi_h,list_g,ident,nn,group_id);
group_id=3; %%age
ss_tpx=dd_pi_oj;ss_tpy=mm_wh_p; 
[mm_poa(:,:,1:3)]=mean_bylist_prob(ss_tpx,list_a,ident,nn,[],group_id);
ss_tpx=mm_wh_p;ss_tpx_d=dd_wa_h;
[mm_wa,mm_wa_1]=mean_bylist(ss_tpx,dd_pi_h,list_a,ident,nn,group_id);
comp_baseline=mm_poe(:,n_y,:)-mm_poe(:,1,:);
comp_baseline_g=mm_pog(:,n_y,:)-mm_pog(:,1,:);
comp_baseline_a=mm_poa(:,n_y,:)-mm_poa(:,1,:);
wo_baseline=mm_wo.*repmat(mm_wo(6,:),[9,1]).^(-1);
wo_baseline=wo_baseline(:,n_y)-wo_baseline(:,1);
wo_baseline_main=nan(3,size(mm_wo,2));
wo_baseline_main(1,:)=nansum(mm_wo([1,2,3],:).*mm_poe([1,2,3],:,3),1).*(nansum(mm_poe([1,2,3],:,3),1)).^(-1);
wo_baseline_main(2,:)=nansum(mm_wo([4,5,7,8,9],:).*mm_poe([4,5,7,8,9],:,3),1).*(nansum(mm_poe([4,5,7,8,9],:,3),1)).^(-1);
wo_baseline_main(3,:)=nansum(mm_wo([6],:).*mm_poe([6],:,3),1).*(nansum(mm_poe([6],:,3),1)).^(-1);
wo_baseline_main=wo_baseline_main.*repmat(wo_baseline_main(3,:),[3,1]).^(-1);
wo_baseline_main=wo_baseline_main(:,n_y)-wo_baseline_main(:,1);
po_baseline=permute(mm_xtilda(:,1,:),[1,3,2]);
po_baseline=log(po_baseline(:,:));%.*repmat(po_baseline(6,:),[9,1]).^(-1);
po_baseline=po_baseline(:,n_y)-po_baseline(:,1);
sk_baseline=mm_we_1(2,:).*mm_we_1(1,:).^(-1);
sk_baseline=sk_baseline(n_y)-sk_baseline(1);
gwg_baseline=mm_wg_1(2,:).*mm_wg_1(1,:).^(-1);
gwg_baseline=gwg_baseline(n_y)-gwg_baseline(1);
ag_baseline=mm_wa_1(2:3,:).*repmat(mm_wa_1(1,:),[2,1]).^(-1);
ag_baseline=ag_baseline(:,n_y)-ag_baseline(:,1);

%% Counterfactual outcomes
for j=1:5
    pp=j;dd_pi_h_in=cc_pi_h_sel(:,:,:,pp);
    eval(['cc_pi=',strcat('cc_pi_oj_gh_',num2str(j)),';']);
    eval(['cc_we_in=',strcat('cc_wh_p_',num2str(j)),';']);
    eval(['cc_xtilda_in=',strcat('cc_xtilda_',num2str(j)),';']);
    for i=1:size(cc_pi,4) 
        group_id=1; %%edu
        ss_tpx=cc_pi(:,:,:,i).*repmat(permute(dd_pi_h_in,[3,1,2]),[n_o,1,1]); 
        [sq_cc_poe(:,:,1:2,i)]=mean_bylist_prob(ss_tpx,list_s,ident,nn,[],group_id); 
        [sq_cc_poe(:,:,3,i)]=mean_bylist_prob(ss_tpx,[],ident,nn,[],group_id);
        ss_tpy=cc_we_in(:,:,i); 
        [sq_cc_wo(:,:,i)]=mean_wageo_bylist(ss_tpx,ss_tpy,[],ident,nn,group_id);
        ss_tpx=cc_we_in(:,:,i);
        [sq_cc_we(:,:,i),sq_cc_we_1(:,:,i)]=mean_bylist(ss_tpx,dd_pi_h_in,list_s,ident,nn,group_id);
        group_id=2; %%gender
        ss_tpx=cc_pi(:,:,:,i).*repmat(permute(dd_pi_h_in,[3,1,2]),[n_o,1,1]); 
        [sq_cc_pog(:,:,1:2,i)]=mean_bylist_prob(ss_tpx,list_g,ident,nn,[],group_id); 
        ss_tpx=cc_we_in(:,:,i);
        [sq_cc_wg(:,:,i),sq_cc_wg_1(:,:,i)]=mean_bylist(ss_tpx,dd_pi_h_in,list_g,ident,nn,group_id);
        group_id=3; %%age
        ss_tpx=cc_pi(:,:,:,i).*repmat(permute(dd_pi_h_in,[3,1,2]),[n_o,1,1]); 
        [sq_cc_poa(:,:,1:3,i)]=mean_bylist_prob(ss_tpx,list_a,ident,nn,[],group_id); 
        ss_tpx=cc_we_in(:,:,i);
        [sq_cc_wa(:,:,i),sq_cc_wa_1(:,:,i)]=mean_bylist(ss_tpx,dd_pi_h_in,list_a,ident,nn,group_id);
        sq_xtilda(:,:,i)=permute(cc_xtilda_in(:,1,:),[1,3,2]);
    end
    sq_cc_poe_in(:,:,:,1)=mm_poe;sq_cc_poe_in(:,:,:,2:size(sq_cc_poe,4)+1)=sq_cc_poe; 
    sq_cc_pog_in(:,:,:,1)=mm_pog;sq_cc_pog_in(:,:,:,2:size(sq_cc_pog,4)+1)=sq_cc_pog; 
    sq_cc_poa_in(:,:,:,1)=mm_poa;sq_cc_poa_in(:,:,:,2:size(sq_cc_poa,4)+1)=sq_cc_poa; 
    sq_cc_we_1_in(:,:,1)=mm_we_1;sq_cc_we_1_in(:,:,2:size(sq_cc_we_1,3)+1)=sq_cc_we_1; 
    sq_cc_wg_1_in(:,:,1)=mm_wg_1;sq_cc_wg_1_in(:,:,2:size(sq_cc_wg_1,3)+1)=sq_cc_wg_1; 
    sq_cc_wa_1_in(:,:,1)=mm_wa_1;sq_cc_wa_1_in(:,:,2:size(sq_cc_wa_1,3)+1)=sq_cc_wa_1; 
    sq_cc_wo_in(:,:,1)=mm_wo;sq_cc_wo_in(:,:,2:size(sq_cc_we_1,3)+1)=sq_cc_wo; 
    sq_xtilda_in(:,:,1)=permute(mm_xtilda(:,1,:),[1,3,2]);sq_xtilda_in(:,:,2:size(sq_xtilda,3)+1)=sq_xtilda; 
    summary_stats=permute(sq_cc_poe_in,[1,4,3,2]); 
    seq_comp(:,:,:,j)=[summary_stats(:,:,:,n_y),summary_stats(:,1,:,1)]; 
    summary_stats=permute(sq_cc_pog_in,[1,4,3,2]); 
    seq_compg(:,:,:,j)=[summary_stats(:,:,:,n_y),summary_stats(:,1,:,1)]; 
    summary_stats=permute(sq_cc_poa_in,[1,4,3,2]); 
    seq_compa(:,:,:,j)=[summary_stats(:,:,:,n_y),summary_stats(:,1,:,1)]; 
    summary_stats_w=permute(sq_cc_we_1_in,[1,3,2]); 
    summary_stats_w_r=summary_stats_w(2,:,:).*summary_stats_w(1,:,:).^(-1);
    seq_sk(:,:,j)=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    summary_stats_w=permute(sq_cc_wg_1_in,[1,3,2]); 
    summary_stats_w_r=summary_stats_w(2,:,:).*summary_stats_w(1,:,:).^(-1);
    seq_gwg(:,:,j)=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    summary_stats_w=permute(sq_cc_wa_1_in,[1,3,2]); 
    summary_stats_w_r=summary_stats_w(2:3,:,:).*repmat(summary_stats_w(1,:,:),[2,1,1]).^(-1);
    seq_ag(:,:,j)=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    summary_stats_w=permute(sq_cc_wo_in,[1,3,2]); 
    summary_stats_w_r=summary_stats_w(:,:,:).*repmat(summary_stats_w(6,:,:),[9,1,1]).^(-1);
    seq_summary_stats_w_ra=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    seq_wo(:,:,j)=seq_summary_stats_w_ra;   
    summary_stats=permute(sq_cc_poe_in(:,:,3,:),[1,4,2,3]);
    summary_stats_new=nan(3,size(summary_stats,2),size(summary_stats,3));
    summary_stats_new(1,:,:)=nansum(summary_stats(1:3,:,:).*summary_stats_w(1:3,:,:),1).*(nansum(summary_stats(1:3,:,:),1)).^(-1); %%high skill
    summary_stats_new(2,:,:)=nansum(summary_stats([4,5,7,8,9],:,:).*summary_stats_w([4,5,7,8,9],:,:),1).*(nansum(summary_stats([4,5,7,8,9],:,:),1)).^(-1); %%middle skill
    summary_stats_new(3,:,:)=nansum(summary_stats(6,:,:).*summary_stats_w(6,:,:),1).*(nansum(summary_stats(6,:,:),1)).^(-1); %%low skill
    summary_stats_w_r=summary_stats_new(:,:,:).*repmat(summary_stats_new(3,:,:),[3,1,1]).^(-1);
    seq_summary_stats_w_ra=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    seq_wo_main(:,:,j)=seq_summary_stats_w_ra;       
    summary_stats=permute(sq_xtilda_in,[1,3,2]);
    summary_stats_w_r=log(summary_stats(:,:,:));
    seq_summary_stats_w_ra=[summary_stats_w_r(:,:,n_y),summary_stats_w_r(:,1,1)];
    seq_po(:,:,j)=seq_summary_stats_w_ra;    
    seq_pol(:,j)=permute(cc_xtilda_in(:,1,n_y),[1,3,2]);
    seq_distl(:,j)=sq_cc_poe(:,n_y,3,1);
    clear sq_cc_poe sq_cc_wo sq_cc_we sq_cc_we_1 sq_cc_pog sq_cc_poa sq_cc_wg sq_cc_wg_1 sq_cc_wa sq_cc_wa_1
end

%% Output 
%%probabilities
for i=1:size(seq_comp,3)
    upp=[seq_comp(:,1:2,i,1),seq_comp(:,2,i,2),seq_comp(:,2,i,3),...
        seq_comp(:,2,i,4),seq_comp(:,2:3,i,5)];   
    upp(isnan(upp)==1)=0;
    if i<3
        cc_prob_e(:,:,i)=[comp_baseline(:,1,i),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
    else
        cc_prob=[comp_baseline(:,1,i),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
    end
    if i<3
        upp=[seq_compg(:,1:2,i,1),seq_compg(:,2,i,2),seq_compg(:,2,i,3),...
            seq_compg(:,2,i,4),seq_compg(:,2:3,i,5)];   
        upp(isnan(upp)==1)=0;   
        cc_prob_g(:,:,i)=[comp_baseline_g(:,1,i),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];    
    end
    upp=[seq_compa(:,1:2,i,1),seq_compa(:,2,i,2),seq_compa(:,2,i,3),...
        seq_compa(:,2,i,4),seq_compa(:,2:3,i,5)];   
    upp(isnan(upp)==1)=0;   
    cc_prob_a(:,:,i)=[comp_baseline_a(:,1,i),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
end
%%skill premium
upp=[seq_sk(:,1:2,1),seq_sk(:,2,2),seq_sk(:,2,3),...
    seq_sk(:,2,4),seq_sk(:,2:3,5)];   
upp(isnan(upp)==1)=0;
cc_skp=[sk_baseline(:,1),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
%%gender gap
upp=[seq_gwg(:,1:2,1),seq_gwg(:,2,2),seq_gwg(:,2,3),...
    seq_gwg(:,2,4),seq_gwg(:,2:3,5)];   
upp(isnan(upp)==1)=0;
cc_gwg=[gwg_baseline(:,1),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
%%age gap
upp=[seq_ag(:,1:2,1),seq_ag(:,2,2),seq_ag(:,2,3),...
    seq_ag(:,2,4),seq_ag(:,2:3,5)];   
upp(isnan(upp)==1)=0;
cc_ag=[ag_baseline(:,1),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
%%occupation premium
upp=[seq_wo(:,1:2,1),seq_wo(:,2,2),seq_wo(:,2,3),...
    seq_wo(:,2,4),seq_wo(:,2:3,5)];   
upp(isnan(upp)==1)=0;
cc_op=[wo_baseline(:,1),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];
upp=[seq_wo_main(:,1:2,1),seq_wo_main(:,2,2),seq_wo_main(:,2,3),...
    seq_wo_main(:,2,4),seq_wo_main(:,2:3,5)];   
upp(isnan(upp)==1)=0;
cc_op_main=[wo_baseline_main(:,1),upp(:,1:size(upp,2)-1,:)-upp(:,2:size(upp,2),:)];