function fused_point = information_filter_fusion(points)
    % 信息滤波器融合多个观测点
    % 输入:
    %   points - 2xN 矩阵，每列是一个二维点 [x; y]
    % 输出:
    %   fused_point - 2x1 向量，最终融合后的坐标

    N = size(points, 2);
    if N == 1
        fused_point = points;
    else
        % 初始值：假设初步估计为几何中心
        fused_point = mean(points, 2);
        
        % 初始信息矩阵为单位矩阵（假设初始方差较大）
        information_matrix = eye(2) * 1e-3;  % 假设初始方差较大
        
        for i = 1:N
            % 计算当前观测点与当前融合点的残差
            residual = points(:, i) - fused_point;
            
            % 估计当前观测点的方差（信息矩阵是方差的倒数）
            variance = residual' * residual;  % 残差的平方作为方差
            
            % 计算信息矩阵：方差的倒数
            info_weight = 1 / variance;  % 信息矩阵（精度的倒数）
            
            % 更新信息矩阵（应为矩阵相加，使用 info_weight 乘以单位矩阵）
            information_matrix = information_matrix + info_weight * eye(2); 
            
            % 更新融合点：按信息矩阵更新
            fused_point = fused_point + info_weight * residual / information_matrix(1, 1); % 使用对角元素来进行标量更新
        end
    end
end