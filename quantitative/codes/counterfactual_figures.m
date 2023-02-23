%% Loading
load data_main.mat
filename_exp='tables_paper.xlsx';
load baseo.mat
load rho.mat
load theta_w.mat
load baseo.mat
load stats_data_for_model.mat
n_o=numel(list_o);
polfitd=2;

%% GE employment outcomes
load data_for_counter_figures.mat

%% Hicks employment outcomes
[temp] = readtable('../../empirics/modeldata/CETC_data.xlsx','Sheet','Sheet1');CECT_data=temp{:,:};CECT_data(:,1)=[];
CECT_data([7,9],:)=[];
%%capital share 
alpha=0.24; 
pi_o=permute(nansum(pi_o_gh.*(permute(pi_h,[3,1,2])),2),[1,3,2]);
wage_pay=pi_o.*wa_o.*repmat(tot_n,[n_o,1]);
capital_pay=data_stock_occ.*data_usercost_occ;
dd_exps=capital_pay.*(wage_pay).^(-1);
dd_rescale=nanmean(dd_exps(:)).^(-1).*alpha.*(1-alpha).^(-1);
dd_exps=dd_rescale.*dd_exps;
dd_alpha_o=dd_exps.*(dd_exps+1).^(-1);
%%CETC
dd_CETC=CECT_data;
dd_CETC=-dd_CETC;
e_sup=theta_w-1; 
e_short=elast_s_in; 
cap_share=dd_alpha_o;
exposure_all=(e_sup.*(rho-e_short).*cap_share).*...
    (rho+e_sup+(e_short-rho).*cap_share).^(-1);
exposure=exposure_all(:,1);
%%change in employment shares
temp=pi_o(:,1).*(1+exposure.*dd_CETC).^(2015-1984);
temp=temp-pi_o(:,1);
exp_lshares_ch=temp-sum(temp)/numel(temp);
exp_lshares_ch=exp_lshares_ch*100;
dd_lshares_ch=pi_o(:,5)-pi_o(:,1);
dd_lshares_ch=dd_lshares_ch*100;

