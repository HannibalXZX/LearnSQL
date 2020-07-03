#############################
# 第12章 汇总数据
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日
#############################

-- 聚类函数 
# avg()            返回某列的平均值 
# COUNT()          返回某列的行数 
# max()            返回某列的最大值 
# min()            返回某列的最小值 
# sum()            返回某列值之和 

-- avg()
# AVG()返回products表中所有产品的平均价格
SELECT AVG(prod_price) AS avg_price FROM products;

# 返回特定供应商所提供产品的平均价格
SELECT AVG(prod_price) AS avg_price FROM products WHERE vend_id = 1003;

# avg()只能作用于单列，多列使用多个avg()
SELECT AVG(item_price) AS avg_itemprice, avg(quantity) AS avg_quantity FROM orderitems;

-- COUNT()
# COUNT(*)对表中行的数目进行计数，不忽略空值 
SELECT COUNT(*) AS num_cust FROM customers; 

# 使用COUNT(column)对特定列中具有值的行进行计数，忽略NULL值
SELECT COUNT(cust_email) AS num_cust FROM customers;  

-- max() & min()
# MAX()返回products表中最贵的物品的价格
SELECT MAX(prod_price) AS max_price FROM products;

# 在用于文本数据时，如果数据按相应的列排序，则MAX()返回最后一行
SELECT MAX(prod_name) FROM products; 

# Min()返回products表中最便宜物品的价格
SELECT MIN(prod_price) AS min_price FROM products;

# 在用于文本数据时，如果数据按相应的列排序，则Min()返回最前面一行
SELECT MIN(prod_name) FROM products; 

-- sum()
# 检索所订购物品的总数（所有quantity值之和）
SELECT sum(quantity) AS items_ordered FROM orderitems;
SELECT sum(quantity) AS items_ordered FROM orderitems WHERE order_num = 20005;

# 订单20005的总订单金额
SELECT sum(quantity * item_price) AS total_price FROM orderitems WHERE order_num = 20005;

-- 聚类不同值 distinct
# 使用了DISTinCT参数，因此平均值只考虑各个不同的价格
SELECT AVG(DISTINCT prod_price) AS avg_price FROM products WHERE vend_id = 1003;

# DISTINCT 只能作用于COUNT(),不能用于COUNT(*)
# DISTINCT 同max(),min()的结合使用，没有意义 

-- 组合聚类函数 
# 4个聚集计算:物品的数目，产品价格的最高、最低以及平均值 
SELECT 
    COUNT(*) AS num_items,
    Min(prod_price) AS price_min,
    MAX(prod_price) AS price_max,
    AVG(prod_price) AS price_avg
FROM
    products;