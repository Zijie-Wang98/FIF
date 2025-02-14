function [p,FIF] = find_proposed_est(Txlist,Rxlist,pairwise_location_est,flag_map)
    run("../parameter_settings.m");
    FIF = zeros(length(Txlist),length(Rxlist));
    % proposed_est_X = 0;
    % proposed_est_Y = 0;
    cd ../CRB_calculation
    for i=1:length(Txlist)
        for j = 1:length(Rxlist)
            if flag_map(i,j)
                [J,~,~] = FIM_calculation(length(Txlist),i,Txlist(i),Rxlist(j),cell2mat(pairwise_location_est(i,j)));
                iJ = inv(J);
                FIF_temp = 1/trace(iJ(1:2,1:2));
                if isnan(FIF_temp)
                    FIF(i,j) = 0;
                else
                    FIF(i,j) = FIF_temp;
                    % proposed_est_X = proposed_est_X + pairwise_location_est{i,j}(1)*FIF(i,j);
                    % proposed_est_Y = proposed_est_Y + pairwise_location_est{i,j}(2)*FIF(i,j);
                end
            end
        end
    end
    % p = [proposed_est_X proposed_est_Y]/sum(sum(FIF));
    FIF = FIF/sum(sum(FIF));
    p = [0,0];
    for i = 1:length(Txlist)
        for j = 1:length(Rxlist)
            if flag_map(i,j)
                p = p+FIF(i,j)*cell2mat(pairwise_location_est(i,j));
            end
        end
    end
    cd ../Network_localization/
end
