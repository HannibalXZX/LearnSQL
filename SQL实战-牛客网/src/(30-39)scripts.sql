###########################################
# intro: 牛客网中的SQL实战 30-39 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-09
############################################

### 题号查找：ex_题号

########
# ex_30、子查询的方式找出属于Action分类的所有电影对应的title,description
SELECT title, description
FROM film, film_category fc
WHERE film.film_id = fc.film_id
AND fc.category_id = (
SELECT category_id FROM category
WHERE name = "Action"
);

SELECT f.title,f.description FROM film AS f
WHERE f.film_id
IN (
     SELECT fc.film_id FROM film_category AS fc
     WHERE fc.category_id IN (
                               SELECT c.category_id FROM category as c
                               WHERE c.name = 'Action'));


########
# ex_31、获取select * from employees对应的执行计划
EXPLAIN SELECT * FROM employees


#######
# ex_32、将employees表的所有员工的last_name和first_name拼接起来作为Name，中间以一个空格区分
# (注：该数据库系统是sqllite,字符串拼接为 || 符号，不支持concat函数)

-- mysql
SELECT CONCAT(last_name,' ',first_name) AS name FROM employees

-- sqlite
SELECT last_name || ' ' ||first_name AS name FROM employees

# MySQL、SQL Server、Oracle等数据库支持CONCAT方法，
# 而本题所用的SQLite数据库只支持用连接符号"||"来连接字符串

########
# ex_33、创建一个actor表，包含如下列信息

-- sqlite
CREATE TABLE actor(
    actor_id    SMALLINT(5) NOT NULL,
    first_name  VARCHAR(45) NOT NULL,
    last_name   VARCHAR(45) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT (datetime('now','localtime')) ,
    PRIMARY KEY (actor_id)
);

-- mysql
CREATE TABLE actor(
    actor_id    SMALLINT(5) NOT NULL,
    first_name  VARCHAR(45) NOT NULL,
    last_name   VARCHAR(45) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (actor_id)
);


########
# ex_34、对于表actor批量插入如下数据(不能有2条insert语句哦!)
INSERT INTO actor VALUES(1,'PENELOPE', 'GUINESS', '2006-02-15 12:34:33'),
                        (2,'NICK', 'WAHLBERG','2006-02-15 12:34:33');

########
# ex_35、对于表actor批量插入如下数据(不能有2条insert语句哦!)

# INSERT INTO:     插入数据,如果主键重复，则报错
# INSERT REPLACE:  插入替换数据,如果存在主键或unique数据则替换数据
# INSERT IGNORE:   如果存在数据,则忽略。

-- sqllite
INSERT OR IGNORE INTO actor VALUES(3, 'ED', 'CHASE', '2006-02-15 12:34:33');
-- mysql
INSERT IGNORE INTO actor VALUES(3, 'ED', 'CHASE', '2006-02-15 12:34:33');


########
# ex_36、请你创建一个actor_name表，并且将actor表中的所有first_name以及last_name导入该表

CREATE TABLE actor_name(
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL
);

INSERT INTO actor_name
SELECT first_name, last_name FROM actor;

########
# ex_37、针对如下表actor结构创建索引：
# (注:在 SQLite 中,除了重命名表和在已有的表中添加列,ALTER TABLE 命令不支持其他操作)

# 对first_name创建唯一索引uniq_idx_firstname，对last_name创建普通索引idx_lastname
# (请先创建唯一索引，再创建普通索引)

-- ALTER 方式
ALTER TABLE actor ADD UNIQUE uniq_idx_firstname(first_name);
ALTER TABLE actor ADD INDEX idx_lastname(last_name);

-- CREATE方式
CREATE UNIQUE INDEX uniq_idx_firstname ON actor(first_name);
CREATE INDEX idx_lastname ON actor(last_name);

########
# ex_38、针对actor表创建视图actor_name_view，只包含first_name以及last_name两列，并对这两列重新命名，
# first_name为first_name_v，last_name修改为last_name_v：

CREATE VIEW actor_name_view AS
SELECT first_name first_name_v, last_name last_name_v
FROM actor

CREATE VIEW actor_name_view (fist_name_v, last_name_v) AS
SELECT first_name, last_name FROM actor

########
# ex_39、针对salaries表emp_no字段创建索引idx_emp_no，查询emp_no为10005, 使用强制索引。
-- sqlite

SELECT * FROM salaries INDEXED BY idx_emp_no WHERE emp_no = 10005

-- mysql
CREATE INDEX idx_emp_no ON salaries(emp_no);
SELECT * FROM salaries FORCE INDEX(idx_emp_no) WHERE emp_no = 10005;
