function [v,beta] = House(x)
% 反射  生成给定向量的Householder矩阵
% 描述：
%   [v,beta] = House(x)
%   x为输入列向量;v为Householder向量;beta为系数算子;
%   该向量第一个元素变为原向量的2范数，其余元素变为0。

m=length(x); % 向量的长度

if m == 1 % 对于常数值直接返回
    v=0;
    beta=0;
    return 
end

sigma=x(2:m)'*x(2:m); 
v=ones(m,1);
v(2:m)=x(2:m);

if sigma == 0 && x(1)>=0
    beta=0;
elseif sigma == 0 && x(1)<0
    beta=-2;
else
    u=sqrt(x(1)^2+sigma);
    if x(1)<=0
        v(1)=x(1)-u;
    else
        v(1)=-sigma/(x(1)+u);
    end
    beta = 2*v(1)^2/(sigma+v(1)^2);
    v=v/v(1);
end

end