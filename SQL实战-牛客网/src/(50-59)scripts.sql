###########################################
# intro: 牛客网中的SQL实战 50-59 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-10
############################################

### 题号查找：ex_题号

########
# ex_50、将employees表中的所有员工的last_name和first_name通过
# (')连接起来。(不支持concat，请用||实现)

SELECT last_name || "'" || first_name FROM employees;

########
# ex_51、查找字符串'10,A,B' 中逗号','出现的次数cnt。
# (')连接起来。(不支持concat，请用||实现)

SELECT 2 AS cnt
-- 即先用replace函数将原串中出现的子串用空串替换，再用原串长度减去替换后字符串的长度
SELECT LENGTH('10,A,B') - LENGTH(REPLACE('10,A,B',",",""))
-- 针对中文
select char_length('A,10,B')- char_length(replace('10,A,B',',',''));


-- 新思路：Hive SQL语法支持 mysql 不通过
-- 首先根据split函数将目标字符串按照逗号进行切分，得到的结果是一个数组，然后求出数组元素的个数，减去1就是逗号的个数。
SELECT size(split('10,A,B', ',')) - 1 ;

#######
# ex_52、获取Employees中的first_name，查询按照first_name最后两个字母，按照升序进行排列

-- mysql 如果是单个字母就返回单个字母
SELECT first_name FROM employees ORDER BY RIGHT(first_name, 2);
SELECT first_name FROM employees ORDER BY SUBSTR(first_name, -2);


#######
# ex_53、按照dept_no进行汇总，属于同一个部门的emp_no按照逗号进行连接，结果给出dept_no以及连接出的结果employees
# group_concat(X,Y)，其中X是要连接的字段，Y是连接时用的符号，可省略，默认为逗号。此函数必须与 GROUP BY 配合使用

SELECT dept_no, GROUP_CONCAT(emp_no) employees
FROM dept_emp GROUP BY dept_no;

-- 以空格相连
SELECT GROUP_CONCAT(emp_no SEPARATOR' ')
FROM dept_emp GROUP BY dept_no;

#######
# ex_54、查找排除最大、最小salary之后的当前(to_date = '9999-01-01' )员工的平均工资avg_salary。

SELECT AVG(salary) avg_salary FROM salaries
WHERE salary NOT IN (
SELECT MAX(salary) FROM salaries WHERE to_date='9999-01-01'
UNION
SELECT MIN(salary) FROM salaries WHERE to_date='9999-01-01')
AND to_date = '9999-01-01'

SELECT AVG(salary) AS avg_salary FROM salaries
WHERE to_date = '9999-01-01'
AND salary NOT IN (SELECT MAX(salary) FROM salaries WHERE to_date = '9999-01-01')
AND salary NOT IN (SELECT MIN(salary) FROM salaries WHERE to_date = '9999-01-01')

# ex_55、分页查询employees表，每5行一页，返回第2页的数据

SELECT * FROM employees LIMIT 5 OFFSET 5

SELECT * FROM employees LIMIT 5,5;

# ex_56、获取所有员工的emp_no、部门编号dept_no以及对应的bonus类型btype和received
# 没有分配奖金的员工不显示对应的bonus类型btype和received
SELECT e.emp_no, d.dept_no, btype, received
FROM employees e LEFT JOIN
emp_bonus eb ON e.emp_no = eb.emp_no
INNER JOIN dept_emp d ON
e.emp_no = d.emp_no

# ex_57、使用含有关键字exists查找未分配具体部门的员工的所有信息。

-- 错误解法
-- EXISTS 返回的是bool语句，SELECT emp_no FROM dept_emp 有记录，肯定是为真值，
-- 立即推，NOT EXISTS 为假，即返回结果为空。
SELECT * FROM employees WHERE
NOT exists (SELECT emp_no FROM dept_emp)

-- 正确解法 employees 与 子句 中的emplyees 建立了关联。
SELECT * FROM employees WHERE NOT EXISTS
(SELECT emp_no FROM dept_emp WHERE emp_no = employees.emp_no)

-- 建立内外关联
SELECT b.emp_no FROM employees b
WHERE  EXISTS  (SELECT emp_no FROM dept_emp WHERE b.emp_no=emp_no)

-- 没有建立内外关联，等价于：SELECT b.emp_no FROM employees b
SELECT b.emp_no FROM employees b
WHERE  EXISTS  (SELECT emp_no FROM dept_emp)

# ex_58、create view emp_v as select * from employees where emp_no >10005;
# 获取employees中的行数据，且这些行也存在于emp_v中。注意不能使用intersect关键字。

SELECT * FROM emp_v