#############################
# 第5章 排序检索数据
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
#############################

/* 关系型数据库设计理论认为，如果不明确规定排序顺序，
则不应该假定检索出的数据的顺序有意义 */

# ORDER BY 子句对输出排序

# 按单列排序 
# 以字母顺序排序prod_name列
SELECT prod_name FROM products ORDER BY prod_name;    

# 使用非检索的列排序数据也是合法的，如使用prod_id顺序排列prod_name
SELECT prod_name FROM products ORDER BY prod_id;  

# 按多列排序 
SELECT prod_id, prod_price,prod_name FROM products ORDER BY prod_price, prod_name; #先按价格，再按产品名排序

# 降序排列 DESC，DESC只作用于直接位于其前面的列名

# 按价格降序排列
SELECT prod_id, prod_price,prod_name FROM products ORDER BY prod_price DESC; 

# 先按价格降序排列，再按产品名升序排列
SELECT prod_id, prod_price,prod_name FROM products ORDER BY prod_price DESC, prod_name;  

# 先按价格降序排列，再按产品名降序排列
SELECT prod_id, prod_price,prod_name FROM products ORDER BY prod_price DESC, prod_name DESC; 

# 使用ORDER BY 和LIMIT组合，找出一列中最高或最低的值
# 顺序：ORDER BY子句必须在FROM子句之后，LIMIT子句必须在ORDER BY之后

# 最高值
SELECT prod_price FROM products ORDER BY prod_price DESC LIMIT 1; 

# 最低值 
SELECT prod_price FROM products ORDER BY prod_price LIMIT 1;

