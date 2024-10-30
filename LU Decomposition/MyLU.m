function [Flag,L,U,D,G,x]=MyLU(A,b)
% 本函数的功能介绍
% （1）判断矩阵A的LU分解是否存在；
% （2）矩阵为方阵或非方阵；
% （3）能够利用部分旋转和完全旋转获得稳定LU分解；
% （4）若A为对称方阵，给出LDL^T分解；
% （5）若A为对称正定方阵，给出Cholesky分解；
% （6）利用上述分解求解Ax=b（向前/后替代）.
% 输入：A, b
% 输出：Flag, L, U, D, G, x等
% 函数使用：[Flag,L,U,D,G,x]=MyLU(A,b)
% 注：A为系数矩阵，b为常数向量。L为稳定的单位下三角矩阵，U为上三角矩阵，D为对角矩阵，G为Cholesky矩阵。x为解向量。Flag为矩阵是否可以LU分解。

%% 第零部分：函数预处理和判断
% 使用LU分解求解线性方程组Ax=b
L=[];U=[];D=[];G=[];x=[];Flag=nan; % 默认返回值
mustBeFloat(A);mustBeFloat(b) % 验证值是浮点数组
%% 第一部分：确认矩阵LU分解存在
[m,n] = size(A);
for k = 1:min([m,n]) % 通过判断k阶主子式的值来判断LU分解是否存在
    if abs(det(A(1:k,1:k)) - 0) < 1e-10
        Flag=0; % 矩阵不能进行LU分解
        disp("矩阵LU分解不存在");
        return % 退出整个函数
    elseif k == min([m n])
        Flag=1; % 矩阵可以进行LU分解
        disp("矩阵LU分解存在");
    end
end
% 对矩阵进行简单描述
if m ~= n % 判断矩阵是否为方阵
    disp("矩阵非方阵");
else
    if norm(A-transpose(A))< 1e-10 % 判断矩阵是否为对称方阵
        if min(eig((A+transpose(A))/2))>0 % 判断矩阵是否为正定矩阵
            disp("矩阵为对称正定方阵,将给出Cholesky分解");
        else
            disp("矩阵为对称方阵，将给出LDL^T分解");
        end
    else
        disp("矩阵为方阵");
    end
end
%% 第二部分：获取矩阵A的LU分解
Pivot = zeros(max(m,n),1); % 定义置换向量
% ----下面是方阵的矩阵LU分解----
if m==n 
    if norm(A-transpose(A))< 1e-10  % 判断矩阵是否为对称方阵
        if min(eig((A+transpose(A))/2))>0 % 判断矩阵是否为正定矩阵,给出Cholesky分解
            for k=1:n 
                [~,MaxIndex] = max(abs(diag(A(k:n,k:n))));
                Pivot(k,1) = MaxIndex + k -1;
                A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 置换行
                A(:,[k,Pivot(k,1)]) = A(:,[Pivot(k,1),k]); % 再置换列，获得对称矩阵
                alpha = A(k,k);
                v = A(k+1:n,k);
                A(k+1:n,k) = v/alpha;
                A(k+1:n,k+1:n) = A(k+1:n,k+1:n) - v*v'/alpha;
            end
            G=(A-triu(A)+eye(m,n))*diag(sqrt(diag(A))); % 获得Cholesky矩阵
        else % 如果矩阵为对称非正定方阵，给出稳定的LDL^T分解
            for k=1:n % 基于外积形式的LDL^T分解
                [~,MaxIndex] = max(abs(diag(A(k:n,k:n))));
                Pivot(k,1) = MaxIndex + k -1;
                A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 置换行
                A(:,[k,Pivot(k,1)]) = A(:,[Pivot(k,1),k]); % 再置换列，获得对称矩阵
                alpha = A(k,k);
                v = A(k+1:n,k);
                A(k+1:n,k) = v/alpha;
                A(k+1:n,k+1:n) = A(k+1:n,k+1:n) - v*v'/alpha;
            end
            L=A-triu(A)+eye(m,n); % 获得单位下三角矩阵
            D=diag(diag(A)); % 获得对角矩阵
        end
    else % 如果不是对称的，则输出一般形式的稳定LU分解
        for k=1:n
        [~,MaxIndex] = max(abs(A(k:n,k))); % 获得当前列最大绝对值的下标
        Pivot(k,1) = MaxIndex + k -1; % 记录置换矩阵的置换操作
        A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 用当前列的最大绝对值所在的行与主元行交换
        if A(k,k) ~= 0 % 判断当前主元是否为0，如不为0则进行外积型的LU分解算法
            p=k+1:n;
            A(p,k)=A(p,k)/A(k,k);
            A(p,p)=A(p,p)-A(p,k)*A(k,p);
        end
        L=tril(A)-diag(diag(A))+eye(m,n); % 获得单位下三角矩阵
        U=triu(A); % 获得上三角矩阵
        end
    end
end

% ----下面是竖柱型的矩阵LU分解----
if m>n 
    for k = 1:n
        [~,MaxIndex] = max(abs(A(k:m,k))); % 获得当前列最大绝对值的下标
        Pivot(k,1) = MaxIndex + k -1; % 记录置换矩阵的置换操作
        A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 用当前列的最大绝对值所在的行与主元行交换
        if A(k,k) ~= 0 % 判断当前主元是否为0，如不为0则进行外积型的LU分解算法
            p=k+1:m;
            A(p,k)=A(p,k)/A(k,k);
            if k<n
                u=k+1:n;
                A(p,u)=A(p,u)-A(p,k)*A(k,u);
            end
        end
    end
    L = A-triu(A)+eye(m,n);% 获得单位下三角矩阵
    U = triu(A(1:n,1:n));% 获得上三角矩阵
end

