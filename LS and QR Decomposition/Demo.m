%% 测试算例1 使用QR分解完成4阶幻方矩阵最小二乘
A=magic(4); % 非列满秩的
b=rand(4,1);
% 使用Householder变化完成最小二乘
[Q,R,X,p] = LS(A,b,1);
disp("----下面是基于Householder变化实现的矩阵QR分解与最小二乘----");
disp("Q矩阵是:");disp(Q);
disp("R矩阵是:");disp(R);
disp("最小二乘解是:");disp(X);
disp("残差是:");disp(p);
% 使用Givens旋转完成最小二乘
[Q,R,X,p] = LS(A,b,2);
disp("----下面是基于Givens旋转实现的矩阵QR分解与最小二乘----");
disp("Q矩阵是:");disp(Q);
disp("R矩阵是:");disp(R);
disp("最小二乘解是:");disp(X);
disp("残差是:");disp(p);
%% 测试算例2 使用QR分解完成8*5随机矩阵最小二乘
A=rand(8,5); % 列满秩的
b=rand(8,1);
% 使用Householder变化完成最小二乘
[Q,R,X,p] = LS(A,b,1);
disp("----下面是基于Householder变化实现的矩阵QR分解与最小二乘----");
disp("Q矩阵是:");disp(Q);
disp("R矩阵是:");disp(R);
disp("最小二乘解是:");disp(X);
disp("残差是:");disp(p);
% 使用Givens旋转完成最小二乘
[Q,R,X,p] = LS(A,b,2);
disp("----下面是基于Givens旋转实现的矩阵QR分解与最小二乘----");
disp("Q矩阵是:");disp(Q);
disp("R矩阵是:");disp(R);
disp("最小二乘解是:");disp(X);
disp("残差是:");disp(p);
% 使用Modified Gram-Schmidt正交化完成最小二乘
[Q,R,X,p] = LS(A,b,3);
disp("----下面是基于Modified Gram-Schmidt正交化实现的矩阵QR分解与最小二乘----");
disp("Q矩阵是:");disp(Q);
disp("R矩阵是:");disp(R);
disp("最小二乘解是:");disp(X);
disp("残差是:");disp(p);
%% 测试算例3 使用最小二乘拟合数据点，并输出R方
% 导入数据
load("data_2D.mat");
A = [Data(:,1),ones(length(Data(:,1)),1)];
b = Data(:,2);
% 最小二乘
[Q,R,X,p] = LS(A,b,1);
disp(Q);disp(R);disp(X);disp(p);
% 计算R方
Y = X(1)*Data(:,1) + X(2); % Y的估计
SSR = sum((Y - Data(:,2)).^2); % 残差平方和
SST = sum((Data(:,2) - mean(Data(:,2))).^2); % 总平方和
R2 = 1 - SSR/SST; % 计算R方
% 画图展示
syms x; % 定义符号变量
y = X(1)*x + X(2); % 创建参数方程
scatter(Data(:,1),Data(:,2),400,"k."); % 创建参数方程
hold on;
fplot(y,[-1,1],'r','LineWidth',2)
xlabel("x");
ylabel("y");
eq = sprintf('y = %.2fx + %.2f', X(1), X(2)); % 打印公式
text(0.6, 2, eq,"FontSize",15,"Color",'b'); % 添加文本
R2_ = sprintf('R^2 = %.2f', R2); % R方
text(0.6, 1, R2_,"FontSize",15,"Color",'b'); % 添加文本

