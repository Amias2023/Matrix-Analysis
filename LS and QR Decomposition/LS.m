function [Q,R,x,p] = LS(A,b,Options)
% 矩阵求解  矩阵最小二乘解
% 描述：
%   [Q,R,x,p] = LS(A,b,Options)
%   A为输入矩阵;b为常数向量;
%   Options为选择进行QR分解的方法：
%   Options=1  Householder变换
%   Options=2  Givens旋转
%   Options=3  Modified Gram-Schmidt正交化
%   Q为正交矩阵;R为上三角矩阵;x为最小二乘向量;p为最小二乘残差;

% 变量定义
[m,n] = size(A);
S=svd(A);
% 获得矩阵的QR分解
if Options == 1 % 矩阵Householder变换QR分解
    [Q,R] = HouseQR(A);
end
if Options == 2 % 矩阵Givens旋转QR分解
    [Q,R] = GivensQR(A);
end
if Options == 3 % 矩阵Modified Gram-Schmidt正交化QR分解
    [Q,R] = MGSQR(A);
end
% 使用矩阵的QR分解完成最小二乘计算
% 最小二乘问题
if min(abs(S)) - 0 < 1e-10 || m < n
     % 列不满秩下的矩阵的最小二乘，输出具有最小二范数的最小二乘解
    r = rank(A);
    y = zeros(n,1);
    [U,S,V] = svd(A); % 使用SVD分解完成矩阵完全正交分解
    Qb = U'*b;
    w = Qb(1:r)./diag(S(1:r,1:r));
    y(1:r) = w;
    x = V*y;
    p = norm(A*x - b); % 残差
else % 列满秩下的矩阵的最小二乘
    R = R(1:n,1:n);
    Qb = Q'*b; 
    x = Qb(1:n);
    for k = n:-1:2 % 向后替换
        x(k) = x(k)/R(k,k);
        x(1:k-1) = x(1:k-1)-x(k)*R(1:k-1,k);
    end
    x(1) = x(1)/R(1,1);
    p = norm(A*x - b); % 残差
end
end