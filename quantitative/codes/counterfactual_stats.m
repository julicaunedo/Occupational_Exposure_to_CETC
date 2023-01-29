%% Loading
load model_counter.mat

%% Averaging across counterfactuals
tol=1.0e-04;
ii=find(max(ss_eqm_conv(:,2,:),[],1)>tol);
for i=1:numel(ii)
   ij=find(ss_eqm_conv(:,2,ii(i))>tol);
   ss_cc_prob(:,min(ij)+1:max(ij)+2,ii(i))=nan;
   ss_cc_prob_e(:,min(ij)+1:max(ij)+2,:,ii(i))=nan;
   ss_cc_prob_g(:,min(ij)+1:max(ij)+2,:,ii(i))=nan;
   ss_cc_prob_a(:,min(ij)+1:max(ij)+2,:,ii(i))=nan;
   ss_cc_skp(:,min(ij)+1:max(ij)+2,ii(i))=nan;
   ss_cc_gwg(:,min(ij)+1:max(ij)+2,ii(i))=nan;
   ss_cc_ag(:,min(ij)+1:max(ij)+2,ii(i))=nan;
   ss_cc_op(:,min(ij)+1:max(ij)+2,ii(i))=nan;
   ss_cc_op_main(:,min(ij)+1:max(ij)+2,ii(i))=nan;  
   ss_seq_pol(:,ij,ii(i))=nan; 
end
if altx==1 | model_me==1
    ncounter=1;
else
    ncounter=5;
end
for i=1:ncounter 
    for j=1:size(order_in,1)
        if i<5
            ii=find(order_in(j,:)==i);
        else 
            ii=5;
        end
        temp_prob(:,j,i)=ss_cc_prob(:,ii+1,j);
        temp_probe(:,j,:,i)=ss_cc_prob_e(:,ii+1,:,j);
        temp_probg(:,j,:,i)=ss_cc_prob_g(:,ii+1,:,j);
        temp_proba(:,j,:,i)=ss_cc_prob_a(:,ii+1,:,j);
        temp_skp(:,j,i)=ss_cc_skp(:,ii+1,j);
        temp_gwg(:,j,i)=ss_cc_gwg(:,ii+1,j);
        temp_ag(:,j,i)=ss_cc_ag(:,ii+1,j);
        temp_op(:,j,i)=ss_cc_op(:,ii+1,j);
        temp_op_main(:,j,i)=ss_cc_op_main(:,ii+1,j);
    end   
end
av_ss_cc_prob=permute(nanmean(temp_prob,2),[1,3,2]);
av_ss_cc_prob_e=permute(nanmean(temp_probe,2),[1,3,4,2]);
av_ss_cc_prob_g=permute(nanmean(temp_probg,2),[1,3,4,2]);
av_ss_cc_prob_a=permute(nanmean(temp_proba,2),[1,3,4,2]);
av_ss_cc_skp=permute(nanmean(temp_skp,2),[1,3,2]);
av_ss_cc_gwg=permute(nanmean(temp_gwg,2),[1,3,2]);
av_ss_cc_ag=permute(nanmean(temp_ag,2),[1,3,2]);
av_ss_cc_op=permute(nanmean(temp_op,2),[1,3,2]);
av_ss_cc_op_main=permute(nanmean(temp_op_main,2),[1,3,2]);

%% Outcomes
out=[ss_cc_prob(:,1,1),av_ss_cc_prob]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','b6','WriteVariableNames',false)
if strcmp(sheet_name_mult,'baseline')==1
    all_emp=out;
    save data_for_counter_figures.mat all_emp
end
ii=1;
out=[ss_cc_prob_e(:,1,ii,1),permute(av_ss_cc_prob_e(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','h6','WriteVariableNames',false)
ii=2;
out=[ss_cc_prob_e(:,1,ii,1),permute(av_ss_cc_prob_e(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','n6','WriteVariableNames',false)
ii=1;
out=[ss_cc_prob_g(:,1,ii,1),permute(av_ss_cc_prob_g(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','t6','WriteVariableNames',false)
ii=2;
out=[ss_cc_prob_g(:,1,ii,1),permute(av_ss_cc_prob_g(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','z6','WriteVariableNames',false)
ii=1;
out=[ss_cc_prob_a(:,1,ii,1),permute(av_ss_cc_prob_a(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','af6','WriteVariableNames',false)
ii=2;
out=[ss_cc_prob_a(:,1,ii,1),permute(av_ss_cc_prob_a(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','al6','WriteVariableNames',false)
ii=3;
out=[ss_cc_prob_a(:,1,ii,1),permute(av_ss_cc_prob_a(:,ii,:),[1,3,2])]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','ar6','WriteVariableNames',false)
out=[ss_cc_op(:,1,1),av_ss_cc_op]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','b38','WriteVariableNames',false)
out=[ss_cc_op_main(:,1,1),av_ss_cc_op_main]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','b48','WriteVariableNames',false)
out=[ss_cc_skp(:,1,1),av_ss_cc_skp]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','k38','WriteVariableNames',false)
out=[ss_cc_gwg(:,1,1),av_ss_cc_gwg]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','k39','WriteVariableNames',false)
out=[ss_cc_ag(:,1,1),av_ss_cc_ag]*100;
T=table(out);
writetable(T,filename_mult,'Sheet',sheet_name_mult,'Range','k40','WriteVariableNames',false)



