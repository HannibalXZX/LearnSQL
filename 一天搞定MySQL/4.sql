########################################
# 一天搞定MySQL
# https://mp.weixin.qq.com/s/5EsOhmyPRUpAUk9Sh4NMkg
# 时间：2020年06月29日20:50:36
########################################

## 多段排序
# 以 class 和 birthday 从大到小的顺序查询 student 表。
SELECT * FROM student ORDER BY class DESC, birthday DESC;

## 子查询 - 5
# 查询 "男" 教师及其所上的课程。
SELECT * FROM course WHERE t_no IN (
SELECT no FROM teacher WHERE sex = '男');

## MAX 函数与子查询
# 查询最高分同学的 score 表
# 笛卡尔积 204行 = 12 * 17
SELECT COUNT(*) FROM student,score;

SELECT * FROM student,score WHERE s_no = no AND s_no IN (
SELECT s_no FROM score WHERE degree = (
SELECT MAX(degree) FROM score));

## 子查询 - 6
# 查询和 "李军" 同性别的所有同学 name
select name from student where sex = (
SELECT sex FROM student where name='李军');

## 子查询 - 7
# 查询和 "李军" 同性别且同班的同学 name 。
SELECT name, sex, class FROM student WHERE sex = (
    SELECT sex FROM student WHERE name = '李军'
) AND class = (
    SELECT class FROM student WHERE name = '李军'
);

## 子查询 - 8
# 查询所有选修 "计算机导论" 课程的 "男" 同学成绩表
SELECT name, degree FROM student,score WHERE no = s_no AND sex = '男' AND c_no = (
SELECT no FROM course WHERE name = "计算机导论");

SELECT * FROM score WHERE c_no = (
    SELECT no FROM course WHERE name = '计算机导论'
) AND s_no IN (
    SELECT no FROM student WHERE sex = '男'
);
