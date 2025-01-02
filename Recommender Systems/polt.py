import csv
import matplotlib.pyplot as plt

# 读取电影特征CSV文件
features = []
with open('电影特征.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        features.append([float(value) for value in row])

# 读取电影信息CSV文件
movies = []
with open('电影信息.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    next(csvreader)  # 跳过表头
    for row in csvreader:
        movies.append(row[3])  # 获取电影名字

# 绘图
for i, movie in enumerate(movies):
    plt.scatter(features[0][i], features[1][i], label=movie)
    
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False
plt.xlabel('X轴')
plt.ylabel('Y轴')
plt.title('电影特征坐标绘图')
plt.legend()
plt.grid(True)
plt.show()