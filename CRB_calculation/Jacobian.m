function T = Jacobian(target_list,Nt,Nr,Tx_index,Rx_index,Tx_loc,Rx_loc,phi)
        L = length(phi);
        c = 3e8;
    for l=1:L
        pl = target_list(l,:);
        tmp = [
        zeros(4,2*(l-1)), ...
        [dot((pl-Tx_loc),[1 0])/(c*vecnorm(pl-Tx_loc))+dot((pl-Rx_loc),[1 0])/(c*vecnorm(pl-Rx_loc)), dot((pl-Tx_loc),[0 1])/(c*vecnorm(pl-Tx_loc))+dot((pl-Rx_loc),[0 1])/(c*vecnorm(pl-Rx_loc));
        dot((pl-Rx_loc),[0 1])*dot((pl-Rx_loc),[1 0])/(sin(phi(l))*vecnorm(pl-Rx_loc)^3), dot((pl-Rx_loc),[1 0])^2/(-sin(phi(l))*vecnorm(pl-Rx_loc)^3);
        zeros(2,2)], ...
        [zeros(2,2*(L*Nt*Nr+L-l));
        zeros(2,((Tx_index-1)*Nr+(Rx_index-1))*2*L+2*(L-1)), eye(2), zeros(2,2*(L*Nt*Nr+L-l)-2-(((Tx_index-1)*Nr+(Rx_index-1))*2*L+2*(L-1)))]
        ];
        T(4*(l-1)+1:4*l,:) = tmp;
    end
end