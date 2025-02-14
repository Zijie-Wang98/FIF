run("../Network_setup/Setup/Network_setup.m");
run("../parameter_settings.m");

target_list = [
    10,10;
    %-10,-42;
    %-15,28;
];

for t=1:size(target_list,1)
    scatter(target_list(t,1),target_list(t,2));
    hold on
end

scale = 2*symbol_magnitude^2*Nf*K*M*Pt/noise_var;

Tx_index_list = 1:length(Txlist);

%[J,Tij,J_theta] = FIM_calculation(length(Txlist),Txlist(1),Rxlist(1),target_list);
[J,Tij,J_theta]  = FIM_calculation(length(Txlist),Tx_index_list,Txlist(Tx_index_list),Rxlist,target_list);


power_dBm = -10:1:20;
power = power_dBm-30;
Pt_list = 10.^(power/10);
iJ = inv(J);
SPEB = (Pt_list/Pt_list(power_dBm==10)).^(-1)*trace(iJ(1:2,1:2));

[FIF_theoretical,FIF_contribution] = calculate_FIF_theoretical(Txlist,Rxlist,target_list);
SPEB1 = (Pt_list/Pt_list(power_dBm==10)).^(-1)*FIF_theoretical;

figure
semilogy(power_dBm,sqrt(SPEB))
hold on
semilogy(power_dBm,sqrt(SPEB1))