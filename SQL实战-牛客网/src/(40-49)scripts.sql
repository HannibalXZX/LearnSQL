###########################################
# intro: 牛客网中的SQL实战 40-49 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-09
############################################

### 题号查找：ex_题号

########
# ex_40、现在在last_update后面新增加一列名字为create_date,
# 类型为datetime, NOT NULL，默认值为'0000-00-00 00:00:00'

ALTER TABLE actor ADD create_date datetime NOT NULL
DEFAULT '0000-00-00 00:00:00'  ;


########
# ex_41、构造一个触发器audit_log，在向employees_test表中插入一条数据的时候，
# 触发插入相关的数据到audit中。

CREATE TRIGGER audit_log AFTER INSERT ON employees_test
FOR EACH ROW
BEGIN
INSERT INTO audit(EMP_no, NAME) VALUES(NEW.ID, NEW.NAME);
END

CREATE TRIGGER audit_log AFTER INSERT ON employees_test
FOR EACH ROW
BEGIN
INSERT INTO audit VALUES(NEW.ID,NEW.NAME);
END

-- INSERT INTO employees_test VALUES(1, 'test', 12, 'Beijing', 123.45)


########
# ex_42、删除emp_no重复的记录，只保留最小的id对应的记录。
# 触发插入相关的数据到audit中。
-- 正确答案，但mysql会报错
DELETE FROM titles_test
WHERE id NOT IN (
SELECT MIN(id) FROM titles_test
GROUP BY emp_no);

-- 正确mysql
DELETE FROM titles_test
WHERE id NOT IN (
    SELECT *
    FROM(
        SELECT MIN(id)
        FROM titles_test
        GROUP BY emp_no
) AS a);

-- 正向
DELETE FROM titles_test WHERE id IN (
    SELECT id FROM(
                SELECT a.id FROM titles_test a ,
                   (SELECT MIN(id) AS id,emp_no FROM titles_test
                    GROUP BY emp_no HAVING COUNT(emp_no) > 1) AS b
                WHERE a.emp_no = b.emp_no AND a.id > b.id )t
)


########
# ex_43、将titles_test中的所有to_date为9999-01-01的全部更新为NULL
# 且 from_date更新为2001-01-01。

-- 不能用and
UPDATE titles_test SET to_date=NULL AND from_date='2001-01-01'
WHERE to_date='9999-01-01'

-- 用逗号隔开
UPDATE titles_test SET to_date=NULL, from_date='2001-01-01'
WHERE to_date='9999-01-01'

########
# ex_44、将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005,
# 其他数据保持不变，使用replace实现。

-- 常规用法
UPDATE titles_test SET emp_no = 10005 WHERE id = 5;

-- replace(字段，“需要替换的值”，“替换后的值”）
UPDATE titles_test SET emp_no = REPLACE(emp_no,10001,10005) WHERE id = 5

-- 由于 REPLACE 的新记录中 id=5，与表中的主键 id=5 冲突，故会替换掉表中 id=5 的记录，否则会插入一条新记录（例如新插入的记录 id = 10）。并且要将所有字段的值写出，否则将置为空
REPLACE INTO titles_test VALUES (5, 10005, 'Senior Engineer', '1986-06-26', '9999-01-01')

REPLACE INTO titles_test SELECT 5, 10005, title, from_date, to_date
FROM titles_test WHERE id = 5;

########
# ex_45、将titles_test表名修改为titles_2017。

-- mysql,牛客不能通过
RENAME TABLE titles_test TO titles_2017;

-- mysql不用加to，sqllite必须要加
ALTER TABLE titles_test rename titles_2017;

-- AC
ALTER TABLE titles_test RENAME TO titles_2017;

########
# ex_46、在audit表上创建外键约束，其emp_no对应employees_test表的主键id。
# (audit已经创建，需要先drop)

-- mysql ,mysql创建外键名
ALTER TABLE audit
ADD FOREIGN KEY (emp_no) REFERENCES employees_test(ID);

-- mysql ,自己创建外键名
ALTER TABLE audit
ADD CONSTRAINT fk_a_emp
FOREIGN KEY (emp_no) REFERENCES employees_test(ID);

-- 删除
ALTER TABLE audit DROP FOREIGN KEY audit_ibfk_1;

-- sqlite3 不支持 ALTER TABLE ... ADD FOREIGN KEY ... REFERENCES ... 语句
DROP TABLE audit;
CREATE TABLE audit(
    EMP_no INT NOT NULL,
    create_date datetime NOT NULL,
    FOREIGN KEY(EMP_no) REFERENCES employees_test(ID));

########
# ex_47、存在如下的视图：
create view emp_v as select * from employees where emp_no >10005;

# 如何获取emp_v和employees有相同的数据？
SELECT em.* FROM employees AS em, emp_v AS ev WHERE em.emp_no = ev.emp_no;

-- 用 INTERSECT 关键字求 employees 和 emp_v 的交集
SELECT * FROM employees INTERSECT SELECT * FROM emp_v

SELECT * FROM emp_v;

elect emp_v.* from emp_v inner join employees on emp_v.emp_no = employees.emp_no

########
# ex_48、请你写出更新语句，将所有获取奖金的员工当前的(salaries.to_date='9999-01-01')薪水增加10%。
# (emp_bonus里面的emp_no都是当前获奖的所有员工)：
UPDATE salaries SET salary = salary*(1+0.1)
WHERE to_date='9999-01-01' AND emp_no IN (
SELECT emp_no FROM emp_bonus)

UPDATE salaries SET salary = salary * 1.1 WHERE emp_no IN
(SELECT s.emp_no FROM salaries AS s INNER JOIN emp_bonus AS eb
ON s.emp_no = eb.emp_no AND s.to_date = '9999-01-01')

########
# ex_49、针对库中的所有表生成select count(*)对应的SQL语句，如数据库里有以下表，
# (注:在 SQLite 中用 “||” 符号连接字符串，无法使用concat函数)

-- mysql
SELECT CONCAT('select count(*) from ',b.TABLE_NAME,';') AS cnts
FROM (
SELECT TABLE_NAME FROM information_schema.tables
WHERE TABLE_SCHEMA='nowcoder') b

-- sqlite
SELECT "select count(*) from " || name || ";" AS cnts
FROM sqlite_master WHERE type = 'table'