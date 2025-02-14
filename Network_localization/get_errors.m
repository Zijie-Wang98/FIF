function [time,error] = get_errors(Txlist,Rxlist,pairwise_est,flag_map,target)
    %error: avg,mse,FIF,IF,WLS
    %time: avg,mse,FIF,IF,WLS

    %%%%%%%%%%% avg
    tic
    P_avg = find_avg_est(pairwise_est,flag_map);
    time(1) = toc;
    error(1) = vecnorm(P_avg-target);

    %%%%%%%%%% mse
    tic
    P_mse = find_mse_est(pairwise_est,flag_map);
    time(2) = toc;

    if P_mse == [0 0]
        error(2) = nan;
    else
        error(2) = vecnorm(P_mse-target);
    end
    
    %%%%%%%%%%% FIF
    tic
    [P_fif,~] = find_proposed_est(Txlist,Rxlist,pairwise_est,flag_map);
    time(3) = toc;
    error(3) = vecnorm(P_fif-target);

    points = extract_vectors(pairwise_est,flag_map);  
    
    
    tic
    P_IF = information_filter_fusion(points);
    time(4) = toc;
    error(4) = vecnorm(P_IF-target');

    tic
    P_WLS = least_squares_fusion(points);
    time(5) = toc;
    error(5) = vecnorm(P_WLS-target');   
end
    