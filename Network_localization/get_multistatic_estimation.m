function [pairwise_est,flag_map] = get_multistatic_estimation(Txlist,Rxlist,target)
    run('../parameter_settings.m');
    pairwise_est = cell(length(Txlist),length(Rxlist));
    distance = zeros(length(Txlist),length(Rxlist));
    cd ../MLE
    
    for i = 1:length(Txlist)
        for j = 1:length(Txlist)
            distance(i,j) = vecnorm(target-Txlist(i).location)+vecnorm(target-Rxlist(j).location);
            if distance(i,j)>distance_threshold
                continue;
            end
            g02_dB = -r0_dB-L0_dB-10*gamma0*log10(distance(i,j))+(randn+1j*randn)*sigma_shadow/2;    %%% path-lossD
            g = sqrt(10^(g02_dB/10));                                %%% signal-amplitude loss
            fi = fc+(i-0.5-0.5*length(Txlist))*BW;
            SNR = Pt*Ak^2*g^2/(Nf*noise_var);
            [~,~,pairwise_location_est] = MLE_localization(fi,Txlist(i).location,Rxlist(j).location,target,Pt,SNR);
            pairwise_est{i,j} = pairwise_location_est;
        end
    end

    cd ../Network_localization
    
    flag_map = distance<distance_threshold;
    for i = 1:length(Txlist)
        for j = 1:length(Txlist)
            if any([isnan(pairwise_est{i,j}),isempty(pairwise_est{i,j})])
                flag_map(i,j) = 0;
            end
        end
    end
end