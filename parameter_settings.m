c = 3e8; %speed of light
BW = 200e6;
fc = 28e9; % carrier frequency
lambda = c/fc;

M = 8;    %virtua larray antenna number

L0_dB = 31;
r0_dB = 10;
gamma0 = 3.69;
sigma_shadow = 1.42;  % shadowing effect of channel
d = c/(2*fc);

Pt_dBm = 10;
Pt_dBW = Pt_dBm-30;
Pt = 10^(Pt_dBW/10);
noise_floor_dBHz = -174;
NF = 7;
noise_density = 10^(noise_floor_dBHz/10)*1e-3*10^(NF/10);
noise_var = noise_density*BW;  % sensing noise variance
sen_sensitivity = -100;  % dBmW
distance_threshold = 10^((Pt_dBm-r0_dB-L0_dB-sen_sensitivity)/(10*gamma0));


K = 512;    %1024;
Nf = 32;
symbol_magnitude = 1/2+1/sqrt(5);   % 16-QAM
Ak = Nf*symbol_magnitude*sqrt(Pt);
Df = 240e3;

T = 1/Df;
Tcp = 1.2e-6/2;
To = T+Tcp;

target_list = [
    10,10;
    -10,-42;
    -15,28;
    30,-10;
];

Mt = 4;