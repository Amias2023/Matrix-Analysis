function [Q,R]=HouseQR(A)
% 矩阵分解  矩阵QR分解（Householder变换）
% 描述：
%   [Q,R]=HouseQR(A)
%   A为输入矩阵;Q为正交矩阵;R为上三角矩阵;

% 变量定义
[m,n] = size(A);
v = zeros(m,n);
beta = zeros(m,1);
W = zeros(m,n);
Y = zeros(m,n);
%% m>=n
if m>=n
    for j = 1:n
        [v(j:m,j),beta(j)] = House(A(j:m,j)); % 求矩阵A每一列的Householder向量
        A(j:m,j:n) = (eye(length(j:m)) - beta(j)*(v(j:m,j)*v(j:m,j)'))*A(j:m,j:n); % 更新矩阵
        if j < m
            A(j+1:m,j) = v(j+1:m,j);% 将相应列的向量变为Householder向量
        end
    end
    % 获取上三角矩阵R
    R = triu(A);
    % 使用WY表示获取正交矩阵Q
    Y(:,1) = v(:,1);
    W(:,1) = beta(1)*v(:,1);
    for j = 2:n
        z = beta(j)*(eye(m) - W*Y')*v(:,j);
        W(:,j) = z;
        Y(:,j) = v(:,j);
    end
    Q = eye(m) - W*Y';
end
%% m<n
if m < n
    for j = 1:m
        [v(j:m,j),beta(j)] = House(A(j:m,j)); % 求矩阵A每一列的Householder向量
        A(j:m,j:n) = (eye(length(j:m)) - beta(j)*(v(j:m,j)*v(j:m,j)'))*A(j:m,j:n); % 更新矩阵
        if j < m
            A(j+1:m,j) = v(j+1:m,j);% 将相应列的向量变为Householder向量
        end
    end
    % 获取上三角矩阵R
    R = triu(A);
    % 使用WY表示获取正交矩阵Q
    Y(:,1) = v(:,1);
    W(:,1) = beta(1)*v(:,1);
    for j = 2:m
        z = beta(j)*(eye(m) - W*Y')*v(:,j);
        W(:,j) = z;
        Y(:,j) = v(:,j);
    end
    Q = eye(m) - W*Y';
end
end