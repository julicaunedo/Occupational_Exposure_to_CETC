%% Loading
file_pcpk='../../empirics/modeldata/CETC_bycapitaltype.xlsx';
file_pkocc='../../empirics/modeldata/CETCstocks_byocc.xlsx';
file_main='../../empirics/modeldata/empstocks_byocc.xlsx';
%%employment and capital by occupation and type
for j=1:size(c_years,2)
    [out2] = xlsread(file_main,num2str(c_years(j)),'a2:cd121');     
    %%redefine the order of info so that we have gender, education, age,
    %%occupation
    out2(:,[1,2,3,4])=out2(:,[2,3,4,1]);    
    %%redefine the number of occupations so that we go from 1 to 9
    temp=out2(:,4);
    temp(temp==8)=7;temp(temp==10)=8;temp(temp==11)=9;
    out2(:,4)=temp;
    temp_data_census_age.(strcat('y',num2str(c_years(j))))=out2(:,5:size(out2,2));
    temp_info_census_age.(strcat('y',num2str(c_years(j))))=out2(:,[1,2,4,3]);
end
%%usercost by equipment and consumption price
[data_pi_k_usercost,trash] = xlsread(file_pcpk,'usercost','a2:c1439');  
year_pi=[1959:1:2016];
[data_pc,trash] = xlsread(file_pcpk,'pc','b25:b62'); 
year_pc=[1982:1:2019];
%%usercost and capital stock by occupation
[data_stock_occ_1,trash] = xlsread(file_pkocc,'Stock','a2:c385'); 
[data_usercost_occ_1,trash] = xlsread(file_pkocc,'Pk','a2:c385'); 
%%instrument for the estimation of rho
[data_price_occ_1983,trash] = xlsread(file_pkocc,'Instrument','a2:c385'); 

%% Re-organize the data 
%%usercost by equipment and consumption price
temp=ismember(year_pi,c_years);
indexes_pi = find(temp);
hhelp=unique(data_pi_k_usercost(:,1));
for i=1:numel(hhelp)
    for j=1:numel(year_pi)
        indexin=find(data_pi_k_usercost(:,1)==hhelp(i) & data_pi_k_usercost(:,2)==year_pi(j));
        data_pi_s(i,j)=data_pi_k_usercost(indexin,3);
    end
end
data_pi_s=data_pi_s([[1:1:22],24,23],:);
data_pi_s=data_pi_s(:,indexes_pi);
temp=ismember(year_pc,c_years-1);
indexes_pc = find(temp);
data_pc_s=data_pc(indexes_pc)';
data_pi_s=data_pi_s.*repmat(data_pc_s,[size(data_pi_s,1),1]).^(-1);
%%stock by occupation
nn_o=numel(unique(data_stock_occ_1(:,2)))-2;
data_data_stock_occ=unique(data_stock_occ_1(:,2));year_data_stock_occ=unique(data_stock_occ_1(:,1));
for j=1:numel(year_data_stock_occ)
    for i=1:numel(data_data_stock_occ)
        iih=find(data_stock_occ_1(:,2)==data_data_stock_occ(i) & ...
            data_stock_occ_1(:,1)==year_data_stock_occ(j));
       data_stock_occ(i,j)=data_stock_occ_1(iih,3);
    end
end
data_stock_occ([7,9],:)=[];
temp=ismember(year_data_stock_occ,c_years);
indexes_pi_occ = find(temp);
data_stock_occ=data_stock_occ(:,indexes_pi_occ);
%%usercost by occupation 
data_data_price_occ=unique(data_usercost_occ_1(:,1));year_data_price_occ=unique(data_usercost_occ_1(:,2));
for j=1:numel(year_data_price_occ)
    for i=1:numel(data_data_price_occ)
        iih=find(data_usercost_occ_1(:,1)==data_data_price_occ(i) & ...
            data_usercost_occ_1(:,2)==year_data_price_occ(j));
       data_usercost_occ(i,j)=data_usercost_occ_1(iih,3);
    end
end
data_usercost_occ([7,9],:)=[];
data_usercost_occ=data_usercost_occ(:,indexes_pi_occ);
%%instrument for the estimation of rho
data_data_price_occ=unique(data_price_occ_1983(:,2));year_data_price_occ=unique(data_price_occ_1983(:,1));
for j=1:numel(year_data_price_occ)
    for i=1:numel(data_data_price_occ)
        iih=find(data_price_occ_1983(:,2)==data_data_price_occ(i) & ...
            data_price_occ_1983(:,1)==year_data_price_occ(j));
       instrument(i,j)=data_price_occ_1983(iih,3);
    end
