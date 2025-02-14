function [J,Tij,J_theta] = FIM_calculation(Nt,Tx_index_list,Txlist,Rxlist,target_list_input)
    Nr = length(Rxlist);
    L = size(target_list_input,1);
    J = zeros(2*L+2*(L+1)*length(Txlist)*Nr,2*L+2*(L+1)*length(Txlist)*Nr);
    run("../parameter_settings.m");
    
    for i = 1:length(Txlist)
        for j = 1:Nr
            for l = 1:L
                distance = (vecnorm(Txlist(i).location-target_list_input(l,:))+vecnorm(Rxlist(j).location-target_list_input(l,:)));
                tau(l) = distance/c;
                phi(l) = acos(dot(target_list_input(l,:)-Rxlist(j).location,[0 1])/vecnorm(target_list_input(l,:)-Rxlist(j).location));
                g02_dB = -r0_dB-L0_dB-10*gamma0*log10(distance)+sigma_shadow/2*(randn + 1i * randn);
                g(l) = sqrt(10^(g02_dB/10));
            end

            tau(L+1) = vecnorm(Txlist(i).location-Rxlist(j).location)/c;  %% tau^0

            if all(Txlist(i).location == Rxlist(j).location)
                phi(L+1) = 0;
                g(L+1) = g(L);
            else
                phi(L+1) = acos(dot(Txlist(i).location-Rxlist(j).location,[0 1])/vecnorm(Txlist(i).location-Rxlist(j).location));  %% phi^0;
                g02_dB = -r0_dB-L0_dB-10*gamma0*log10(tau(L+1)*c);
                g(L+1) = sqrt(10^(g02_dB/10));  %% g^0
            end

            fi = fc+(Tx_index_list(i)-0.5-0.5*Nt)*BW;
            J_theta = CRB_theta(fi,tau,phi,g);
            Tij = Jacobian(target_list_input,length(Txlist),Nr,i,j,Txlist(i).location,Rxlist(j).location,phi);
            J = J+transpose(Tij)*J_theta*Tij;
        end
    end
end