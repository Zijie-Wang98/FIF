%%% MLE for SINGLE target localization
%%% Due to accuracy, noise_var should be normalized

function [dis_est,ang_est,pairwise_location_est] = MLE_localization(fi,Tx_location,Rx_location,tar_location,power_temp,SNR)
    run("../parameter_settings.m");   
    lambda_i = c/fi;
    Dt = vecnorm(Tx_location-tar_location);
    Dr = vecnorm(Rx_location-tar_location);
    distance = Dt+Dr;
    
    %g02_dB = -r0_dB-L0_dB-10*gamma0*log10(distance);   %%% path-loss
    %g = sqrt(10^(g02_dB/10));                          %%% signal amplitude loss
    
    dh = -tar_location(1)+Rx_location(1);
    dv = tar_location(2)-Rx_location(2);
    phi = asin(dh/Dr);
    
    noise = (0.5*randn(M,K)+0.5*1j*randn(M,K)); 
    Ak = Nf*symbol_magnitude*sqrt(power_temp)/sqrt(Nf*noise_var); %%% ???

    y_clean = zeros(M,K);
    for m=1:M
        for k=1:K
            y_clean(m,k) = sqrt(SNR)*exp(-1j*2*pi*(k-1)*Df*distance/c)*exp(1j*2*pi*(m-1)*d/lambda_i*sin(phi));
        end
    end
    y = y_clean+noise;

    Y = @(x) -abs(sum(y.*(transpose(exp(-1j*2*pi*(0:(M-1))*d/lambda_i*sin(x(2))))*exp(1j*2*pi*(0:(K-1))*Df*x(1)/c)),'all'))^2;
    
    options = optimoptions('fminunc', 'Display', 'off');
    est =  fminunc(Y,[distance;phi],options);
    ang_deg_est = wrapToPi(est(2));
    dis_est = abs(est(1));
    ang_est = rad2deg(ang_deg_est);
        
    if dh>=0
        if dv<=0
            ang_est = 180-ang_est;
        end
    else
        if dv<=0
            ang_est = -180-ang_est;
        end
    end
    
    syms xx yy
    e1 = -Rx_location(2)+yy-cosd(ang_est)*sqrt((xx-Rx_location(1))^2+(yy-Rx_location(2))^2);
    e2 = sqrt((xx-Rx_location(1))^2+(yy-Rx_location(2))^2)+sqrt((xx-Tx_location(1))^2+(yy-Tx_location(2))^2)-dis_est;
    
    [x_est,y_est]= vpasolve([e1,e2],[xx,yy],tar_location);
    pairwise_location_est = double([x_est,y_est]);
end