%% Figures 
load occ_labels.mat
OR=[1,0.694,0.392];PI=[1,0.4,0.6];AZ=[0.2,0.6,1.0];font=18;ls=15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure 51
ifig=51;
xx=[1:1:n_o]; yy=exp_lshares_ch;yy1=dd_lshares_ch;
yy=yy(in_w1980);
yy1=yy1(in_w1980);
p_l = polyfit(xx',yy,2);
y_l = polyval(p_l,xx');
p_l1 = polyfit(xx',yy1,2);
y_l1 = polyval(p_l1,xx');
h=figure(ifig);
yyaxis left
hold on
scatter(xx,yy,100,'w')
text(xx,yy,oc_code,'Fontsize',ls,'color','r')
plot(xx,y_l,'LineWidth',3,'color','r','linestyle','--')
ylabel('Predicted employment change','FontName','Times New Roman','fontsize',font,'color','r')        
set(gca,'ycolor','r')
set(gca,'FontSize',font)
yyaxis right
hold on
scatter(xx,yy1,100,'w')
text(xx,yy1,oc_code,'Fontsize',ls,'color','k')
plot(xx,y_l1,'LineWidth',3,'color','k','linestyle','--')
ylabel('Employment change','FontName','Times New Roman','fontsize',font,'color','k')        
set(gca,'xTick',[1:1:n_o],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'ycolor','k')
set(gca,'FontSize',font)
print(h,'-dpdf','../results/51');
print(h,'-depsc','../results/51');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure 52
ifig=52;
xx=[1:1:n_o]; yy1=all_emp(:,1);yy=all_emp(:,2);yy=yy(in_w1980);yy1=yy1(in_w1980);
p_l = polyfit(xx',yy,2);
y_l = polyval(p_l,xx');
p_l1 = polyfit(xx',yy1,2);
y_l1 = polyval(p_l1,xx');
h=figure(ifig);
hold on
scatter(xx,yy1,100,'w','HandleVisibility','off')
text(xx,yy1,oc_code,'Fontsize',ls,'color','k','HandleVisibility','off')
plot(xx,y_l1,'LineWidth',3,'color','k','linestyle','--')
scatter(xx,yy,100,'w','HandleVisibility','off')
text(xx,yy,oc_code,'Fontsize',ls,'color','r','HandleVisibility','off')
plot(xx,y_l,'LineWidth',3,'color','r','linestyle','-.')
ylabel('Employment change','FontName','Times New Roman','fontsize',font)        
set(gca,'xTick',[1:1:n_o],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
legend('data & model','CETC','Location','southeast','edgecolor','none')
xlim([0.5,10.5])
hline = refline(0, 0);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
print(h,'-dpdf','../results/52');
print(h,'-depsc','../results/52');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure 6.1
ifig=61;
xx=[1:1:n_o]; yy1=all_emp(:,1);yy=all_emp(:,3);yy=yy(in_w1980);yy1=yy1(in_w1980);
p_l = polyfit(xx',yy,polfitd+2);
y_l = polyval(p_l,xx');
p_l1 = polyfit(xx',yy1,polfitd+2);
y_l1 = polyval(p_l1,xx');
h=figure(ifig);
hold on
scatter(xx,yy1,100,'w','HandleVisibility','off')
text(xx,yy1,oc_code,'Fontsize',ls,'color','k','HandleVisibility','off')
plot(xx,y_l1,'LineWidth',3,'color','k','linestyle','--')
scatter(xx,yy,100,'w','HandleVisibility','off')
text(xx,yy,oc_code,'Fontsize',ls,'color','b','HandleVisibility','off')
plot(xx,y_l,'LineWidth',3,'color','b','linestyle','-.')
ylabel('Employment change','FontName','Times New Roman','fontsize',font)        
set(gca,'xTick',[1:1:n_o],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
legend('data & model','demand','Location','southeast','edgecolor','none')
ylim([-10,10])
xlim([0.5,10.5])
hline = refline(0, 0);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
print(h,'-dpdf','../results/61');
print(h,'-depsc','../results/61');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure 62
ifig=62;
xx=[1:1:n_o]; yy1=all_emp(:,1);yy=all_emp(:,4);yy2=all_emp(:,5);yy3=all_emp(:,6);
yy=yy(in_w1980);yy1=yy1(in_w1980);yy2=yy2(in_w1980);yy3=yy3(in_w1980);
p_l = polyfit(xx',yy,polfitd+2);
y_l = polyval(p_l,xx');
p_l1 = polyfit(xx',yy1,polfitd+2);
y_l1 = polyval(p_l1,xx');
p_l2 = polyfit(xx',yy2,polfitd+2);
y_l2 = polyval(p_l2,xx');
p_l3 = polyfit(xx',yy3,polfitd+2);
y_l3 = polyval(p_l3,xx');
h=figure(ifig);
hold on
plot(xx,y_l1,'LineWidth',3,'color','k','linestyle','-')
plot(xx,y_l,'LineWidth',3,'color',OR,'linestyle','--')
plot(xx,y_l2,'LineWidth',3,'color',PI,'linestyle','-.')
plot(xx,y_l3,'LineWidth',3,'color',AZ,'linestyle',':')
ylabel('Employment change','FontName','Times New Roman','fontsize',font)        
set(gca,'xTick',[1:1:n_o],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
ylim([-10,10])
xlim([0.5,10.5])
legend('data & model','demographics','composition','comparative advantage','Location','northwest','edgecolor','none','NumColumns',2)
hline = refline(0, 0);
hline.Color = 'k';
hline.LineWidth=2; 
hline.LineStyle=':'; 
hline.HandleVisibility='off';
print(h,'-dpdf','../results/62');
print(h,'-depsc','../results/62');