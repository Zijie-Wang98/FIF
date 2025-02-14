function p_mse = find_mse_est(pairwise_location_est,flag_map)
    cvx_begin quiet
    cvx_precision high
    variable x(2,1);
    expression obj;
    obj = 0;
    for i=1:size(pairwise_location_est,1)
        for j=1:size(pairwise_location_est,2)
            if  flag_map(i,j)
                %obj = obj+pow_pos(norm(pairwise_location_est{i,j}-x'),2);
                obj = obj+norm(pairwise_location_est{i,j}-x');
            end
        end
    end
    minimize( obj );
    cvx_end
    p_mse = x';
end