% ----下面是横柱型的矩阵LU分解----
if m<n 
    for k = 1:m
        [~,MaxIndex] = max(abs(A(k:m,k))); % 获得当前列最大绝对值的下标
        Pivot(k,1) = MaxIndex + k -1; % 记录置换矩阵的置换操作
        A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 用当前列的最大绝对值所在的行与主元行交换
        if A(k,k) ~= 0 % 判断当前主元是否为0，如不为0则进行外积型的LU分解算法
            if k<m
                p=k+1:m;
                A(p,k)=A(p,k)/A(k,k);
                u=k+1:n;
                A(p,u)=A(p,u)-A(p,k)*A(k,u);
            end
        end
    end
    L = tril(A(1:m,1:m))-diag(diag(A))+eye(m);% 获得单位下三角矩阵
    U = triu(A);% 获得上三角矩阵
end
%% 第三部分：使用LU分解求Ax=b
z=[];y=[]; % 定义中间变量
% ----下面是对于Cholesky分解的线性方程组求解----
if ~isempty(G) % GG^T*Px=P*b
    for k=1:n
        b([k,Pivot(k,1)]) = b([Pivot(k,1),k]);% 转换顺序
    end
    % 解G*z=P*b
    z=b;
    for k = 1:n-1 % 向前替换
        z(k)=z(k)/G(k,k);
        z(k+1:n)=z(k+1:n)-z(k)*G(k+1:n,k);
    end
    z(n)=z(n)/G(n,n);
    % 解G^T*y=z
    y=z;TransG=transpose(G);
    for k = n:-1:2% 向后替换
        y(k)=y(k)/TransG(k,k);
        y(1:k-1)=y(1:k-1)-y(k)*TransG(1:k-1,k);
    end
    y(1)=y(1)/TransG(1,1);
    % 解x=P^T*y
    x=y;
    for k=n:-1:1
        x([k,Pivot(k,1)]) = x([Pivot(k,1),k]);% 转换顺序
    end
end
% ----下面是对于LDL^T分解的线性方程组求解----
if ~isempty(D) % LDL^T*Px=P*b
    for k=1:n
        b([k,Pivot(k,1)]) = b([Pivot(k,1),k]);% 转换顺序
    end
    % 解L*z=P*b
    z=b;
    for k = 1:n-1 % 向前替换
        z(k)=z(k)/L(k,k);
        z(k+1:n)=z(k+1:n)-z(k)*L(k+1:n,k);
    end
    z(n)=z(n)/L(n,n);
    % 解D*y=z
    y=z./diag(D);
    % 解L^T*x=y
    x=y;TransL=transpose(L);
    for k = n:-1:2 % 向后替换
        x(k)=x(k)/TransL(k,k);
        x(1:k-1)=x(1:k-1)-x(k)*TransL(1:k-1,k);
    end
    x(1)=x(1)/TransL(1,1);
    % 解x=P^T*x'
    for k=n:-1:1
        x([k,Pivot(k,1)]) = x([Pivot(k,1),k]);% 转换顺序
    end
end
% ----下面是对于一般方阵的LU分解的线性方程组求解----
if isempty(G)&isempty(D)&m==n % LUx=Pb
    for k=1:n
        b([k,Pivot(k,1)]) = b([Pivot(k,1),k]);% 转换顺序
    end
    % 解L*y=P*b
    y=b;
    for k = 1:n-1 % 向前替换
        y(k)=y(k)/L(k,k);
        y(k+1:n)=y(k+1:n)-y(k)*L(k+1:n,k);
    end
    y(n)=y(n)/L(n,n);
    % 解U*x=y
    x=y;
    for k = n:-1:2 % 向后替换
        x(k)=x(k)/U(k,k);
        x(1:k-1)=x(1:k-1)-x(k)*U(1:k-1,k);
    end
    x(1)=x(1)/U(1,1);
end
% ----下面是对于竖柱型的LU分解的线性方程组求解----
if isempty(G)&isempty(D)&m>n % LUx=P*b
    for k=1:n 
        b([k,Pivot(k,1)]) = b([Pivot(k,1),k]);% 转换顺序
    end
    % 解L*y=P*b，由于该矩阵主子式均不等于0，方程解唯一存在。故只计算L(1:n,1:n)对应的方程
    y=b(1:n,:);
    for k = 1:n-1 % 向前替换
        y(k)=y(k)/L(k,k);
        y(k+1:n)=y(k+1:n)-y(k)*L(k+1:n,k);
    end
    y(n)=y(n)/L(n,n);
    % 解U*x=y
    x=y;
    for k = n:-1:2 % 向后替换
        x(k)=x(k)/U(k,k);
        x(1:k-1)=x(1:k-1)-x(k)*U(1:k-1,k);
    end
    x(1)=x(1)/U(1,1);
end
% ----下面是对于横柱型的LU分解的线性方程组求解----
if isempty(G)&isempty(D)&m<n % LUx=P*b
    for k=1:m
        b([k,Pivot(k,1)]) = b([Pivot(k,1),k]);% 转换顺序
    end
    % 解L*y=P*b
    y=b;
    for k = 1:m-1 % 向前替换
        y(k)=y(k)/L(k,k);
        y(k+1:m)=y(k+1:m)-y(k)*L(k+1:m,k);
    end
    y(m)=y(m)/L(m,m);
    % 解U*x=y，由于该矩阵主子式均不等于0，方程解存在且有无数解。故将x(m<n,:)设为0
    x=y;
    for k = m:-1:2 % 向后替换
        x(k)=x(k)/U(k,k);
        x(1:k-1)=x(1:k-1)-x(k)*U(1:k-1,k);
    end
    x(1)=x(1)/U(1,1);
    x(m+1:n,:)=0; % 将x(m<n,:)设为0
end
end
