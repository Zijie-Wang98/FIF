function result = extract_vectors(cell_array, binary_matrix)
    % 提取 binary_matrix 中值为 1 的位置对应的 cell_array 向量，并排成 2×K 矩阵
    % cell_array: M×N cell，每个 cell 是 2×1 向量
    % binary_matrix: M×N 的 0/1 矩阵
    % result: 2×K 矩阵，包含所有 binary_matrix=1 位置的向量
    
    % 找到 binary_matrix 中值为 1 的索引
    [row, col] = find(binary_matrix == 1);
    
    % 计算 K（binary_matrix 中 1 的个数）
    K = numel(row);
    
    % 预分配结果矩阵 (2×K)
    result = zeros(2, K);
    
    % 提取对应的向量并排列成 2×K 矩阵
    for k = 1:K
        result(:, k) = cell_array{row(k), col(k)};
    end
end