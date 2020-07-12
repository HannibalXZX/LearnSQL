##  1、前言
>结构化查询语言(Structured Query Language)简称SQL，是一种特殊目的的编程语言，是一种数据库查询和程序设计语言，用于存取数据以及查询、更新和管理关系数据库系统；同时也是数据库脚本文件的扩展名。

差不多花了一周的时间做完了牛客网平台的61道SQL题，先说一说这个平台的坑:

1. 题目含糊不清，有一些题没有准确表达意思，会让人产生误解。
2. OJ的答案判断比较死板，不是所有正确的解法都能通过。
3. 难度不是缓慢递增，中间有的题会非常搞人。
4. 没有提供单独的测试数据，需要去有的题目下面找。
5. 只支持sqlite，不支持mysql,oracle等其他SQL语言。

再讲一讲自己的刷题体会：
1. 比较坑也是一件好事，可以训练思维的全面性，努力去寻找问题的不同切入点。
2. 不要做完了就直接下一题！我个人最喜欢看评论，因为可以学习到前辈们的思路和解法。
首先，我会在脑海里形成自己的思路，然后和他们的思路进行对比。如果是一致的，哇，我就很开心。
如果不一致，则仔细进行比对，找到我的缺陷。
3. SQL语句不是正确通过就万事大吉了，尽可能做多一题多解。分析每种解法的优化性能，找到
对应的使用场景。
4. 写法要规范，注意缩进，这样每个子语句看起来就比较清晰。
5. 在动手之前先思考一下，不要上来就急着写。
6. 了解一些函数，比如窗口函数等，这些是利器。

如果要二刷，注意以下几点：
1. 思考题目的真实使用场景，不要单纯做题。
2. 遇到比较坑的题目，直接跳过，不要多花时间。
3. 多归纳总结，必要时做一下实验。
4. 思考一些高阶用法，降维打击。

二刷先放一下，先去刷一下LeetCode的SQL题。那里的题库更加正规，还有一些企业真题。这么好吗？，毕竟是付费的呀 - -。

## 2、牛客网OJ平台地址
<https://www.nowcoder.com/ta/sql>

## 3、详细答题记录(个人整理)
<https://github.com/HannibalXZX/LearnSQL/tree/master/SQL%E5%AE%9E%E6%88%98-%E7%89%9B%E5%AE%A2%E7%BD%91>

## 4、 网友优秀笔记摘抄

### 01. left join中on和where的区别

1. `on`条件是在生成临时表时使用的条件，不管on中的条件是否为真，都会返回左边表中的记录。
2. `where`条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left  join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉。

### 02. 三个连接的简单区别
* `INNER JOIN` 两边表同时有对应的数据，即任何一边缺失数据就不显示。
* `LEFT JOIN`  会读取左边数据表的全部数据，即便右边表无对应数据。
* `RIGHT JOIN` 会读取右边数据表的全部数据，即便左边表无对应数据

### 03. 内连和并列的区别
并列，也是等值连接。在这个过程中，实际上是没有创建出临时的新表，只是为了方便理解，可以认为两张表合并成一张新表，然后再从该表`SELECT`所需的字段和记录。
内连可以不等。推荐用内连，因为，可以将连接条件标记得比较清楚。

### 04. SQL执行顺序(重要)
`FROM`、`WHERE`、`GROUP BY`、`HAVING`、`SELECT`、`DISTINCT`、`UNION`、`ORDER BY`

### 05. GROUP BY 和 DISTINCT 
* 当对系统的性能高并数据量大时使用`GROUP BY`
* 当对系统的性能不高时使用数据量少时两者皆可 
* 尽量使用`GROUP BY`

针对网上实验结果，还有一种结论：
>去重场景下，未加索引时，更偏向于使用distinct，而加索引时，distinct和group by两者都可以使用
<https://blog.csdn.net/NestorBian/article/details/106004840?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase>

#### 06. LEFT JOIN 和 IN
MySQL官方文档有说明，`IN`关键字适合**确定数量**的情况，一般效率较低，不推荐使用。能用`IN`关键字的语句都可以转化为使用`JOIN`的语句，推荐使用`JOIN`关键字。

