function [Q,R] = GivensQR(A)
% 矩阵分解  矩阵QR分解（Givens变换）
% 描述：
%   [Q,R] = GivensQR(A)
%   A为输入矩阵;Q为正交矩阵;R为上三角矩阵;

% 变量定义
[m,n] = size(A);
%% m>=n
if m>=n
    k = 1; % 用于元胞赋值
    Q = eye(m);
    G = cell(m*n - n*(n+1)/2,1); % 循环次数，用于存储每次的Givens矩阵
    for j = 1:n
        for i = m:-1:j+1
            G{k} = eye(m);
            [c,s] = Givens(A(i-1,j),A(i,j));
            G{k}(i-1,i-1)=c;G{k}(i-1,i)=s; % 构造Givens旋转矩阵
            G{k}(i,i-1)=-s;G{k}(i,i)=c;
            A= G{k}'*A; % 进行Givens旋转
            k = k+1;
        end
    end
    % 获取上三角矩阵R
    R = triu(A);
    % 获取正交矩阵Q
    for k = 1:m*n - n*(n+1)/2
        Q = Q*G{k};
    end
end
%% m<n
if m<n
    k = 1; % 用于元胞赋值
    Q = eye(m);
    G = cell(m*(m-1)/2,1); % 循环次数，用于存储每次的Givens矩阵
    for j = 1:m
        for i = m:-1:j+1
            G{k} = eye(m);
            [c,s] = Givens(A(i-1,j),A(i,j));
            G{k}(i-1,i-1)=c;G{k}(i-1,i)=s; % 构造Givens旋转矩阵
            G{k}(i,i-1)=-s;G{k}(i,i)=c;
            A= G{k}'*A; % 进行Givens旋转
            k = k+1;
        end
    end
    % 获取上三角矩阵R
    R = triu(A);
    % 获取正交矩阵Q
    for k = 1:m*(m-1)/2
        Q = Q*G{k};
    end
end
end
