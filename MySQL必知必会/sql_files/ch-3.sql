#############################
# 第3章 使用MySQL
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
#############################

SHOW databases; -- 了解数据库，返回数据库列表

USE crashcourse; -- 指定使用的数据库
SHOW tables; -- 返回数据库内表的列表
SHOW columns from customers; -- 查看customers表中的所有列设置
describe customers; -- 同上，查看customers表中的所有列设置

SHOW status; -- 用于显示广泛的服务器状态信息
SHOW create database crashcourse; -- 查看创建数据库crashcourse的mysql代码语句
SHOW create table productnotes; -- 查看创建表productnotes表的mysql代码语句
SHOW grants; -- 显示授予用户（所有用户或特定用户）的安全权限
SHOW errors; -- 显示服务器错误内容
SHOW warnings; -- 显示服务器警告内容

USE mysql;
SHOW tables;
SHOW columns from USEr;
SHOW create table USEr;