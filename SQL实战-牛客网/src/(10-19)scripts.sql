###########################################
# intro: 牛客网中的SQL实战 10-19 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-04
############################################

### 题号查找：ex_题号

########
# ex_10、查找最晚入职员工的所有信息
# 获取所有非manager的员工emp_no

-- IN
SELECT emp_no FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

-- LEFT JOIN 【推荐】
SELECT employees.emp_no FROM employees
LEFT JOIN dept_manager ON
employees.emp_no = dept_manager.emp_no
WHERE dept_manager.emp_no is NULL;


########
# ex_11、获取所有员工当前的(dept_manager.to_date='9999-01-01')manager，
# 如果员工是manager的话不显示(也就是如果当前的manager是自己的话结果不显示)。
# 输出结果第一列给出当前员工的emp_no,第二列给出其manager对应的emp_no。

SELECT dept_emp.emp_no AS emp_no, dept_manager.emp_no AS manager_no
FROM dept_emp, dept_manager
WHERE dept_emp.dept_no = dept_manager.dept_no
AND dept_manager.to_date='9999-01-01'
AND dept_emp.emp_no <> dept_manager.emp_no;

-- 更为严谨
SELECT dept_emp.emp_no AS emp_no, dept_manager.emp_no AS manager_no
FROM dept_emp INNER JOIN dept_manager
ON dept_emp.dept_no = dept_manager.dept_no
WHERE dept_manager.to_date='9999-01-01'
AND dept_manager.to_date='9999-01-01'
AND dept_emp.emp_no <> dept_manager.emp_no;

#######
# ex_12、获取所有部门中当前(dept_emp.to_date = '9999-01-01')员工
# 当前(salaries.to_date='9999-01-01')薪水最高的相关信息
# 给出dept_no, emp_no以及其对应的salary

# 强调了所有，必须加group by，要不然就是某一个部门的最高的成绩

-- 该题测试用例和判断都有问题
SELECT currentsalary.dept_no, currentsalary.emp_no, currentsalary.salary AS salary
FROM
-- 创建maxsalary表用于存放当前每个部门薪水的最大值
(SELECT d.dept_no, MAX(s.salary) AS salary
FROM salaries AS s INNER JOIN dept_emp As d
ON d.emp_no = s.emp_no
WHERE d.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY d.dept_no) AS maxsalary,
-- 创建currentsalary表用于存放当前每个部门所有员工的编号和薪水
(SELECT d.dept_no, s.emp_no, s.salary
FROM salaries AS s INNER JOIN dept_emp As d
ON d.emp_no = s.emp_no
WHERE d.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
) AS currentsalary
-- 限定条件为两表的dept_no和salary均相等
WHERE currentsalary.dept_no = maxsalary.dept_no
AND currentsalary.salary = maxsalary.salary
-- 最后以currentsalary.dept_no排序输出符合要求的记录表
ORDER BY currentsalary.dept_no

### 自己手写
uSELECT current_salary.dept_no, current_salary.emp_no, current_salary.salary
FROM
( SELECT dept_emp.dept_no, MAX(salaries.salary) msalary
 FROM dept_emp INNER JOIN salaries
ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date = '9999-01-01'
AND salaries.to_date='9999-01-01'
GROUP BY dept_emp.dept_no
) AS max_salary,
( SELECT dept_emp.dept_no, dept_emp.emp_no, salaries.salary
 FROM dept_emp INNER JOIN salaries
ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date = '9999-01-01'
AND salaries.to_date='9999-01-01'
) AS current_salary
WHERE
current_salary.dept_no =  max_salary.dept_no
AND
current_salary.salary = max_salary.msalary
ORDER BY current_salary.dept_no;ohs

#######
# ex_13、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t
SELECT title, COUNT(title) AS t FROM titles
GROUP BY title HAVING t >= 2 ;

#######
# ex_14、从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
# 注意对于重复的emp_no进行忽略(即emp_no重复的title不计算，title对应的数目t不增加)。

-- where和having的不同之处在于，where是查找之前的限定，而having是查找之后。
SELECT title, COUNT(DISTINCT emp_no) AS t FROM titles
GROUP BY title HAVING t >= 2;

-- 更好理解的方法
SELECT title, COUNT(title) AS t FROM(
SELECT DISTINCT emp_no,title FROM titles) AS temp
GROUP BY title HAVING t >= 2;

#######
# ex_15、查找employees表所有emp_no为奇数，且last_name不为Mary(注意大小写)的员工信息，
# 并按照hire_date逆序排列(题目不能使用mod函数)

-- 使用mod函数
SELECT * FROM employees
WHERE last_name <> 'Mary'
AND MOD(emp_no,2) <> 0
ORDER BY hire_date DESC;

-- 不使用mod函数
SELECT * FROM employees
WHERE last_name <> 'Mary'
AND emp_no % 2 <> 0
ORDER BY hire_date DESC;

-- 使用位运算
SELECT * FROM employees
WHERE last_name <> 'Mary'
AND emp_no & 1 = 1
ORDER BY hire_date DESC;

#######
# ex_16、查找employees表所有emp_no为奇数，且last_name不为Mary(注意大小写)的员工信息，
# 并按照hire_date逆序排列(题目不能使用mod函数)
SELECT titles.title,AVG(salaries.salary)
FROM titles INNER JOIN salaries
ON titles.emp_no = salaries.emp_no
WHERE titles.to_date='9999-01-01'
AND salaries.to_date='9999-01-01'
GROUP BY titles.title

#######
# ex_17、获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
SELECT emp_no, salary
FROM salaries
WHERE  to_date = '9999-01-01'
AND salary = (
SELECT salary FROM salaries
WHERE to_date = '9999-01-01'
GROUP by salaries.salary ORDER BY salary DESC LIMIT 1, 1);

SELECT emp_no, salary FROM salaries
WHERE to_date = '9999-01-01' AND salary = (
SELECT DISTINCT salary FROM salaries
ORDER BY salary DESC limit 1,1)

#######
# ex_18、查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、last_name以及first_name
# 你可以不使用order by完成吗

-- 使用两个MAX求第二高
SELECT employees.emp_no, salary, employees.last_name, employees.first_name
FROM salaries INNER JOIN employees ON
employees.emp_no = salaries.emp_no
WHERE to_date='9999-01-01'
AND salary = (
               SELECT MAX(salary) FROM salaries
               WHERE to_date='9999-01-01'
               AND salary < (
                              SELECT MAX(salary) FROM salaries
                              WHERE to_date='9999-01-01'));

-- 通用求任意高
SELECT employees.emp_no, salary, employees.last_name, employees.first_name
FROM salaries INNER JOIN employees ON
employees.emp_no = salaries.emp_no
WHERE to_date='9999-01-01'
AND salary = (
               SELECT s1.salary FROM salaries s1
               INNER JOIN salaries s2 ON
               s1.salary <= s2.salary
               AND s1.to_date='9999-01-01'
               AND s2.to_date='9999-01-01'
               GROUP BY s1.salary
               HAVING COUNT(DISTINCT s2.salary) = 2
)

#######
# ex_19、查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工

SELECT e.last_name, e.first_name, d.dept_name
FROM employees e LEFT JOIN
dept_emp de ON e.emp_no = de.emp_no
LEFT JOIN departments d ON
de.dept_no = d.dept_no