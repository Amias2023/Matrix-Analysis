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
##### 第二个项目完成的任务是：
```Text
1. 编程实现矩阵A的QR分解和利用此分解求解最小二乘问题。
要求实现功能：
（1）Householder QR；(参考课本P249 算法5.2.1)
（2）Givens QR；(参考课本P252 算法5.2.4)
（3）改进Gram-Schmidt QR；(参考课本P255 算法5.2.6)
（4）利用上述分解求解最小二乘问题 min||Ax-b||_2.
输入：A, b
输出：Q, R, x等
注：不得利用MATLAB自带qr函数。
```
