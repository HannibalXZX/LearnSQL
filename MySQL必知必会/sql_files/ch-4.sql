#############################
# 第4章 检索数据
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
#############################
# SELECT检索单列，多列，所有列
SELECT prod_name FROM products;  # 从products表中检索prod_name 单列
SELECT prod_id,prod_name,prod_price FROM products;   # 从products表中检索prod_name，prod_name,prod_price 多列
SELECT * FROM products;   #  # 从products表中检索所有列，通常情况下，检索不需要的列会降低检索和应用程序的效率

# 使用DISTINCT 去重

# 使用DISTINCT关键字去重，DISTINCT只能放在列名的前面
SELECT DISTINCT vend_id FROM products;  

# DISTINCT不仅对前置它的列vend_id起作用，同时也作用于prod_price，两列值有重复，才去重
SELECT DISTINCT vend_id,prod_price FROM products;  

# 使用LIMIT检索部分行，开始位置为行索引值，索引从0开始
SELECT prod_name FROM products LIMIT 5; #从第 0 行开始，返回前 5 行
SELECT prod_name FROM products LIMIT 5,5; #从第 5 行开始，检索 5 行

# 另一种写法
SELECT prod_name FROM products LIMIT 4 OFFSET 3; #从第 3 行开始，检索 4 行
SELECT prod_name FROM products LIMIT 3,4; #，同上，从第 3 行开始，检索 4 行

# 行数不够时，mysql只返回它能返回的那么多行
SELECT COUNT(prod_name) FROM products; # prod_name 共14行，索引为0-13
SELECT prod_name FROM products LIMIT 10,5; #从第 10 行开始，检索 5 行，行索引10-14，超出范围，只返回10-13共4行数据

# 使用完全限定的表名
SELECT products.prod_name FROM products;
SELECT products.prod_name FROM crashcourse.products;
