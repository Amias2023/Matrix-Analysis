
# <span style="color:rgb(213,80,0)">下面进行demo演示</span>
```matlab
% 第一部分：矩阵LU分解的存在性判断
Test1=[1 2 3;4 5 6;7 8 9] % 矩阵奇异，无法进行LU分解
```

```matlabTextOutput
Test1 = 3x3    
     1     2     3
     4     5     6
     7     8     9

```

```matlab
DetTest1=det(Test1) % 求矩阵的秩
```

```matlabTextOutput
DetTest1 = 6.6613e-16
```

```matlab
Test2=[1 4 7;2 5 8;3 6 10] % 矩阵非奇异，可以进行LU分解，来自书中p113
```

```matlabTextOutput
Test2 = 3x3    
     1     4     7
     2     5     8
     3     6    10

```

```matlab
% 令它们的解都为x=[1;2;3]，算出的b为
b1=[14;32;50] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
    14
    32
    50

```

```matlab
b2=[30;36;45] % 对应为Test2
```

```matlabTextOutput
b2 = 3x1    
    30
    36
    45

```

```matlab
% 带入编写的MyLU函数
Flag1=MyLU(Test1,b1) % 验证Test1，返回值为0
```

```matlabTextOutput
矩阵LU分解不存在
Flag1 = 0
```

```matlab
Flag2=MyLU(Test2,b2) % 验证Test2，返回值为1
```

```matlabTextOutput
矩阵LU分解存在
矩阵为方阵
Flag2 = 1
```

```matlab
% 第二部分：判断矩阵是否为方阵
Test1=[4 1 1;1 3 0;1 0 2] % 对称正定方阵
```

```matlabTextOutput
Test1 = 3x3    
     4     1     1
     1     3     0
     1     0     2

```

```matlab
Test2=[1 4 7;2 5 8;3 6 10] % 非对称方阵
```

```matlabTextOutput
Test2 = 3x3    
     1     4     7
     2     5     8
     3     6    10

```

```matlab
% 同上，令它们的解都为x=[1;2;3]，算出的b为
b1=[9;7;7] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
     9
     7
     7

```

```matlab
b2=[30;36;45] % 对应为Test2
```

```matlabTextOutput
b2 = 3x1    
    30
    36
    45

```

```matlab
% 带入编写的MyLU函数
Flag1=MyLU(Test1,b1) % 返回提示：矩阵对称正定方阵
```

```matlabTextOutput
矩阵LU分解存在
矩阵为对称正定方阵,将给出Cholesky分解
Flag1 = 1
```

```matlab
Flag2=MyLU(Test2,b2) % 返回提示：矩阵非对称方阵
```

```matlabTextOutput
矩阵LU分解存在
矩阵为方阵
Flag2 = 1
```

```matlab
% 第三部分：非方阵的LU分解求解
Test1=[1 2;3 4;5 6] % 竖柱型的矩阵，来自书中p118
```

```matlabTextOutput
Test1 = 3x2    
     1     2
     3     4
     5     6

```

```matlab
Test2=[1 2 3;4 5 6] % 横柱型的矩阵，来自书中p118
```

```matlabTextOutput
Test2 = 2x3    
     1     2     3
     4     5     6

```

```matlab
% 同上，令它们的解都为x=[1;2;3]，算出的b为
b1=[5;11;17] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
     5
    11
    17

```

```matlab
b2=[14;32] % 对应为Test2
```

```matlabTextOutput
b2 = 2x1    
    14
    32

```

```matlab
% 带入编写的MyLU函数
[~,L1,U1,~,~,x1]=MyLU(Test1,b1) % 返回L，U和x
```

```matlabTextOutput
矩阵LU分解存在
矩阵非方阵
L1 = 3x2    
1.0000         0
    0.2000    1.0000
    0.6000    0.5000

U1 = 2x2    
    5.0000    6.0000
         0    0.8000

x1 = 2x1    
     1
     2

```

