import pandas as pd


def dataset(movies_num):
    movie_path = list()
    # 提取电影信息
    movie = pd.read_csv('./推荐系统数据集/movie_titles.txt', header=None,nrows=movies_num)
    movie.columns=["Movie ID","Year","Name"]
    movie.to_csv("电影信息.csv")
    # 提取用户-电影信息
    for i in range(1,movies_num+1):
        s = 7-len(str(i))
        path = "./推荐系统数据集/training_set" + "/" + "mv_" + "0"*s + str(i) + ".txt"
        movie_path.append(path)

    user = pd.DataFrame(data=0, index=range(1,2649430), columns=range(1,movies_num+1))
    rank = 0
    for path in movie_path:
        movie = pd.read_csv(path, header=None, skiprows=1)
        for i in range(0,len(movie)):
            user.iloc[movie.iloc[i,0]-1,rank] = movie.iloc[i,1]
        rank = rank +1
    user = user.loc[(user!=0).any(axis=1)]
    user.index = [i for i in range(1,len(user)+1)]
    user.to_csv("用户-电影评分.csv")
    return 0
