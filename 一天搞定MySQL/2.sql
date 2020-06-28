# 分组计算平均成绩
# 查询每门课的平均成绩

SELECT degree,c_no FROM score;

-- AVG: 平均值
SELECT AVG(degree) FROM score WHERE c_no = '3-105';
SELECT AVG(degree) FROM score WHERE c_no = '3-245';
SELECT AVG(degree) FROM score WHERE c_no = '6-166';

-- GROUP BY: 分组查询
SELECT c_no, AVG(degree) FROM score GROUP BY c_no;

select * from score;

SELECT c_no, MAX(degree)  FROM score GROUP BY c_no;

# 分组条件与模糊查询
# 查询score表中至少有 2 名学生选修，并以 3 开头的课程的平均分数

## 分解：1、查询score表中学生的选修的平均分数
SELECT c_no, AVG(degree) FROM score GROUP BY c_no;

## 分解：2、 查询至少有2名学生的选修课程
SELECT c_no, COUNT(c_no) FROM score GROUP BY c_no HAVING COUNT(c_no) >= 2;

## 分解：3、以3开头的课程
-- LIKE 表示模糊查询，"%" 是一个通配符，匹配 "3" 后面的任意字符。
SELECT c_no FROM score GROUP BY c_no HAVING c_no LIKE '3%';

## 合并后的答案！
SELECT c_no, AVG(degree), COUNT(*) FROM score GROUP BY c_no HAVING COUNT(c_no) >=2 AND c_no LIKE '3%';

## 多表查询 - 1
# 查询所有学生的name，以及该学生在score表中对应的c_no和degree
SELECT name, c_no, degree FROM student,score WHERE student.no = score.s_no;

## 多表查询 - 2
# 查询所有学生的 no 、课程名称 ( course 表中的 name ) 和成绩 ( score 表中的 degree ) 列。
SELECT s_no, course.name, degree FROM course, score
WHERE score.c_no = course.no;

## 三表关联查询
# 查询所有学生的 name 、课程名 ( course 表中的 name ) 和 degree
SELECT student.name as s_name, course.name as c_name, degree FROM student, course, score
WHERE student.no = score.s_no AND score.c_no = course.no;

## GROUP BY子句必须出现在WHERE子句之后，ORDER BY子句之前.
## HAVING语句必须在ORDER BY子句之后。（where先执行，再groupby分组；groupby先分组，having再执行。）

## 子查询加分组求平均分
# 查询95031班学生每门课程的平均成绩
# 在score表中根据student表的学生编号筛选出学生的课堂号和成绩：
SELECT c_no, AVG(degree) FROM score
WHERE s_no IN (SELECT no FROM student WHERE class = '95031')
GROUP BY c_no;

# 查询95031班的每名学生的所有课程的平均成绩
SELECT student.name, s_no, class, AVG(degree) FROM student, score
WHERE student.no = score.s_no AND class = '95031'  GROUP BY s_no;

## 子查询
# 查询在 3-105 课程中，所有成绩高于 109 号同学的记录
SELECT * FROM score
WHERE c_no = '3-105'
AND degree > (
SELECT degree FROM score
WHERE s_no = "109" AND c_no ="3-105");

## YEAR 函数与带 IN 关键字查询
# 查询所有和 101 、108 号学生同年出生的 no 、name 、birthday 列。
SELECT no, name, birthday FROM student
WHERE YEAR(birthday) IN(
SELECT YEAR(birthday) FROM student
WHERE no IN (101, 108));

## 多层嵌套子查询
# 查询 '张旭' 教师任课的学生成绩表。
SELECT * FROM score
WHERE c_no=(
SELECT no FROM course
WHERE t_no=(
SELECT no FROM teacher WHERE name = '张旭'));

## 多表查询
# 查询某选修课程多于5个同学的教师姓名。
SELECT teacher.name, t_no FROM score, teacher, course
WHERE teacher.no = course.t_no AND course.no = score.c_no
GROUP BY t_no HAVING COUNT(*) > 5;

SELECT t_no FROM course WHERE no IN (
SELECT c_no FROM score GROUP BY c_no HAVING COUNT(*) >5);

## 子查询 - 3
# 查询 “计算机系” 课程的成绩表。
SELECT * FROM score
WHERE c_no IN (
SELECT no FROM course
WHERE t_no IN (
SELECT no FROM teachber
WHERE department='计算机系'));
