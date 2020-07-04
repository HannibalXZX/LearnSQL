CREATE DATABASE nowcoder;
USE nowcoder;

-- 员工表
-- 表名不能给复数
CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,          -- '员工编号'
`birth_date` date NOT NULL,         -- '生日'
`first_name` varchar(14) NOT NULL,  -- '名'
`last_name` varchar(16) NOT NULL,   -- '姓'
`gender` char(1) NOT NULL,          -- '性别'
`hire_date` date NOT NULL,          -- '入职日期'
PRIMARY KEY (`emp_no`)
);

-- 薪水表
-- 表名不能给复数
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,   -- '员工编号',
`salary` int(11) NOT NULL,   -- '薪水'
`from_date` date NOT NULL,   -- '开始发放薪水的日期'
`to_date` date NOT NULL,     -- '当前所获得的薪水日期'
PRIMARY KEY (`emp_no`,`from_date`));

-- 部门表
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL, -- '部门编号'
`emp_no` int(11) NOT NULL, --  '员工编号'
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));

-- 员工数据插入
INSERT INTO employees VALUES(1,'1983-01-02','Lebron','James','F','2020-5-2');
INSERT INTO employees VALUES(2,'1983-01-03','Michael','Jordan','F','2020-5-2');
INSERT INTO employees VALUES(3,'1983-01-04','Kobe','Bryant','F','2020-5-10');
INSERT INTO employees VALUES(4,'1983-01-05','Stephen','Curry','F','2020-5-10');
INSERT INTO employees VALUES(5,'1983-01-06','Tim','Duncan','F','2020-5-21');
INSERT INTO employees VALUES(6,'1983-01-07','Allen','Inverson','F','2020-5-21');
INSERT INTO employees VALUES(7,'1983-01-08','Kevin','Durant','F','2020-5-21');
INSERT INTO employees VALUES(8,'1983-01-09','Kevin','Love','F','2020-5-25');
INSERT INTO employees VALUES(9,'1983-01-10','Kaly','Thompson','F','2020-5-25');
INSERT INTO employees VALUES(10,'1983-01-10','John','Wall','F','2020-6-1');
INSERT INTO employees VALUES(11,'1983-01-11','Damian','Lillard','F','2020-6-1');
INSERT INTO employees VALUES(12,'1983-01-11','Ming','Yao','F','2020-6-3')

-- 薪水表
## 刚入职的薪水
INSERT INTO salaries VALUES(1,14000000,'2020-05-02','2023-05-12');
INSERT INTO salaries VALUES(2,10000000,'2020-05-02','2023-05-12');
INSERT INTO salaries VALUES(3,12000000,'2020-05-10','2023-05-20');
INSERT INTO salaries VALUES(4,18000000,'2020-05-10','2020-05-20');
INSERT INTO salaries VALUES(5,19000000,'2020-05-21','2020-06-01');
INSERT INTO salaries VALUES(6,13333333,'2020-05-21','2020-06-01');

## 涨薪一次后的薪水
INSERT INTO salaries VALUES(1,34000000,'2023-05-12','9999-01-01');
INSERT INTO salaries VALUES(2,20000000,'2023-05-12','2025-01-01');
INSERT INTO salaries VALUES(3,32000000,'2023-05-20','2026-04-01');
INSERT INTO salaries VALUES(4,28000000,'2020-05-20','2024-01-01');
INSERT INTO salaries VALUES(5,29000000,'2020-06-01','2038-01-01');
INSERT INTO salaries VALUES(6,33333333,'2020-06-01','2023-02-01');

## 涨薪和降薪
INSERT INTO salaries VALUES(2,30000000,'2025-01-01','2028-01-01');
INSERT INTO salaries VALUES(2,40000000,'2028-01-01','2033-01-01');
INSERT INTO salaries VALUES(2,30000000,'2033-01-01','2035-01-01');
INSERT INTO salaries VALUES(2,20000000,'2035-01-01','2036-01-01');
INSERT INTO salaries VALUES(2,25000000,'2036-01-01','2037-01-01');



-- 部门输入插入
INSERT INTO dept_manager VALUES('SF',1,'9999-01-01');
INSERT INTO dept_manager VALUES('SG',2,'2030-04-01');
INSERT INTO dept_manager VALUES('SG',3,'2039-07-01');
INSERT INTO dept_manager VALUES('PG',4,'9999-01-01');
INSERT INTO dept_manager VALUES('PF',5,'2038-04-01');
INSERT INTO dept_manager VALUES('SG',6,'2040-05-01');
