%% Loading
load stats_data_for_model.mat
load data_main_yby.mat
load data_info_yby.mat
load model_calib.mat

%% Predicted CETC
%%prediction period
y_bb=2006; %%first prediction year
ii_y_bb=find(c_years==y_bb);
ii_y_initial=ii_y_bb-10;ii_selt=[ii_y_initial:1:numel(c_years)];
pred_years=c_years(ii_y_bb+1:numel(c_years));ii_pred_years=[ii_y_bb+1:numel(c_years)];
%%predicted CETC
pp_lambda_j=mm_lambda_j;
pp_lambda_j_g=nanmean((mm_lambda_j(:,:,ii_y_initial+1:ii_y_bb).*(mm_lambda_j(:,:,ii_y_initial:ii_y_bb-1)).^(-1))-1,3);
for i=ii_y_bb:(numel(c_years)-1)
    pp_lambda_j(:,:,i+1)=pp_lambda_j(:,:,i).*(1+pp_lambda_j_g);
end

%% Run the prediction
maxiter=10^6;
tol=10^(-4);
n_o=nn(1);n_y=nn(4);
pp_pi_oj_gh=repmat(mm_pi_oj_gh,[1,1,1,numel(ii_y_initial)]);
theta_w=para(1);
pp_wh_p=repmat(mm_wh_p,[1,1,numel(ii_y_initial)]);
pp_xtilda=repmat(mm_xtilda,[1,1,1,numel(ii_y_initial)]);
for j=1:numel(ii_pred_years)
    c_ysel=ii_pred_years(j);
    cc_lambda_j=repmat(pp_lambda_j(:,:,c_ysel),[1,1,n_y]);
    %%%%solve for the equilibrium
    %%min and max for the iterations on mm_lambda_o 
    help1=alpha_mat.^(-1.*(elast_s).^(-1));help1(ii_cd,:,:)=nan;
    scale=permute(help1(:,1,:),[1,3,2]); 
    factor=scale.*permute(cc_lambda_j,[1,3,2]);
    max_lj=permute(factor*1.01,[1,3,2]); min_lj=permute(factor*0.99,[1,3,2]);
    min_lo=max_lj;max_lo=10^30.*ones(size(min_lo)); 
    ii_osub=find(elast_s(:,1,1)>0);
    max_lo(ii_osub,:,:)=min_lj(ii_osub,:,:);min_lo(ii_osub,:,:)=10^(-30);
    min_lo(ii_cd,:,:)=10^(-30); min_lo_in=min_lo;max_lo_in=max_lo;
    %%initial guess mm_lambda_o
    mm_lambda_o_guess=mm_lambda_o;
    mm_lambda_o_guess(mm_lambda_o_guess<min_lo_in)=min_lo_in(mm_lambda_o_guess<min_lo_in);
    mm_lambda_o_guess(mm_lambda_o_guess>max_lo_in)=max_lo_in(mm_lambda_o_guess>max_lo_in); 
    t=ii_y_bb;
    [out1,out2]=solve_forlambdao(maxiter,para,mm_Th(:,t),mm_z(:,:,t),mm_omegas(:,:,t),elast_s(:,:,t),alpha_mat(:,:,t),ii_cd,cc_lambda_j(:,:,t),dd_pi_h(:,c_ysel),bb,nn,mm_lambda_o_guess(:,:,t),min_lo_in(:,:,c_ysel),max_lo_in(:,:,c_ysel));
    temp1(:,1,t)=out1;cc_lambda_o=mm_lambda_o;cc_lambda_o(:,:,ii_y_bb)=temp1(:,:,ii_y_bb);
    %%model stats
    cc_xtilda_j=compute_xtilda(cc_lambda_o,cc_lambda_j,alpha_mat,elast_s,nn,alpha_bar);
    [cc_xtilda_j]=corr_corner(cc_xtilda_j);
    num=(mm_z.*cc_xtilda_j).^theta_w;
    den=repmat(nansum(num,1),[n_o,1,1]);
    cc_pi_oj_gh_j=num.*(den).^(-1);
    Th_help=repmat(permute(mm_Th,[3,1,2]),[n_o,1,1]);
    cc_wh_p_j=(nansum(Th_help.*(mm_z.*cc_xtilda_j).^(theta_w),1)).^(1/theta_w).*gamma(1-1/theta_w);
    cc_wh_p_j=permute(cc_wh_p_j,[2,3,1]);
    %%save
    if out2<=tol
        pp_pi_oj_gh(:,:,ii_pred_years(j))=cc_pi_oj_gh_j(:,:,ii_y_bb);
         pp_wh_p(:,ii_pred_years(j))=cc_wh_p_j(:,ii_y_bb);
         pp_xtilda(:,:,ii_pred_years(j))=cc_xtilda_j(:,:,ii_y_bb);
    else
        pp_pi_oj_gh(:,:,ii_pred_years(j))=nan;
        pp_wh_p(:,ii_pred_years(j))=nan;
         pp_xtilda(:,:,ii_pred_years(j))=nan;
    end
end

