###########################################
# intro: 牛客网中的SQL实战 20-29 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-06
############################################


### 题号查找：ex_题号

########
# ex_20、查找员工编号emp_no为10001其自入职以来的薪水salary涨幅
# (总共涨了多少)growth(可能有多次涨薪，没有降薪)

SELECT (maxS - minS) growth
FROM
(SELECT MAX(salary) maxS  FROM salaries WHERE emp_no=10001) s1,
(SELECT MIN(salary) minS FROM salaries WHERE emp_no=10001) s2

SELECT MAX(salary)-MIN(salary) AS growth FROM salaries
WHERE emp_no='10001';

-- 最后一次工资记录减去第一次工资记录得到入职以来salary的涨幅
SELECT (
(SELECT salary FROM salaries
WHERE emp_no = 10001 ORDER BY to_date DESC LIMIT 1) -
(SELECT salary FROM salaries
WHERE emp_no = 10001 ORDER BY to_date ASC LIMIT 1)
) AS growth


########
# ex_21、查找所有员工自入职以来的薪水涨幅情况
# 给出员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序

-- 当前薪水 - 入职薪水
SELECT csalary.emp_no, csalary.salary-hsalary.salary growth
FROM (
SELECT e.emp_no, s.salary
FROM employees e INNER JOIN salaries s
ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01') AS csalary
INNER JOIN
(SELECT e.emp_no, s.salary
FROM employees e INNER JOIN salaries s
ON e.emp_no = s.emp_no
WHERE s.from_date = e.hire_date) AS hsalary
ON csalary.emp_no = hsalary.emp_no
ORDER BY growth

-- 简洁写法
SELECT a.emp_no, (b.salary - c.salary) growth
FROM
    employees a
    INNER JOIN salaries b
    ON a.emp_no = b.emp_no AND b.to_date = '9999-01-01'
    INNER JOIN salaries c
    ON a.emp_no = c.emp_no AND a.hire_date = c.from_date
ORDER BY growth ASC

########
# ex_22、 统计各个部门的工资记录数，给出部门编码dept_no、部门名称dept_name以及部门在salaries表里面有多少条记录sum
SELECT d.dept_no, d.dept_name, COUNT(s.salary) AS sum
FROM salaries s INNER JOIN
dept_emp de ON s.emp_no = de.emp_no
INNER JOIN departments d
ON d.dept_no = de.dept_no
GROUP BY d.dept_no

--1、用INNER JOIN连接dept_emp表和salaries表，并以dept_emp.no分组，统计每个部门所有员工工资的记录总数
--2、再将上表用INNER JOIN连接departments表，限制条件为两表的dept_no相等，找到dept_no与dept_name的对应关系，最后依次输出dept_no、dept_name、sum
SELECT de.dept_no, dp.dept_name, COUNT(s.salary) AS sum
FROM (dept_emp AS de
INNER JOIN salaries AS s ON de.emp_no = s.emp_no)
INNER JOIN departments AS dp ON de.dept_no = dp.dept_no
GROUP BY de.dept_no



SELECT emp_no,salary,
@rank := @rank + (@pre <> (@pre := salary)) Rank
FROM salaries, (SELECT @rank := 0, @pre := -1) INIT
WHERE to_date = '9999-01-01
group by emp_no
order by salary

########
# ex_23、对所有员工的当前(to_date='9999-01-01')薪水按照salary进行按照1-N的排名，相同salary并列且按照emp_no升序排列

-- as rank 在Natviat报错！
SELECT a.salary, COUNT(b.salary)
FROM salaries a
(SELECT s.salary FROM salaries s
WHERE s.to_date='9999-01-01'
GROUP BY s.salary ORDER BY s.salary DESC) as b
WHERE a.salary <= b.salary
AND a.to_date='9999-01-01'
AND c.salary = a.salary
GROUP BY a.salary

SELECT s1.emp_no, s1.salary, COUNT(DISTINCT s2.salary)
AS rk
FROM salaries AS s1, salaries AS s2
WHERE s1.to_date = '9999-01-01'
AND s2.to_date = '9999-01-01'
AND s1.salary <= s2.salary
GROUP BY s1.emp_no, s1.salary
ORDER BY s1.salary DESC, s1.emp_no ASC

-- error
SELECT a.emp_no, a.salary,d.rank
FROM salaries a LEFT JOIN
    (
		  SELECT b.salary, COUNT(c.salary) rank FROM
		  salaries b, (
		               SELECT s.salary FROM salaries s
								   WHERE s.to_date='9999-01-01'
								   GROUP BY s.salary ) AS c
		  WHERE b.salary <= c.salary
		  AND b.to_date='9999-01-01'
			GROUP BY b.salary) AS d
ON a.salary = d.salary WHERE to_date = '9999-01-01'
ORDER BY d.rank,a.emp_no

-- 进阶：窗口函数
select emp_no, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking
FROM salaries
WHERE to_date = '9999-01-01'
ORDER BY salary DESC, emp_no ASC

########
# ex_24、获取所有非manager员工当前的薪水情况
# 给出dept_no、emp_no以及salary ，当前表示to_date='9999-01-01'
SELECT dept_emp.dept_no, salaries.emp_no, salaries.salary
FROM dept_emp, salaries
WHERE dept_emp.emp_no NOT IN (
SELECT emp_no FROM dept_manager
)
AND salaries.to_date = "9999-01-01"
AND dept_emp.emp_no = salaries.emp_no


########
# ex_25、获取员工其当前的薪水比其manager当前薪水还高的相关信息，当前表示to_date='9999-01-01',
# 这种场景，最重要的是学会拆分，把复杂的查询分成一个个简单的查询，最后再将其组合在一起，这便是分合的思想。

# 1、先查出员工的工号和薪水：
SELECT de.emp_no,sa.salary FROM dept_emp de,salaries sa
WHERE de.emp_no=sa.emp_no
AND de.to_date='9999-01-01'
AND sa.to_date='9999-01-01'

# 2、再查出经理的工号和薪水：
SELECT dm.emp_no manager_no,sal.salary FROM dept_manager dm,salaries sal
WHERE dm.emp_no=sal.emp_no
AND dm.to_date='9999-01-01'
AND sal.to_date='9999-01-01'

# 3、接着就是组合，看准条件，做好条件衔接：
SELECT de.emp_no,dm.emp_no manager_no,
sa.salary emp_salary,sal.salary manager_salary
FROM dept_emp de,salaries sa,dept_manager dm,salaries sal
WHERE de.emp_no=sa.emp_no
AND dm.emp_no=sal.emp_no
AND de.dept_no=dm.dept_no
AND de.to_date='9999-01-01'
AND sa.to_date='9999-01-01'
AND dm.to_date='9999-01-01'
AND sal.to_date='9999-01-01'
AND sa.salary>sal.salary


SELECT sem.emp_no AS emp_no, sdm.emp_no AS manager_no, sem.salary AS emp_salary, sdm.salary AS manager_salary
FROM (
    SELECT s.salary, s.emp_no, de.dept_no FROM salaries s
    INNER JOIN dept_emp de
    ON s.emp_no = de.emp_no AND s.to_date = '9999-01-01' ) AS sem,
    (
    SELECT s.salary, s.emp_no, dm.dept_no FROM salaries s
    INNER JOIN dept_manager dm
    ON s.emp_no = dm.emp_no AND s.to_date = '9999-01-01' ) AS sdm
WHERE sem.dept_no = sdm.dept_no AND sem.salary > sdm.salary

########
# ex_26、汇总各个部门当前员工的title类型的分配数目
# 即结果给出部门编号dept_no、dept_name、其部门下所有的当前(dept_emp.to_date = '9999-01-01')
# 员工的当前(titles.to_date = '9999-01-01')title以及该类型title对应的数目count

SELECT d.dept_no, d.dept_name, t.title, COUNT(t.title)
FROM dept_emp INNER JOIN titles t
ON dept_emp.emp_no = t.emp_no
INNER JOIN departments d ON
dept_emp.dept_no = d.dept_no
WHERE dept_emp.to_date = '9999-01-01'
AND t.to_date = '9999-01-01'
GROUP BY d.dept_no, t.title


#######
# ex_27 给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
## 题意含糊不清

-- 正确解法
SELECT s2.emp_no, s2.from_date, (s2.salary - s1.salary) AS salary_growth
FROM salaries AS s1, salaries AS s2
WHERE s1.emp_no = s2.emp_no
AND salary_growth > 5000
AND (strftime("%Y",s2.to_date) - strftime("%Y",s1.to_date) = 1
     OR strftime("%Y",s2.from_date) - strftime("%Y",s1.from_date) = 1 )
ORDER BY salary_growth DESC


#######
# ex_28 给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
## 题意含糊不清