end
instrument([7,9],:)=[];
instrument=instrument(:,indexes_pi_occ);
instrument_lev(:,1)=data_usercost_occ(:,1);
for j=1:(numel(indexes_pi_occ)-1)
    for i=1:(numel(data_data_price_occ)-2)
        instrument_lev(i,j+1)=instrument_lev(i,j).*(exp(1)).^(instrument(i,j+1));
    end
end
%%employment and capital by occupation and type to have matrices (o,demographics,data)
list_o=[1:1:nn_o]; %%occupation
list_k=[1:1:size(data_pi_s,1)]; %%equipment categories
list_s=[0:1:1]; %%schooling
list_a=[1:1:3]; %%age
list_g=[0:1:1]; %%gender
aa_g=[zeros(numel(list_a)*numel(list_g),1);ones(numel(list_a)*numel(list_g),1)];
aa_e=[zeros(numel(list_a),1);ones(numel(list_a),1)];
aa_o=[ones(numel(list_a)*numel(list_g)*numel(list_s),1);
    2*ones(numel(list_a)*numel(list_g)*numel(list_s),1);3*ones(numel(list_a)*numel(list_g)*numel(list_s),1);...
    4*ones(numel(list_a)*numel(list_g)*numel(list_s),1);5*ones(numel(list_a)*numel(list_g)*numel(list_s),1);...
    6*ones(numel(list_a)*numel(list_g)*numel(list_s),1);7*ones(numel(list_a)*numel(list_g)*numel(list_s),1);...
    8*ones(numel(list_a)*numel(list_g)*numel(list_s),1);9*ones(numel(list_a)*numel(list_g)*numel(list_s),1)];
aa_a=[1:1:3]';
tot_g_age=[repmat(aa_g,[numel(list_o),1]),repmat(aa_e,[numel(list_o).*numel(list_g),1]),...
    aa_o,repmat(aa_a,[numel(list_o).*numel(list_g).*numel(list_s),1])];
for j=1:size(c_years,2)
    for u=1:size(tot_g_age,1)
        g_info=tot_g_age(u,1);e_info=tot_g_age(u,2);o_info=tot_g_age(u,3);a_info=tot_g_age(u,4);    
       ii_age=find(temp_info_census_age.(strcat('y',num2str(c_years(j))))(:,1)==g_info & ...
           temp_info_census_age.(strcat('y',num2str(c_years(j))))(:,2)==e_info & ...
           temp_info_census_age.(strcat('y',num2str(c_years(j))))(:,3)==o_info & ...
           temp_info_census_age.(strcat('y',num2str(c_years(j))))(:,4)==a_info);
       if isempty(ii_age)==1
           data_census_age.(strcat('y',num2str(c_years(j))))(u,:)=zeros(1,size(temp_data_census_age.y2016,2));
       else
           sel_age=temp_data_census_age.(strcat('y',num2str(c_years(j))))(ii_age,:);
           data_census_age.(strcat('y',num2str(c_years(j))))(u,:)=sel_age;
       end
       info_census_age.(strcat('y',num2str(c_years(j))))(u,:)=tot_g_age(u,:);
    end    
end
for i=1:numel(list_o)
        var_o=list_o(i);
     for j=1:size(c_years,2)         
           ii_age=find(info_census_age.(strcat('y',num2str(c_years(j))))(:,3)==var_o);
           sel_age=data_census_age.(strcat('y',num2str(c_years(j))))(ii_age,:);
           rdata_census_age.(strcat('y',num2str(c_years(j))))(i,:,:)=permute(sel_age,[3,1,2]);                
    end
end
for j=1:size(c_years,2)
    y_list{j,1}=strcat('y',num2str(c_years(j)));
end
%%identifiers of demographic characteristics
var_o=list_o(1);
for x=1:numel(list_s)
    var_s=list_s(x);
    for p=1:numel(list_g)
        var_g=list_g(p);
        for q=1:numel(list_a)
            var_a=list_a(q);
            ii=find(info_census_age.(strcat('y',num2str(c_years(1))))(:,1)==var_g & ...
                info_census_age.(strcat('y',num2str(c_years(1))))(:,2)==var_s & ...
                info_census_age.(strcat('y',num2str(c_years(1))))(:,3)==var_o & ...
                info_census_age.(strcat('y',num2str(c_years(1))))(:,4)==var_a);
                ident(x,p,q)=ii;
        end
    end
end