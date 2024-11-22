function [c,s] = Givens(a,b)
% 旋转 生成给定2维向量的Givens旋转矩阵
% 描述：
%   [c,s] = Givens(a,b)
%   a,b为输入列向量的第一、二个分量;c,s为Givens矩阵的旋转元素;
%   该向量第二个元素b将变为0;

if b == 0 % 如果本身已经消元过了，返回单位矩阵
    c=1;
    s=0;
else
    if abs(b) > abs(a) % 判断二者大小，使abs(t)<1
        t = -a/b;
        s = 1/sqrt(1+t^2);
        c = s*t;
    else
        t = -b/a;
        c = 1/sqrt(1+t^2);
        s = c*t;
    end
end