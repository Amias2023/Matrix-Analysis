# 2024秋-矩阵分析

本项目来源于2024年中山大学的矩阵分析课程的课程作业。

##### 第一个项目完成的任务是：

```Text
1. 编程实现矩阵A的LU分解和利用此分解求解线性方程组Ax=b。
要求实现功能：
（1）判断矩阵A的LU分解是否存在；
（2）矩阵为方阵或非方阵；
（3）能够利用部分旋转和完全旋转获得稳定LU分解；
（4）若A为对称方阵，给出LDL^T分解；
（5）若A为对称正定方阵，给出Cholesky分解；
（6）利用上述分解求解Ax=b（向前/后替代）.
输入：A, b
输出：Yes/No, L, U, D, G, x等
注：不得利用MATLAB自带lu函数和矩阵求逆。
```

###### 函数使用说明：

1. 调用命令：[Flag,L,U,D,G,x]=MyLU(A,b)。  其中，A为系数矩阵，b为常数向量。L为稳定的单位下三角矩阵，U为上三角矩阵，D为对角矩阵，G为Cholesky矩阵。x为解向量。Flag为矩阵是否可以LU分解。
2. 帮助命令：help MyLU。

###### 函数代码剖析：

函数整体由四大部分组成，分别实现了函数的初始化、LU分解的判断和矩阵的描述、LU分解的获取以及利用LU分解求解Ax=b。函数中用来判断值是否非零的界限定为1e-10。

1. 第零部分

   进行L、U、D、G、x和Flag的初始化。除Flag外，其余参数的默认值均为空。同时进行输入参数的验证，保证参数A和b为浮点数组。

2. 第一部分

   通过矩阵A的k阶主子式来判断矩阵LU分解是否存在，并描述矩阵的类型（非方阵、方阵、对称方阵和对称正定方阵）。其中，正定性的判断依据T矩阵的特征值的符号。
   $$
   T=\frac{A+A^T}{2}
   $$

3. 第二部分

   依据矩阵的类型（非方阵、方阵、对称方阵和对称正定方阵）对矩阵进行LU分解，并通过部分旋转获得稳定的LU分解。对于对称方阵，给出LDL^T分解；对于对称正定方阵，给出Cholesky分解；对于一般方阵和非方阵，给出一般形式的LU分解。

   **变量解释：**

   - m：矩阵的行数。
   - n：矩阵的列数。
   - k：表示循环序号。
   - MaxIndex：获得当前列最大绝对值的下标。
   - Pivot：用来表示置换矩阵，为列向量。假设，Pivot=[2;3]。则表示，矩阵的第一行和第二行互换，之后矩阵的第二行在与第三行互换。
   - L：单位下三角矩阵。
   - U：上三角矩阵。
   - D：对角矩阵。
   - G：下三角矩阵。

   **代码解释：**

   下面LU分解依据的是向量形式的算法。采用分块矩阵的形式进行迭代。

   > 原理

   $$
   A=\begin{bmatrix}
   \alpha & \omega^T \\
   v & B
   \end{bmatrix}
   \\
   
   \begin{bmatrix}
   \alpha & \omega^T \\
   v & B
   \end{bmatrix}=
   
   \begin{bmatrix}
   1 & 0 \\
   v/\alpha & I_{n-1}
   \end{bmatrix}
   
   \begin{bmatrix}
   1 & 0 \\
   0 & B-v\omega^T/\alpha
   \end{bmatrix}
   
   \begin{bmatrix}
   \alpha & \omega^T \\
   0 & I_{n-1}
   \end{bmatrix}
   $$

   

   > Cholesky分解

   $$
   PAP^TPx=GG^TPx=Pb。
   $$

   ```matlab
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
   ```

   > LDL^T分解

   $$
   PAP^TPx=LDL^TPx=Pb
   $$

   ```matlab
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
   ```

   > 一般矩阵的LU分解（以方阵为例）

   $$
   PAx=LUx=Pb
   $$

   ```matlab
           for k=1:n
           [~,MaxIndex] = max(abs(A(k:n,k))); % 获得当前列最大绝对值的下标
           Pivot(k,1) = MaxIndex + k -1; % 记录置换矩阵的置换操作
           A([k,Pivot(k,1)],:) = A([Pivot(k,1),k],:); % 用当前列的最大绝对值所在的行与主元行交换
           if A(k,k) ~= 0 % 判断当前主元是否为0，如不为0则进行外积型的LU分解算法
               p=k+1:n;
               A(p,k)=A(p,k)/A(k,k);
               A(p,p)=A(p,p)-A(p,k)*A(k,p);
           end
   ```

4. 第三部分

   通过第二部分完成的各种类型的LU分解，对线性方程组Ax=b进行求解。

   按照不同的矩阵类型（非方阵、方阵、对称方阵和对称正定方阵），编写对应的求解代码。

   按照向前替换和向后替换的方式循环消除变量进行求解，具体为：
   $$
   向前替换:
   \begin{bmatrix}
   \ell_{11} & 0 \\
   \ell_{11} & \ell_{22}
   \end{bmatrix}
   
   \begin{bmatrix}
   x_{1} \\
   x_{2}
   \end{bmatrix}=
   
   \begin{bmatrix}
   b_{1} \\
   b_{2}
   \end{bmatrix}
   \\
   向后替换:
   \begin{bmatrix}
   u_{11} & u_{12} \\
   0 & u_{22}
   \end{bmatrix}
   
   \begin{bmatrix}
   x_{1} \\
   x_{2}
   \end{bmatrix}=
   
   \begin{bmatrix}
   b_{1} \\
   b_{2}
   \end{bmatrix}
   $$
   以LDL^T分解求解Ax=b方程为例：
   $$
   LDL^TPx=Pb
   \\
   1^{st}:Lw=Pb
   \\
   2^{nd}:Dz=w
   \\
   3^{rd}:L^Ty=z
   \\
   4^{th}:Px=y
   $$
   

   ```matlab
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
   ```

   