#### 07. WHERE 和 HAVING
`WHERE`和`HAVING`的不同之处在于，`WHERE`是查找之前的限定，而`HAVING`是查找之后。如果使用`HAVING`，必须提前筛选字段，但`WHERE`不需要。`WHERE`后面不能加聚合函数，
`HAVING`后可以加聚合函数。

#### 08. JOIN关联表中ON,WHERE后面跟条件的区别
参照：<https://blog.csdn.net/wqc19920906/article/details/79785424>
不管`ON`上的条件是否为真都会返回`LEFT`或`RIGHT`表中的记录，full则具有`LEFT`和`RIGHT`的特性的并集。 而`INNER JOIN`没这个特殊性，则条件放在`ON`中和`WHERE`中，返回的结果集是相同的。

#### 09. EXPLAIN 函数作用
1. 表的读取顺序
2. 数据读取操作的操作类型
3. 哪些索引可以使用
4. 哪些索引被实际使用
5. 表之间的引用
6. 每张表有多少行被优化器查询

#### 10. MySQL创建索引方法：ALTER TABLE和CREATE INDEX的区别
众所周知，MySQL创建索引有两种语法，即：
`ALTER TABLE HeadOfState ADD INDEX (LastName, FirstName);`

`CREATE INDEX index_name HeadOfState (LastName, FirstName);`
那么，这两种语法有什么区别呢？
1. `CREATE INDEX`必须提供索引名，对于`ALTER TABLE`，如果你不提供索引名，将会自动创建；
2. `CREATE INDEX`一个语句一次只能建立一个索引，`ALTER TABLE`可以在一个语句建立多个，如：
`ALTER TABLE HeadOfState ADD PRIMARY KEY (ID), ADD INDEX (LastName,FirstName);`
3. 只有`ALTER TABLE`才能创建主键，

#### 11. 强制索引
MYSQL中强制索引查询使用：`SELECT * FROM table FORCE INDEX(indexname);`
SQLite中强制索引查询使用：`SELECT * FROM table INDEXED BY indexname;`

#### 12. 严格模式
mysql的`datetime`类型无法插入'0000-00-00 00:00:00',这是因为mysql开启了严格模式。
`SELECT @@sql_mode` 得到如下结果：
`ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION`

可以看到结果里面有 `NO_ZERO_IN_DATE, NO_ZERO_IN_DATE`把这两个去掉，再重新设置即可。

`SET GLOBAL sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';`

**玄学**：在Navicat Premium上不行，但在mysql终端上可行

#### 13. MYSQL子查询的坑
MySQL的`UPDATE`或`DELETE`中子查询不能为同一张表，可将查询结果再次`SELECT`。在MySQL中还有一个坑，需要给子查询添加**别名**，
不然会抛出错误：ERROR 1248 (42000): Every derived table must have its own alias

#### 14. 字符长度函数
`char_length()`: 统计的是字符长度，而`LENGTH()`函数统计的是字符串的字节长度，所以`LENGTH('中')`在utf8下的结果是3，而`char_length('中')`的结果仍然是1.

#### 15. EXISTS的用法
**EXISTS对外表用loop逐条查询**，每次查询都会查看`EXISTS`的条件语句，当`EXISTS`里的条件语句能够返回记录行时(无论记录行是的多少，只要能返回)，条件就为真，
返回当前loop到的这条记录;反之如果`EXISTS`里的条件语句不能返回记录行，则当前loop到的这条记录被丢弃，`EXISTS`的条件就像一个bool条件，当能返回结果集则为true，不能返回结果集则为 false。

简而言之，使用`EXISTS`需要建立内外关联。

* 没有建立内外关联，等价于：`SELECT b.emp_no FROM employees b`
```
SELECT b.emp_no FROM employees b 
WHERE  EXISTS  (SELECT emp_no FROM dept_emp)
```

* 建立内外关联
```
SELECT b.emp_no FROM employees b 
WHERE  EXISTS  (SELECT emp_no FROM dept_emp WHERE b.emp_no=emp_no)
```