%% Outcomes
%%occupational choice
mm_pi_oj=mm_pi_oj_gh.*repmat(permute(dd_pi_h,[3,1,2]),[n_o,1,1]);
pp_pi_h=dd_pi_h;pp_pi_oj=pp_pi_oj_gh.*repmat(permute(pp_pi_h,[3,1,2]),[n_o,1,1,size(pp_pi_oj_gh,4)]);
mm_pi_o=permute(sum(mm_pi_oj,2),[1,3,2]);
pp_pi_o=permute(sum(pp_pi_oj,2),[1,3,4,2]);
%%wages
ss_tpx=mm_pi_oj;ss_tpy=mm_wh_p;ss_tpx1=mm_wh_p;
group_id=2;list_in=list_g;nout=2;
[temp,temp_1]=mean_bylist(ss_tpx1,dd_pi_h,list_in,ident,nn,group_id);
mm_we_g=(temp_1(1,:).*temp_1(2,:).^(-1));
group_id=1;list_in=list_s;
[temp,temp_1]=mean_bylist(ss_tpx1,dd_pi_h,list_in,ident,nn,group_id);
mm_we_skp=(temp_1(2,:).*temp_1(1,:).^(-1));
group_id=3;list_in=list_a;
[temp,temp_1]=mean_bylist(ss_tpx1,dd_pi_h,list_in,ident,nn,group_id);
mm_we_age=(temp_1(2:3,:).*repmat(temp_1(1,:),[2,1]).^(-1));
ss_tpx=pp_pi_oj;ss_tpy=pp_wh_p;ss_tpx1=pp_wh_p;
group_id=2;list_in=list_g;
[temp,temp_1]=mean_bylist(ss_tpx1,pp_pi_h,list_in,ident,nn,group_id);
pp_we_g=(temp_1(1,:).*temp_1(2,:).^(-1));
group_id=1;list_in=list_s;
[temp,temp_1]=mean_bylist(ss_tpx1,pp_pi_h,list_in,ident,nn,group_id);
pp_we_skp=(temp_1(2,:).*temp_1(1,:).^(-1));
group_id=3;list_in=list_a;
[temp,temp_1]=mean_bylist(ss_tpx1,pp_pi_h,list_in,ident,nn,group_id);
pp_we_age=(temp_1(2:3,:).*repmat(temp_1(1,:),[2,1]).^(-1));

%% Figures
AZ=[0.2,0.6,1.0];OR=[1,0.694,0.392];BB=[0 0 1];RR=[1 0 0];CC_y=[RR;OR;BB];
font=18;ls=15;
load occ_labels.mat
%%%% Figure 7.1   
xx=[1:1:9]; 
tt=numel(c_years);
yy=(mm_pi_o(:,tt,1)-mm_pi_o(:,ii_y_bb,1))*100;
yy2=(pp_pi_o(:,tt)-pp_pi_o(:,ii_y_bb))*100;
yy=yy(in_w1980);
yy2=yy2(in_w1980);
p_l = polyfit(xx',yy,2);
y_l = polyval(p_l,xx');
p_l2 = polyfit(xx',yy2,2);
y_l2 = polyval(p_l2,xx');
ifig=71;
h=figure(ifig);
hold on
scatter(xx,yy,100,'w','HandleVisibility','off')
text(xx,yy,oc_code,'Fontsize',ls,'color','k','HandleVisibility','off')
scatter(xx,yy2,100,'w','HandleVisibility','off')
text(xx,yy2,oc_code,'Fontsize',ls,'color',AZ,'HandleVisibility','off')
ylabel('Employment change, 2005-2015','FontName','Times New Roman','fontsize',font)        
set(gca,'xTick',[1:1:9],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
xlim([0.5,10.5])
hline = refline(0, 0);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
print(h,'-dpdf','../results/71');
print(h,'-depsc','../results/71');
%%%% Figure 7.2   
xx=c_years(ii_selt); 
ifig=72;
h=figure(ifig);
hold on
plot(xx-1,mm_we_skp(1,ii_selt),'LineWidth',3,'linestyle','-','color',CC_y(3,:))
plot(xx-1,pp_we_skp(1,ii_selt),'LineWidth',3,'linestyle',':','color',CC_y(3,:),'HandleVisibility','off')
hline=xline(y_bb-1);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
ylabel('Skill premium','FontName','Times New Roman','fontsize',font) 
set(gca,'FontSize',font)
print(h,'-dpdf','../results/72');
print(h,'-depsc','../results/72');
%%%% Figure 7.3   
xx=c_years(ii_selt); 
ifig=73;
h=figure(ifig);
hold on
plot(xx-1,100-mm_we_g(1,ii_selt)*100,'LineWidth',3,'linestyle','-','color',CC_y(3,:))
plot(xx-1,100-pp_we_g(1,ii_selt)*100,'LineWidth',3,'linestyle',':','color',CC_y(3,:),'HandleVisibility','off')
hline=xline(y_bb-1);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
ylabel('Gender gap','FontName','Times New Roman','fontsize',font) 
set(gca,'FontSize',font)
print(h,'-dpdf','../results/73');
print(h,'-depsc','../results/73');
%%%% Figure 7.4   
xx=c_years(ii_selt); 
ifig=74;
h=figure(ifig);
hold on
for i=1:2
    plot(xx-1,mm_we_age(i,ii_selt),'LineWidth',3,'linestyle','-','color',CC_y(1+i,:))
    plot(xx-1,pp_we_age(i,ii_selt,1),'LineWidth',3,'linestyle',':','color',CC_y(1+i,:),'HandleVisibility','off')
end
hline=xline(y_bb-1);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
ylabel('Age premium','FontName','Times New Roman','fontsize',font) 
set(gca,'FontSize',font)
print(h,'-dpdf','../results/74');
print(h,'-depsc','../results/74');