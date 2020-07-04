###########################################
# intro: 牛客网中的SQL实战 1-9 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-04
############################################

########
# 1、查找最晚入职员工的所有信息
-- 仅限入职最晚日期只有1人
SELECT * FROM employees ORDER BY hire_date DESC LIMIT 1;

-- 入职最晚日期有多人
SELECT * FROM employees WHERE hire_date = (
SELECT MAX(hire_date) FROM employees);

########
# 2、查找入职员工时间排名倒数第三的员工所有信息
-- 只有1人, 此处存在问题，倒数一二日期可能存在多人！
SELECT * FROM employees ORDER BY hire_date DESC LIMIT 2,1;

-- 多人, 此处存在问题，倒数一二日期可能存在多人！
-- LIMIT m,n : 表示从第m+1条开始，取n条数据
-- LIMIT n ： 表示从第0条开始，取n条数据，是limit(0,n)的缩写
SELECT * FROM employees WHERE hire_date = (
SELECT hire_date FROM employees
ORDER BY hire_date DESC LIMIT 2,1);

-- 多人
SELECT * FROM employees WHERE hire_date = (
SELECT DISTINCT hire_date FROM employees
ORDER BY hire_date DESC LIMIT 2,1);

-- 参考网友
-- distinct效率不行，可以用group by去重，所以可以这么写：
SELECT * FROM employees WHERE hire_date = (
SELECT hire_date FROM employees
GROUP BY hire_date ORDER BY hire_date DESC limit 2,1)

########
# 3、查找各个部门当前(dept_manager.to_date='9999-01-01')领导
# 当前(salaries.to_date='9999-01-01')薪水详情以及其对应部门编号dept_no

-- 请以salaries表为主表进行查询，输出结果以salaries.emp_no升序排序
-- 并且请注意输出结果里面dept_no列是最后一列)

-- error
SELECT salaries.salary, dept_manager.dept_no FROM salaries, dept_manager
WHERE dept_manager.to_date='9999-01-01'
AND salaries.to_date='9999-01-01'
AND salaries.emp_no = dept_manager.emp_no
ORDER BY salaries.emp_no;

-- 注意输出结果
SELECT salaries.*, dept_manager.dept_no FROM salaries, dept_manager
WHERE dept_manager.to_date='9999-01-01'
AND salaries.to_date='9999-01-01'
AND salaries.emp_no = dept_manager.emp_no
ORDER BY salaries.emp_no;

-- 使用别名写法
SELECT s.*, d.dept_no FROM salaries AS s
JOIN dept_manager AS d ON
s.emp_no = d.emp_no
WHERE d.to_date='9999-01-01'
AND s.to_date='9999-01-01';

########
# 4、查找所有已经分配部门的员工的last_name和first_name以及dept_no
-- 请注意输出描述里各个列的前后顺序

# 答案是按employees表中顺序输出的，所以使用内连接查询时，必须将employees表放在前面。
-- 内连查询
SELECT e.last_name, e.first_name, d.dept_no
FROM employees AS e, dept_emp AS d
WHERE e.emp_no = d.emp_no;

-- 内连查询
SELECT last_name,first_name,dept_no
FROM employees,dept_emp
WHERE dept_emp.emp_no = employees.emp_no;

-- 左连查询
# employees中没有分配部门的员工（没有被记录在dept_emp表）
# dept_no字段被自动取NULL然后被输出，所以应当剔除（复合条件连接查询）。
SELECT last_name,first_name,dept_no
FROM employees LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
WHERE dept_emp.dept_no<>'';
#  <>''  等价于 IS NOT NULL

-- 优化左连接
SELECT last_name, first_name, dept_no
FROM dept_emp LEFT JOIN employees
ON employees.emp_no = dept_emp.emp_no;


########
# 5、查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括暂时没有分配具体部门的员工
-- (请注意输出描述里各个列的前后顺序)

SELECT last_name,first_name,dept_no
FROM employees LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no;


# 6、查找所有员工入职时候的薪水情况，给出emp_no以及salary
# 并按照emp_no进行逆序

SELECT employees.emp_no, salaries.salary
FROM employees, salaries 
WHERE employees.emp_no = salaries.emp_no
AND employees.hire_date = salaries.from_date
ORDER BY employees.emp_no DESC;

# 并列查询，等值联结
SELECT e.emp_no, s.salary
FROM employees e, salaries s
WHERE e.emp_no = s.emp_no
AND e.hire_date = s.from_date
ORDER BY e.emp_no DESC;

# 内连接查询
SELECT e.emp_no, s.salary
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no WHERE e.hire_date = s.from_date
ORDER BY e.emp_no DESC

# 不需要employee 错误写法 having 后面没有起作用，salary有多个。
SELECT emp_no,salary FROM salaries
GROUP BY emp_no having min(from_date)
ORDER BY emp_no DESC

# 不需要employee 牛客网没通过 不要太纠结
SELECT s.emp_no,s.salary
FROM salaries s
JOIN (SELECT emp_no, MIN(from_date)
AS min_date FROM salaries GROUP BY emp_no) t
ON s.emp_no = t.emp_no
AND s.from_date = t.min_date
ORDER BY s.emp_no DESC;

########
# 7、查找薪水【变动】超过15次的员工号emp_no以及其对应的变动次数t
-- 仅仅是薪水变动，包括涨幅和下降！
SELECT emp_no, COUNT(salary) as t
FROM salaries GROUP BY emp_no
HAVING t > 15;

-- 查找薪水【涨幅】超过15次的员工号emp_no以及其对应的变动次数t
-- 使用两个别名进行对比
-- 现实中a.to_date不一定等于b.from_date
SELECT a.emp_no, COUNT(a.salary) as t FROM salaries AS a
INNER JOIN salaries AS b
ON a.emp_no = b.emp_no
AND a.to_date = b.from_date
WHERE a.salary < b.salary
GROUP BY a.emp_no
HAVING t>15;

#######
# 8、找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况
# 对于相同的薪水只显示一次,并按照逆序显示

-- DISTINCT
SELECT DISTINCT salary FROM salaries
WHERE to_date='9999-01-01'
ORDER BY salary DESC

-- 大表一般用distinct效率不高，大数据量的时候都禁止用distinct
-- GROUP BY
SELECT salary FROM salaries
WHERE to_date='9999-01-01'
GROUP BY salary
ORDER BY salary DESC

#######
# 9、获取所有部门当前(dept_manager.to_date='9999-01-01')manager的当前(salaries.to_date='9999-01-01')薪水情况
# 给出dept_no, emp_no以及salary(请注意，同一个人可能有多条薪水情况记录)

SELECT dept_no, dept_manager.emp_no, salary
FROM dept_manager
INNER JOIN salaries ON
dept_manager.emp_no = salaries.emp_no
WHERE dept_manager.to_date='9999-01-01'
AND salaries.to_date='9999-01-01'