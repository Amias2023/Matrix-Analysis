import numpy as np
import pandas as pd

def probe_set(matrix,num):
    """生成探测集

    Args:
        matrix (ndarray): 用户-电影评分矩阵
        num (int, optional): 选取的从原有矩阵中作为探测集的数量. Defaults to None.
        rate (float, optional): 选取的从原有矩阵中作为探测集的比例. Defaults to None.

    Returns:
        train: 生成的训练集
        positions: 探测集的位置
    """
    indices = np.argwhere(matrix > 0) # 找到所有非零元素的位置
    selected = indices[np.random.choice(len(indices), num, replace = False)] # 随机选择一定比例的非零元素
    train = matrix.copy() # 复制矩阵，作为训练集
    for row, col in selected:
        train[row][col] = 0
    positions = selected.tolist() # 记录测试集的位置
    return train,positions

def probe_rmse(matrix,users,movies,positions):
    """计算探测集的均方根误差

    Args:
        matrix (ndarray): 用户-电影评分矩阵
        users (ndarray): 用户-因子矩阵
        movies (ndarray): 电影-因子矩阵
        positions (list): 探测集的位置

    Returns:
        RMSE: 均方根误差
    """
    predict = np.dot(users.T,movies)
    error = 0
    for row, col in positions:
        error += (predict[row][col] - matrix[row][col])**2
    rmse = np.sqrt(error/len(positions))
    
    return rmse
