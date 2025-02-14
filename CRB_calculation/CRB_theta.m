
% Tx_index = 1;
% Tx_num = 1;
% 
% 
% L = 4;
% tau = rand(1,L);
% phi = 2*pi*rand(1,L);
% g = rand(1,L);
% angle = rand(1,L); %% irrelavent


%fi = fc+(Tx_index-0.5-0.5*Nt)*BW;

function J = CRB_theta(fi,tau,phi,g)
    run("../parameter_settings.m");
    
    lambda_i = c/fi;

    L = length(tau);

    mat = zeros(4*L,M);
    J = zeros(4*L,4*L);
    for k = 0:K-1
        for l=1:L
            a_vec = transpose(exp(1j*2*pi*(0:(M-1))*d/lambda_i*sin(phi(l))));
            Y_bar = Ak*g(l)*exp(-1j*2*pi*k*Df*tau(l))*(a_vec);
            tmp = [ (-1j*2*pi*k*Df*Y_bar)';
                Ak*(g(l)*exp(-1j*2*pi*k*Df*tau(l))*(a_vec*1j*2*pi.*transpose(0:(M-1))*d/lambda_i*cos(phi(l))))';
                (Ak*exp(-1j*2*pi*k*Df*tau(l))*a_vec)';
                (1j*Ak*exp(-1j*2*pi*k*Df*tau(l))*a_vec)';]; %% estimate ima and real parts
                %(Y_bar/g(l))';
                %(1j*Y_bar)';];  %% estimage magnitude and phase
            % tmp is diff Y_bar^H / diff theta_l 
            mat(4*(l-1)+1:4*l,:) = tmp;
        end
        J = J+mat*mat';
    end
    J = 2/(Nf*noise_var)*real(J);
end