```matlab
[~,L2,U2,~,~,x2]=MyLU(Test2,b2) % 返回L，U和x
```

```matlabTextOutput
矩阵LU分解存在
矩阵非方阵
L2 = 2x2    
1.0000         0
    0.2500    1.0000

U2 = 2x3    
    4.0000    5.0000    6.0000
         0    0.7500    1.5000

x2 = 3x1    
    -2
     8
     0

```

```matlab
% 进行验证
if Test1*x1==b1 % 验证解向量是否正确
    disp("解向量正确")
end
```

```matlabTextOutput
解向量正确
```

```matlab
if Test2*x2==b2 % 验证解向量是否正确
    disp("解向量正确")
end
```

```matlabTextOutput
解向量正确
```

```matlab
% 第四部分：一般方阵的LU分解求解
Test1=[1 4 7;2 5 8;3 6 10] % 一般类型方阵，来自书中p113
```

```matlabTextOutput
Test1 = 3x3    
     1     4     7
     2     5     8
     3     6    10

```

```matlab
% 令解为x=[1;2;3]，算出的b为
b1=[30;36;45] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
    30
    36
    45

```

```matlab
% 带入编写的MyLU函数
[~,L1,U1,~,~,x1]=MyLU(Test1,b1) % 返回L，U和x
```

```matlabTextOutput
矩阵LU分解存在
矩阵为方阵
L1 = 3x3    
1.0000         0         0
    0.3333    1.0000         0
    0.6667    0.5000    1.0000

U1 = 3x3    
    3.0000    6.0000   10.0000
         0    2.0000    3.6667
         0         0   -0.5000

x1 = 3x1    
1.0000
    2.0000
    3.0000

```

```matlab
if Test1*x1==b1 % 验证解向量是否正确
    disp("解向量正确")
end
```

```matlabTextOutput
解向量正确
```

```matlab
% 第五部分：对称方阵的LDL^T分解求解
Test1=[1 0 3;0 4 5;3 5 6] % 对称方阵，且不是正定的
```

```matlabTextOutput
Test1 = 3x3    
     1     0     3
     0     4     5
     3     5     6

```

```matlab
% 令解为x=[1;2;3]，算出的b为
b1=[10;23;31] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
    10
    23
    31

```

```matlab
[~,L1,~,D1,~,x1]=MyLU(Test1,b1) % 返回L，D和x
```

```matlabTextOutput
矩阵LU分解存在
矩阵为对称方阵，将给出LDL^T分解
L1 = 3x3    
1.0000         0         0
    0.5000    1.0000         0
    0.8333    5.0000    1.0000

D1 = 3x3    
    6.0000         0         0
         0   -0.5000         0
         0         0   12.3333

x1 = 3x1    
     1
     2
     3

```

```matlab
if Test1*x1==b1 % 验证解向量是否正确
    disp("解向量正确")
end
```

```matlabTextOutput
解向量正确
```

```matlab
% 第五部分：对称正定方阵的GG^T分解求解
Test1=[4 1 1;1 3 0;1 0 2] % 对称正定方阵
```

```matlabTextOutput
Test1 = 3x3    
     4     1     1
     1     3     0
     1     0     2

```

```matlab
% 令解为x=[1;2;3]，算出的b为
b1=[9;7;7] % 对应为Test1
```

```matlabTextOutput
b1 = 3x1    
     9
     7
     7

```

```matlab
[~,~,~,~,G1,x1]=MyLU(Test1,b1) % 返回G和x
```

```matlabTextOutput
矩阵LU分解存在
矩阵为对称正定方阵,将给出Cholesky分解
G1 = 3x3    
    2.0000         0         0
    0.5000    1.6583         0
    0.5000   -0.1508    1.3143

x1 = 3x1    
     1
     2
     3

```

```matlab
if Test1*x1==b1 % 验证解向量是否正确
    disp("解向量正确")
end
```

```matlabTextOutput
解向量正确
```
