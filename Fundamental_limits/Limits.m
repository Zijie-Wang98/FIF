run("../Network_setup/Setup/Network_setup.m");
run("../parameter_settings.m");
close all

Tx_index_list = 1:length(Txlist);

power_dBm = -10:1:20;
power = power_dBm-30;
Pt_list = 10.^(power/10);

SPEB_1 = zeros(1,size(target_list,1));
SPEB = zeros(1,size(target_list,1));
FIF = zeros(1,size(target_list,1));
rate_target = zeros(size(target_list,1),length(power_dBm));
%%%%%%%%%%%%%%%%% 
%%% effects of number of target
%%%%%%%%%%%%%%%%% 

power_dBm = -10:1:20;
power = power_dBm-30;
Pt_list = 10.^(power/10);

for t = 1:size(target_list,1)
    cd ../CRB_calculation_direct_path/
    [J,Tij,J_theta]  = FIM_calculation(length(Txlist),Tx_index_list,Txlist(Tx_index_list),Rxlist,target_list(1:t,:));
    iJ = inv(J);
    SPEB_1(t) = trace(iJ(1:2,1:2));
    SPEB(t) = trace(iJ(1:2*t,1:2*t));
    [FIF_theoretical,FIF_contribution,SPEB_pairwise] = calculate_FIF_theoretical(Txlist,Rxlist,target_list(1:t,:));  %%% 多目标情况下第一个目标的FIF计算
    FIF(t) = FIF_theoretical;
    cd ../Communication/
    rate_target(t,:) = get_rate(target_list(1:t,:),Txlist,power_dBm,16);
end
cd ../Fundamental_limits/

%%%%%%%%%%%%%%%%% 
%%% effects of mod order
%%%%%%%%%%%%%%%%% 

P_dBm_for_mod = [5 10 15];  %% three curves corresponding
Mod_order_list = 4.^(1:6);
%Mod_order_list = 2.^(2:10);
rate_mod = zeros(length(Mod_order_list),length(P_dBm_for_mod));
epsilon = zeros(1,length(Mod_order_list));

for m = 1:length(Mod_order_list)
    cd ../Communication/
    rate_mod(m,:) = get_rate(target_list,Txlist,P_dBm_for_mod,Mod_order_list(m));
    cd ..
    x = (0:Mod_order_list(m)-1)';
    y = qammod(x,Mod_order_list(m),'UnitAveragePower',true);
    [unique_magnitudes, frequencies] = computeMagnitudesAndFrequencies(y);
    epsilon(m) = sum(frequencies.*unique_magnitudes,1);
    cd Fundamental_limits
end

save('main_data.mat');


% 
% Tx_index_list = 1:length(Txlist);
% [J,Tij,J_theta]  = FIM_calculation(length(Txlist),Tx_index_list,Txlist(Tx_index_list),Rxlist,target_list);
% 
% power_dBm = -10:1:20;
% power = power_dBm-30;
% Pt_list = 10.^(power/10);
% iJ = inv(J);
% SPEB = (Pt_list/Pt_list(power_dBm==10)).^(-1)*trace(iJ(1:2,1:2));
% 
% [FIF_theoretical,FIF_contribution] = calculate_FIF_theoretical(Txlist,Rxlist,target_list);
% SPEB1 = (Pt_list/Pt_list(power_dBm==10)).^(-1)*FIF_theoretical;
% 
% 
% figure
% semilogy(power_dBm,sqrt(SPEB))
% hold on
% semilogy(power_dBm,sqrt(SPEB1))
% 
% cd ../Fundamental_limits/