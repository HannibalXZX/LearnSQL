#############################
# 第3章 使用MySQL
#############################

show databases; -- 了解数据库，返回数据库列表

use crashcourse; -- 指定使用的数据库
show tables; -- 返回数据库内表的列表
show columns from customers; -- 查看customers表中的所有列设置
describe customers; -- 同上，查看customers表中的所有列设置

show status; -- 用于显示广泛的服务器状态信息
show create database crashcourse; -- 查看创建数据库crashcourse的mysql代码语句
show create table productnotes; -- 查看创建表productnotes表的mysql代码语句
show grants; -- 显示授予用户（所有用户或特定用户）的安全权限
show errors; -- 显示服务器错误内容
show warnings; -- 显示服务器警告内容

use mysql;
show tables;
show columns from user;
show create table user;