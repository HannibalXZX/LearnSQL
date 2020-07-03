#############################
# 第14章 使用子查询
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日  
#############################

-- 利用子查询进行过滤
# 列出订购物品TNT2的所有客户
SELECT cust_name, cust_contact FROM customers
WHERE cust_id IN (SELECT cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                      WHERE prod_id = 'TNT2'));
                                      
                                      
-- 作为计算字段使用子查询
# 对客户10001的订单进行计数
SELECT COUNT(order_num) FROM orders
WHERE cust_id = 10001;

# 显示customers 表中每个客户的订单总数
SELECT cust_name, cust_state, (
SELECT COUNT(*) FROM orders
WHERE orders.cust_id = customers.cust_id)
AS orders
FROM customers ORDER BY cust_name;
