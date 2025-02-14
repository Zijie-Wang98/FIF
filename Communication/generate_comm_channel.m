target_list = [
    10,10;
    -10,-42;
    -15,28;
    30,-10;
];

%%%%%%%%% calculate rate from 1st Tx to 1st target

for l = 1:size(target_list,1)
    if l == 1
        phi(l) = acos(dot(Txlist(1).location-target_list(1,:),[0 1])/vecnorm(Txlist(1).location-target_list(1,:)));
    else
        phi(l) = acos(dot(target_list(l,:)-target_list(1,:),[0 1])/vecnorm(target_list(l,:)-target_list(1,:)));
    end
    distance = vecnorm(Txlist(1).location-target_list(l,:))+vecnorm(target_list(l,:)-target_list(1,:));
    h02_dB = -r0_dB-L0_dB-10*gamma0*log10(distance)+sigma_shadow/2*(randn + 1i * randn);
    h(l) = sqrt(10^(h02_dB/10));
    tau(l) = distance/c;
    a_l(:, l) = exp(1j*2*pi*0.5*(0:Mt-1)*sin(phi(l)))';
end

channel_gain = calculate_comm_channel_gain_per_subcarrier(size(target_list,1),h,tau,a_l);

power_dBm = -10:1:20;
power = power_dBm-30;
Pt_list = 10.^(power/10);

rate = zeros(1,length(Pt_list));

Mod_order = 4^5;
cd ..
x = (0:Mod_order-1)';
y = qammod(x,Mod_order,'UnitAveragePower',true);
[unique_magnitudes, frequencies] = computeMagnitudesAndFrequencies(y);
mean_magnitude(m) = sum(frequencies.*unique_magnitudes,1);
cd Communication/;

for p = 1:length(Pt_list)
    for k = 1:K
        rate(p) = rate(p)+Df*sum(frequencies.*log2(1+channel_gain(k)*unique_magnitudes.^2*Pt_list(p)/(noise_density*Df)))*log2(Mod_order);
    end
end

rate = rate*Tcp/To;

plot(power_dBm,rate)