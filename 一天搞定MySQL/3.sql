########################################
# 一天搞定MySQL
# https://mp.weixin.qq.com/s/5EsOhmyPRUpAUk9Sh4NMkg
# 时间：2020年06月29日20:50:36
########################################

## UNION 和 NOT IN 的使用
# 查询计算机系与电子工程系中的不同职称的教师。
SELECT * FROM teacher WHERE department = '计算机系'
AND profession NOT IN(
SELECT profession FROM  teacher WHERE department = '电子工程系')
UNION
SELECT * FROM teacher WHERE department = '电子工程系'
AND profession NOT IN(
SELECT profession FROM  teacher WHERE department = '计算机系');

## ANY 表示至少一个 - DESC ( 降序 )
# 查询课程 3-105 且成绩 至少 高于 3-245 的 score 表。
SELECT * FROM score WHERE c_no = "3-105"
AND degree > (
SELECT MIN(degree) FROM score
WHERE c_no = "3-245");

SELECT * FROM score WHERE c_no = '3-105'
AND degree > ANY(
    SELECT degree FROM score WHERE c_no = '3-245'
) ORDER BY degree DESC;

## 表示所有的 ALL
# 查询课程 3-105 且成绩高于 3-245 的 score 表。
SELECT * FROM score WHERE c_no = "3-105"
AND degree > (
SELECT MAX(degree) FROM score
WHERE c_no = "3-245");

SELECT * FROM score WHERE c_no = '3-105'
AND degree > ALL(
    SELECT degree FROM score WHERE c_no = '3-245'
) ORDER BY degree DESC;

## 复制表的数据作为条件查询
# 查询某课程成绩比该课程平均成绩低的score表。
SELECT * FROM score a WHERE degree<(
SELECT AVG(degree) FROM score b WHERE a.c_no=b.c_no GROUP BY c_no);

## 子查询 - 4
# 查询所有任课 ( 在 course 表里有课程 ) 教师的 name 和 department
SELECT name, department FROM teacher WHERE no IN (SELECT t_no FROM course);

## 条件加组筛选
## 查询 student 表中至少有 2 名男生的 class
SELECT * FROM student WHERE sex = '男' AND class in(
SELECT class FROM student WHERE sex = '男' GROUP BY class having COUNT(class)>=2);

## NOT LIKE 模糊查询取反
# 查询 student 表中不姓 "王" 的同学记录。
-- NOT: 取反
-- LIKE: 模糊查询
SELECT * FROM student WHERE name NOT LIKE '王%';

## YEAR 与 NOW 函数
# 查询 student 表中每个学生的姓名和年龄
SELECT name, YEAR(now())-YEAR(birthday) AS age
FROM student;

## MAX 与 MIN 函数
# 查询 student 表中最大和最小的 birthday 值
SELECT MAX(birthday), MIN(birthday) FROM student;