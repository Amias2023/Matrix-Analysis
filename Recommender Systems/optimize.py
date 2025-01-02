import numpy as np
import pandas as pd
from numpy.linalg import svd
from numpy.linalg import solve

def optimize_Initialize(matrix,factors):
    users_num, movies_num = matrix.shape 
    users_init = np.random.rand(factors, users_num )
    movies_init = np.random.rand(factors, movies_num)
    return users_init,movies_init

def optimize_RMSE(matrix,users,movies):
    """获取均方根误差，用于评价矩阵因子分解的效果

    Args:
        matrix (_type_): 用户-电影评分矩阵
        users (ndarray): 用户-因子矩阵
        movies (ndarray): 电影-因子矩阵

    Returns:
        float: 返回均方根误差
    """
    users_num, movies_num = matrix.shape
    opt_matrix = np.dot(users.T,movies) # 最优化后的用户-电影评分矩阵
    # opt_matrix = np.around(opt_matrix) # 考虑到用户评分为整数，这里我进行了四舍五入取整
    error = 0 # 定义累计误差值（平方）
    num = 0 # 获取用户评分总数（用于计算均方根误差）
    for user in range(users_num):
        for movie in range(movies_num):
            if matrix[user, movie]>0:
                num += 1
                error += (matrix[user, movie] - opt_matrix[user, movie])**2
    RMSE = np.sqrt(error/num)
    return RMSE

def optimize_SGD(matrix,factors,lambda_,gamma,iterations): 
    """使用随机梯度下降法进行矩阵分解优化

    Args:
        matrix (ndarray): 用户-电影评分矩阵
        factors (int): 潜在因子数量
        lambda_ (float): 正则化参数
        gamma (float): 随机下降幅度参数
        iterations (int): 最大迭代次数
        # ! 参考的lambda_=0.02，gamma=0.02

    Returns:
        users (ndarray): 优化后的用户-因子矩阵
        movies (ndarray): 优化后的电影-因子矩阵
    """ 
    users_num, movies_num = matrix.shape
    users, movies = optimize_Initialize(matrix,factors)
    for _ in range(iterations):
        for u in range(users_num):
            for i in range(movies_num):
                if matrix[u, i] > 0:
                    prediction = np.dot(users[:,u], movies[:,i])
                    error = matrix[u, i] - prediction
                    users[:,u] += gamma * (error * movies[:,i] - lambda_ * users[:,u])
                    movies[:,i] += gamma * (error * users[:,u] - lambda_ * movies[:,i])
    return users, movies

def optimize_ALS(matrix,factors,lambda_,iterations,tolerance):  
    """使用交替最小二乘法进行矩阵分解优化

    Args:
        matrix (ndarray): 用户-电影评分矩阵
        factors (int): 潜在因子数量
        lambda_ (float): 正则化参数
        iterations (int): 最大迭代次数
        tolerance (float): 收敛阈值

    Returns:
        users (ndarray): 优化后的用户-因子矩阵
        movies (ndarray): 优化后的电影-因子矩阵
    """ 
    users_num, movies_num = matrix.shape
    users, movies = optimize_Initialize(matrix,factors)
    for iteration in range(iterations):
        # 固定用户因子，更新电影因子
        for movie in range(movies_num):
            non_zero_users_indices = np.where(matrix[:, movie] > 0)[0]
            if len(non_zero_users_indices) > 0:
                A_movie = np.sum([np.outer(users[:, user], users[:, user]) for user in non_zero_users_indices], axis=0) + lambda_ * np.eye(factors)
                b_movie = np.sum([matrix[user, movie] * users[:, user] for user in non_zero_users_indices], axis=0)
                movies[:, movie] = solve(A_movie, b_movie)
        # 固定电影因子，更新用户因子
        for user in range(users_num):
            non_zero_movies_indices = np.where(matrix[user, :] > 0)[0]
            if len(non_zero_movies_indices) > 0:
                C_user = np.sum([np.outer(movies[:, movie], movies[:, movie]) for movie in non_zero_movies_indices], axis=0) + lambda_ * np.eye(factors)
                d_user = np.sum([matrix[user, movie] * movies[:, movie] for movie in non_zero_movies_indices], axis=0)
                users[:, user] = solve(C_user, d_user)
        current_rmse = optimize_RMSE(matrix,users, movies)
        if iteration > 0 and np.abs(current_rmse - previous_rmse) < tolerance: # 判断是否收敛
            break
        previous_rmse = current_rmse
    return users, movies

def optimize_SVD(matrix,factors):
    """使用奇异值分解法进行矩阵分解优化

    Args:
        matrix (ndarray): 用户-电影评分矩阵
        factors (int): 潜在因子数量

    Returns:
        users (ndarray): 优化后的用户-因子矩阵
        movies (ndarray): 优化后的电影-因子矩阵
    """
    U,S,V = svd(matrix)
    users = np.dot(U[:,:factors],np.sqrt(np.diag(S)[:factors,:factors])).T
    movies = np.dot(np.sqrt(np.diag(S)[:factors,:factors]),V[:factors,:])
    return users, movies
