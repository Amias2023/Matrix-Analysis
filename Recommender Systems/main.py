import pandas as pd
import numpy as np
from optimize import *
from probe import *
from dataset import *


def main(matrix,factors,num):
    users, movies = optimize_SGD(matrix,factors,1,0.02,1000)
    rmse = optimize_RMSE(matrix,users,movies)
    print("SGD方法的RMSE: ",rmse)
    return 0


if __name__=="__main__":
    dataset(10)
    dataset = pd.read_csv("用户-电影评分.csv",index_col=0,header=0)
    matrix = dataset.to_numpy()
    main(matrix,2,10)
    