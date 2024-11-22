function [Q,R] = MGSQR(A)
% 矩阵分解  矩阵QR分解(施密特正交化)
% 描述：
%   [Q,R] = MGSQR(A)
%   A为输入矩阵;Q为正交矩阵;R为上三角矩阵;

% 变量定义
[m,n] = size(A);
R = zeros(n);
Q = zeros(m,n);
% 检验矩阵是否列满秩
S=svd(A);
if min(abs(S)) - 0 < 1e-10 || m < n
    error("矩阵列不满秩，无法使用MGS");
end
for k = 1:n % Modified Gram-Schmidt Algorithm
    R(k,k) = norm(A(1:m,k));
    Q(1:m,k) = A(1:m,k)/R(k,k);
    for j = k+1:n
        R(k,j) = Q(1:m,k)'*A(1:m,j);
        A(1:m,j) = A(1:m,j) -Q(1:m,k)*R(k,j);
    end
end
end