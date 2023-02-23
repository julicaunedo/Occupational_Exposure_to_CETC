%% Loading
file_tool='../../empirics/modeldata/tool_shares.xlsx';
[temp] = readtable(file_tool,'Sheet','tool_share');count_all=temp{:,:};
count_all(:,1:2)=[];
count_dot=count_all([1:2:18],:);count_onet=count_all([2:2:18],:);
[temp] = readtable(file_tool,'Sheet','computer_use');computer_all=temp{:,:};
computer_all(:,1:2)=[];
computer_all_1984=computer_all([1:2:18],:);
computer_all_2003=computer_all([2:2:18],:);

%% Figures
load occ_labels.mat

PIALT=[1.00,0.00,1.00];
VIOL=[0.6,0.2,1];
DG=[0, 0.5, 0];
font=19;lw=3;
%%Figure BI, panel (a)
ifig=81;
xx=count_dot*100;  
yy=count_onet*100; 
xx=xx(in_w1980,:);
yy=yy(in_w1980,:);
h=figure(ifig);
hold on
i=1;b=bar([xx(:,i),yy(:,i)]);
b(1).FaceColor =PIALT;
b(2).FaceColor =VIOL;
ylim([0 50])
ylabel('computer tool share, % ','FontName','Times New Roman','fontsize',font)  
set(gca,'xTick',[1:1:9],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
print(h,'-dpdf','../results/B_I_1');
print(h,'-depsc','../results/B_I_1');
%%Figure BI, panel (b)
ifig=ifig+1;
xx=count_dot*100; 
yy=count_onet*100; 
xx=xx(in_w1980,:);
yy=yy(in_w1980,:);
h=figure(ifig);
hold on
i=2;b=bar([xx(:,i),yy(:,i)]);
b(1).FaceColor ='g';
b(2).FaceColor =DG;
ylim([0 50])
ylabel('communication tool share, % ','FontName','Times New Roman','fontsize',font)  
set(gca,'xTick',[1:1:9],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
print(h,'-dpdf','../results/B_I_2');
print(h,'-depsc','../results/B_I_2');
%%Figure BII panel (a)
ifig=91;
xx=computer_all_1984(:,1)*100; 
yy=computer_all_1984(:,2)*100; 
xx=xx(in_w1980,:);
yy=yy(in_w1980,:);
h=figure(ifig);
hold on
b=bar([xx,yy]);
b(1).FaceColor =PIALT;
b(2).FaceColor =VIOL;
ylim([0 50])
ylabel('share in 1984, % ','FontName','Times New Roman','fontsize',font)  
set(gca,'xTick',[1:1:9],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
print(h,'-dpdf','../results/B_II_1');
print(h,'-depsc','../results/B_II_1');
%%Figure BII panel (b)
ifig=ifig+1;
xx=computer_all_2003(:,1)*100; 
yy=computer_all_2003(:,2)*100; 
xx=xx(in_w1980,:);
yy=yy(in_w1980,:);
h=figure(ifig);
hold on
b=bar([xx,yy]);
b(1).FaceColor =PIALT;
b(2).FaceColor =VIOL;
ylim([0 50])
ylabel('share in 2003, % ','FontName','Times New Roman','fontsize',font)  
set(gca,'xTick',[1:1:9],'xTickLabel',occ_label_iso_w1980,'FontSize',font)
xtickangle(45)
set(gca,'FontSize',font)
print(h,'-dpdf','../results/B_II_2');
print(h,'-depsc','../results/B_II_2');
