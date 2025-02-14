function fused_point = least_squares_fusion(points)
    % 自适应协方差加权最小二乘（AC-WLS）融合
    % 输入:
    %   points - 2xN 矩阵，每列是一个二维点 [x; y]
    % 输出:
    %   fused_point - 2x1 向量，最终融合后的坐标

    N = size(points, 2);
    
    if N == 1
        fused_point = points;
    else
        % 计算所有点的几何中心（初步估计）
        mean_point = mean(points, 2);
        
        % 计算每个点的偏差（残差）
        residuals = vecnorm(points - mean_point, 2, 1);  % 计算欧几里得距离
        
        % 估计每个点的方差（误差越大，方差越大）
        variances = residuals.^2;  % 误差平方作为方差的估计
        
        % 避免某些方差为零（设置最小方差）
        min_variance = max(variances) * 1e-3;
        variances = max(variances, min_variance);
        
        % 计算权重（方差的倒数）
        weights = 1 ./ variances;
        
        % 加权最小二乘融合
        fused_point = sum(points .* weights, 2) / sum(weights);
    end
end