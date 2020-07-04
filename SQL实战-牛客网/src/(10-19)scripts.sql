###########################################
# intro: 牛客网中的SQL实战 1-9 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-04
############################################

########
# 10、查找最晚入职员工的所有信息
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
# 10、获取所有员工当前的(dept_manager.to_date='9999-01-01')manager，
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
# 11、获取所有部门中当前(dept_emp.to_date = '9999-01-01')员工
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

