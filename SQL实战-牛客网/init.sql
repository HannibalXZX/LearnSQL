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

-- 部门经理表
CREATE TABLE `dept_manager` (
`dept_no` char(4) NOT NULL, -- '部门编号'
`emp_no` int(11) NOT NULL, --  '经理编号'
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));

-- 部门员工表
CREATE TABLE `dept_emp` (
`emp_no` int(11) NOT NULL, -- '所有的员工编号'
`dept_no` char(4) NOT NULL, -- '部门编号'
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`dept_no`));

-- 员工数据插入

-- NBA
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

--官方
INSERT INTO employees VALUES(10001,'1953-09-02','Georgi','Facello','M','1986-06-26');
INSERT INTO employees VALUES(10002,'1964-06-02','Bezalel','Simmel','F','1985-11-21');
INSERT INTO employees VALUES(10003,'1959-12-03','Parto','Bamford','M','1986-08-28');
INSERT INTO employees VALUES(10004,'1954-05-01','Chirstian','Koblick','M','1986-12-01');
INSERT INTO employees VALUES(10005,'1955-01-21','Kyoichi','Maliniak','M','1989-09-12');
INSERT INTO employees VALUES(10006,'1953-04-20','Anneke','Preusig','F','1989-06-02');
INSERT INTO employees VALUES(10007,'1957-05-23','Tzvetan','Zielinski','F','1989-02-10');
INSERT INTO employees VALUES(10008,'1958-02-19','Saniya','Kalloufi','M','1994-09-15');
INSERT INTO employees VALUES(10009,'1952-04-19','Sumant','Peac','F','1985-02-18');
INSERT INTO employees VALUES(10010,'1963-06-01','Duangkaew','Piveteau','F','1989-08-24');
INSERT INTO employees VALUES(10011,'1953-11-07','Mary','Sluis','F','1990-01-22');

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


INSERT INTO salaries VALUES(10001,90000,'1986-06-26','1987-06-26');
INSERT INTO salaries VALUES(10001,88958,'2002-06-22','9999-01-01');
INSERT INTO salaries VALUES(10002,72527,'1996-08-03','1997-08-03');
INSERT INTO salaries VALUES(10002,72527,'2000-08-02','2001-08-02');
INSERT INTO salaries VALUES(10002,72527,'2001-08-02','9999-01-01');
INSERT INTO salaries VALUES(10003,90000,'1996-08-03','1997-08-03');

INSERT INTO salaries VALUES(10009,91234,'1997-08-03','9999-01-01');
INSERT INTO salaries VALUES(10010,95273,'1997-05-03','9999-01-01');

-- 部门输入插入
-- NBA
--INSERT INTO dept_manager VALUES('SF',1,'9999-01-01');
--INSERT INTO dept_manager VALUES('SG',2,'2030-04-01');
--INSERT INTO dept_manager VALUES('SG',3,'2039-07-01');
--INSERT INTO dept_manager VALUES('PG',4,'9999-01-01');
--INSERT INTO dept_manager VALUES('PF',5,'2038-04-01');
--INSERT INTO dept_manager VALUES('SG',6,'2040-05-01');

-- 官方
INSERT INTO dept_manager VALUES('d001',10002,'1996-08-03','9999-01-01');
INSERT INTO dept_manager VALUES('d002',10006,'1990-08-05','9999-01-01');
INSERT INTO dept_manager VALUES('d003',10005,'1989-09-12','9999-01-01');
INSERT INTO dept_manager VALUES('d004',10004,'1986-12-01','9999-01-01');
INSERT INTO dept_manager VALUES('d005',10010,'1996-11-24','2000-06-26');
INSERT INTO dept_manager VALUES('d006',10010,'2000-06-26','9999-01-01');

INSERT INTO dept_emp VALUES(10001,'d001','1986-06-26','9999-01-01');
INSERT INTO dept_emp VALUES(10002,'d001','1996-08-03','9999-01-01');
INSERT INTO dept_emp VALUES(10003,'d004','1995-12-03','9999-01-01');
INSERT INTO dept_emp VALUES(10004,'d004','1986-12-01','9999-01-01');
INSERT INTO dept_emp VALUES(10005,'d003','1989-09-12','9999-01-01');
INSERT INTO dept_emp VALUES(10006,'d002','1990-08-05','9999-01-01');
INSERT INTO dept_emp VALUES(10007,'d005','1989-02-10','9999-01-01');
INSERT INTO dept_emp VALUES(10008,'d005','1998-03-11','2000-07-31');
INSERT INTO dept_emp VALUES(10009,'d006','1985-02-18','9999-01-01');
INSERT INTO dept_emp VALUES(10010,'d005','1996-11-24','2000-06-26');
INSERT INTO dept_emp VALUES(10010,'d006','2000-06-26','9999-01-01');