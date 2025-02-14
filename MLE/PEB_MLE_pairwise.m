clc,clear all
run("../Network_setup/Setup/Network_setup.m");
run("../parameter_settings.m");

target = target_list(1,:);

Pt_dBm_list = -53:1.5:10;                 % dBm
Pt_list = 10.^(Pt_dBm_list/10)*1e-3;    % power in W

iter = 4000;
MLE_error = zeros(1,length(Pt_list));
range_error = zeros(1,length(Pt_list));
ang_error = zeros(1,length(Pt_list));

Tx_index = 1;
Rx_index = 1;

Dt = vecnorm(Txlist(Tx_index).location-target);
Dr = vecnorm(Txlist(Rx_index).location-target);
distance = Dt+Dr;

dh = -target(1)+Rxlist(Rx_index).location(1);
dv = target(2)-Rxlist(Rx_index).location(2);
phi = asin(dh/Dr);
phi_deg = rad2deg(phi);
if dh>=0
    if dv<=0
        phi_deg = 180-phi_deg;
    end
else
    if dv<=0
        phi_deg = -180-phi_deg;
    end
end

g02_dB = -r0_dB-L0_dB-10*gamma0*log10(distance);    %%% path-lossD
g = sqrt(10^(g02_dB/10));                           %%% signal-amplitude loss
SNR_dB = 10*log10(Pt_list*Ak^2/Pt*g^2/(Nf*noise_var));
SNR_dB_show = 10*log10(Pt_list*Ak^2/Pt*g^2/(noise_var));
SNR = 10.^(SNR_dB/10);

for p = 1:length(Pt_list)
    p
    for l = 1:iter
        fi = fc+(Tx_index-0.5-0.5*length(Txlist))*BW;
        [dis_est,ang_est,pos_est] = MLE_localization(fi,Txlist(Tx_index).location,Rxlist(Rx_index).location,target,Pt_list(p),SNR(p));
        ang_error(p) = ang_error(p)+(ang_est-phi_deg)^2;
        range_error(p) = range_error(p)+(dis_est-distance)^2;
        MLE_error(p) = MLE_error(p)+vecnorm(pos_est-target)^2;
    end
end

MLE_error = MLE_error/iter;
ang_error = ang_error/iter;
range_error = range_error/iter;
cd ../CRB_calculation;

[J,Tij,J_theta] = FIM_calculation(length(Txlist),Tx_index,Txlist(Tx_index),Rxlist(Rx_index),target);
iJ = inv(J(1:2,1:2));   %%%
iJ_theta = inv(J_theta(1:2,1:2));   %%%

SPEB = (Pt_list/Pt).^(-1)*trace(iJ(1:2,1:2));
range_CRB = (Pt_list/Pt).^(-1)*iJ_theta(1,1);
angle_CRB = (Pt_list/Pt).^(-1)*(iJ_theta(2,2));

cd ../MLE;
save('MLE_data.mat');

figure
semilogy(SNR_dB,sqrt(MLE_error));
hold on
semilogy(SNR_dB,sqrt(SPEB));

figure
semilogy(SNR_dB,sqrt(ang_error));
hold on
semilogy(SNR_dB,rad2deg(sqrt(angle_CRB)));

figure
semilogy(SNR_dB,sqrt(range_error));
hold on
semilogy(SNR_dB,c*sqrt(range_CRB));