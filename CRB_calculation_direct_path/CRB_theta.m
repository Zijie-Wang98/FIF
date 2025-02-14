% input phi and tau according to definations in paper

function J = CRB_theta(fi,tau,phi,g)
    run("../parameter_settings.m");
    
    lambda_i = c/fi;

    L = length(tau)-1;

    mat = zeros(4*(L+1),M);
    J_tmp = zeros(4*(L+1),4*(L+1));
    for k = 0:K-1
        for l=1:L+1
            a_vec = transpose(exp(1j*2*pi*(0:(M-1))*d/lambda_i*sin(phi(l))));
            Y_bar = Ak*g(l)*exp(-1j*2*pi*k*Df*tau(l))*(a_vec);
            tmp = [ (-1j*2*pi*k*Df*Y_bar)';
                Ak*(g(l)*exp(-1j*2*pi*k*Df*tau(l))*(a_vec*1j*2*pi.*transpose(0:(M-1))*d/lambda_i*cos(phi(l))))';
                % (Ak*exp(-1j*2*pi*k*Df*tau(l))*a_vec)';
                % (1j*Ak*exp(-1j*2*pi*k*Df*tau(l))*a_vec)';]; %% estimate ima and real parts
                (Y_bar/g(l))';
                (1j*Y_bar)';];  %% estimage magnitude and phase
            % tmp is diff Y_bar^H / diff theta_l 
            mat(4*(l-1)+1:4*l,:) = tmp;
        end
        J_tmp = J_tmp+mat*mat';
    end
    J = [J_tmp(1:end-4,1:end-4),J_tmp(1:end-4,end-1:end);
        J_tmp(end-1:end,1:end-4),J_tmp(end-1:end,end-1:end);];
    J = 2/(Nf*noise_var)*real(J);
end