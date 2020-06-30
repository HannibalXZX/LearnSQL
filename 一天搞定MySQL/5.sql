########################################
# 一天搞定MySQL
# https://mp.weixin.qq.com/s/5EsOhmyPRUpAUk9Sh4NMkg
# 时间：2020年06月30日20:51:31
########################################

# 查询所有学生的 s_no 、c_no 和 grade 列

SELECT * FROM grade;

SELECT s_no, c_no, grade, degree FROM score, grade
WHERE degree BETWEEN low AND upp;
# 思路是，使用区间 ( BETWEEN ) 查询，判断学生的成绩 ( degree ) 在 grade 表的 low 和 upp 之间。

# 连接查询

CREATE DATABASE testJoin;
USE testJoin;
CREATE TABLE person (
    id INT,
    name VARCHAR(20),
    cardId INT
);

CREATE TABLE card (
    id INT,
    name VARCHAR(20)
);

INSERT INTO card VALUES (1, '饭卡'), (2, '建行卡'), (3, '农行卡'), (4, '工商卡'), (5, '邮政卡');
SELECT * FROM card;

INSERT INTO person VALUES (1, '张三', 1), (2, '李四', 3), (3, '王五', 6);
SELECT * FROM person;

# 分析两张表发现，person 表并没有为 cardId 字段设置一个在 card 表中对应的 id 外键。如果设置了的话，person 中 cardId 字段值为 6 的行就插不进去，因为该 cardId 值在 card 表中并没有。

# 内连接
# 要查询这两张表中有关系的数据，可以使用 INNER JOIN ( 内连接 ) 将它们连接在一起

-- INNER JOIN: 表示为内连接，将两张表拼接在一起。
-- on: 表示要执行某个条件。
SELECT * FROM person INNER JOIN card on person.cardId = card.id;

-- 将 INNER 关键字省略掉，结果也是一样的。
-- SELECT * FROM person JOIN card on person.cardId = card.id;注意：card 的整张表被连接到了右边

## 左外链接
# 完整显示左边的表 ( person ) ，右边的表如果符合条件就显示，不符合则补 NULL 。
SELECT * FROM person LEFT JOIN card on person.cardId = card.id;

## 右外链接
# 完整显示右边的表 ( card ) ，左边的表如果符合条件就显示，不符合则补 NULL 。
SELECT * FROM person RIGHT JOIN card on person.cardId = card.id;

## 全外链接
## 完整显示两张表的全部数据。

-- MySQL 不支持这种语法的全外连接
-- SELECT * FROM person FULL JOIN card on person.cardId = card.id;
-- 出现错误：
-- ERROR 1054 (42S22): Unknown column 'person.cardId' in 'on clause'

-- MySQL全连接语法，使用 UNION 将两张表合并在一起。
SELECT * FROM person LEFT JOIN card on person.cardId = card.id
UNION
SELECT * FROM person RIGHT JOIN card on person.cardId = card.id;