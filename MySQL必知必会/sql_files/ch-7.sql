#############################
# 第7章 数据过滤
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
#############################

# AND 或 OR 操作符连接多个WHERE子句 
# AND 用在WHERE子句中的关键字，用来指示检索满足所有给定条件的行

#检索由供应商1003制造且价格小于等于10美元的产品信息
SELECT vend_id,prod_price,prod_name FROM products
WHERE vend_id = 1003 AND prod_price <= 10;

# 检索由任一个指定供应商制造的所有产品的产品信息
# OR 操作符，指示MySQL检索匹配任一条件的行
SELECT prod_name,prod_price FROM products 
WHERE vend_id = 1002 OR vend_id = 1003;

# AND 和 or结合，AND优先计算

# 优先计算AND，查找vend_id为1003且价格>=10的产品，或者vend_id为1002的产品，不管价格如何  
SELECT prod_name,prod_price FROM products 
WHERE vend_id = 1002 OR vend_id = 1003 AND prod_price >= 10;

# 使用圆括号明确运算顺序：查找vend_id为1002或1003，且价格>=10的产品
SELECT prod_name,prod_price FROM products 
WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10; 

# in操作符
# in操作符后跟由逗号分隔的合法值清单，整个清单必须括在圆括号
SELECT prod_name,prod_price FROM products
WHERE vend_id IN (1002,1003) ORDER BY prod_name;

# in操作符完成与or相同的功能
SELECT prod_name,prod_price FROM products
WHERE vend_id = 1002 OR vend_id = 1003 ORDER BY prod_name; # 同上 

# NOT操作符
# 列出1002和1003之外的供应商生产的产品
SELECT prod_name,prod_price FROM products
WHERE vend_id NOT IN (1002,1003) ORDER BY prod_name;

# Mysql支持 NOT 对 IN，BETWEEN，EXISTS 子句取反 