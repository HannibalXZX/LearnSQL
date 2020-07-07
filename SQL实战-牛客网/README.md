## 思路

## 测试地址
https://www.nowcoder.com/ta/sql

## 答案参考
https://www.jianshu.com/p/5a659c5b5656

## OJ
1、题目含糊不清，没有准确表达意思
2、OJ判断比较死板，不是所有正确的解法都能通过
3、正因缺陷比较多，所以写起来锻炼人的能力，因为要考虑到很多其他情况
多看下评论，多思考。

## 网友优秀笔记摘抄

#### on和where的区别

1、on条件是在生成临时表时使用的条件，它不管on中的条件是否为真，都会返回左边表中的记录。
2、where条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left  join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉

#### 三个连接的简单区别
* INNER JOIN 两边表同时有对应的数据，即任何一边缺失数据就不显示。
* LEFT JOIN 会读取左边数据表的全部数据，即便右边表无对应数据。
* RIGHT JOIN 会读取右边数据表的全部数据，即便左边表无对应数据

#### 内连和并列的区别
并列，也是等值连接。实际上是没有创建出临时的新表，只是为了方便理解，认为两张表合并成一张新表，然后再从该表SELECT所需的字段和记录。
内连可以不等。推荐用内连，为将连接条件标记的比较清楚。

#### SQL执行顺序
FROM、WHERE、GROUP BY、HAVING、SELECT、DISTINCT、UNION、ORDER BY

#### GROUP BY 和 DISTINCT 使用场景
* 当对系统的性能高并数据量大时使用group by 
* 当对系统的性能不高时使用数据量少时两者皆可 
* 尽量使用group by

distinct相当于哈希表，将所有数据加载进来，时间复杂度低，空间复杂度高，group by是排序，时间复杂度高，空间复杂度低

#### LEFT JOIN 和 IN
MySQL官方文档有说明，in关键字适合确定数量的情况，一般效率较低，不推荐使用。能用in关键字的语句都可以转化为使用join的语句，推荐使用join关键字。

#### WHERE 和 HAVING
where和having的不同之处在于，where是查找之前的限定，而having是查找之后。

#### JOIN关联表中ON,WHERE后面跟条件的区别
参照：https://blog.csdn.net/wqc19920906/article/details/79785424
不管on上的条件是否为真都会返回left或right表中的记录，full则具有left和right的特性的并集。 而inner jion没这个特殊性，则条件放在on中和where中，返回的结果集是相同的。