###########################################
# intro: 牛客网中的SQL实战 60-61 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-11
############################################

### 题号查找：ex_题号

########
# ex_60、按照salary的累计和running_total，其中running_total为前N个当前( to_date = '9999-01-01')员工的salary累计和，
#  其他以此类推。 具体结果如下Demo展示。。

-- 第一感觉用窗口函数
SELECT emp_no, salary,
    SUM(salary) OVER (ORDER BY emp_no) as ruuning_total
FROM salaries WHERE to_date='9999-01-01';

-- 不用窗口函数
SELECT a.emp_no, a.salary, SUM(b.salary) running_total
FROM salaries a, salaries b
WHERE a.emp_no >= b.emp_no
AND a.to_date = '9999-01-01'
AND b.to_date = '9999-01-01'
GROUP BY a.emp_no, a.salary

-- 输出的第三个字段，是由一个 SELECT 子查询构成。将子查询内复用的 salaries 表记为 s2，主查询的 salaries 表记为 s1
-- 当主查询的 s1.emp_no 确定时，对子查询中不大于 s1.emp_no 的 s2.emp_no 所对应的薪水求和
SELECT s1.emp_no, s1.salary,
(
    SELECT SUM(s2.salary) FROM salaries AS s2
    WHERE s2.emp_no <= s1.emp_no
    AND s2.to_date = '9999-01-01'
)
    AS running_total
FROM salaries AS s1
WHERE s1.to_date = '9999-01-01'
ORDER BY s1.emp_no

########
# ex_61、对于employees表中，输出first_name排名(按first_name升序排序)为奇数的first_name
-- 为什么不用ORDER BY
-- 排名的时候用升序，而不是最后打出来的时候需要

-- 输出答案与 官网一致，但不通过OJ
SELECT a.first_name
FROM employees a, employees b
WHERE a.first_name >= b.first_name
GROUP BY a.first_name
HAVING COUNT(b.first_name) % 2 =1

-- 通过OJ系统
SELECT e1.first_name
FROM (
     SELECT e2.first_name,(
            SELECT COUNT(*) FROM employees AS e3
            WHERE e3.first_name <= e2.first_name
            )AS rowid
     FROM employees AS e2)
     AS e1
WHERE e1.rowid % 2 = 1

-- 窗口函数，使用了ORDER BY
SELECT first_name FROM employees
WHERE first_name IN (
      SELECT first_name ,row_number() OVER(
      ORDER BY first_name ASC) AS rank
      FROM employees WHERE rank%2=1)
ORDER BY first_name DESC