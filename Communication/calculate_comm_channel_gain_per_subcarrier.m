function [channel_gain] = calculate_comm_channel_gain_per_subcarrier(L,h_l,tau_l,a_l)
    run("../parameter_settings.m");
    % initialize channel matrix
    H = zeros(Mt, K); 
    for l = 1:L
        % frequency response for each path
        H = H + h_l(l) * a_l(:, l) * exp(-1i*2*pi*Df*tau_l(l)*(0:K-1));
    end
    channel_gain = zeros(1,K);
    for k = 1:K
    % channel gain for subcarrier k
    channel_gain(k) = sum(abs(H(:,k)).^2);
    end
end