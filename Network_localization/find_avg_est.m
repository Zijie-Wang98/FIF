function p_avg = find_avg_est(pairwise_location_est,flag_map)
    p_avg = [0 0];
    for i=1:size(pairwise_location_est,1)
        for j=1:size(pairwise_location_est,2)
            if flag_map(i,j)
                p_avg = p_avg+pairwise_location_est{i,j};
            end
        end
    end
    p_avg = p_avg/sum(sum(flag_map));
end