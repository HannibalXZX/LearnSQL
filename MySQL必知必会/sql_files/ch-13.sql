#############################
# 第13章 分组计算
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日 
#############################

-- GROUP BY 分组 
# 按vend_id排序并分组数据
SELECT vend_id, COUNT(*) AS num_prods FROM products GROUP BY vend_id;

# 使用WITH ROLLUP关键字，可以得到每个分组的汇总值，下述语句得到所有分组COUNT(*)的和14 
SELECT vend_id, COUNT(*) AS num_prods FROM products GROUP BY vend_id WITH ROLLUP;

-- HAVING子句 过滤分组 
# WHERE过滤行，HAVING过滤分组 
# WHERE在数据分组前进行过滤，HAVING在数据分组后进行过滤
# COUNT(*) >=2（两个以上的订单）的那些分组

SELECT cust_id, COUNT(*) AS orders FROM orders GROUP BY cust_id HAVING COUNT(*)>=2;

-- WHERE和HAVING组合使用 
#列出具有2个（含）以上、价格为10（含）以上的产品的供应商
SELECT vend_id,COUNT(*) AS num_prods FROM products
WHERE prod_price >=10 GROUP BY vend_id having COUNT(*)>=2;

# 不加WHERE条件，结果不同 
SELECT vend_id,COUNT(*) AS num_prods FROM products GROUP BY vend_id HAVING COUNT(*) >=2;

-- 分组和排序 
# 检索总计订单价格大于等于50的订单的订单号和总计订单价格
SELECT
    order_num, SUM(quantity * item_price) AS ordertotal
FROM
    orderitems
GROUP BY
    order_num
HAVING
    SUM(quantity * item_price) >=50;

# 按总计订单价格排序输出
SELECT 
    order_num, SUM(quantity * item_price) AS ordertotal
FROM
    orderitems
GROUP BY order_num
HAVING SUM(quantity * item_price) >= 50
ORDER BY ordertotal;


-- SELECT子句总结及顺序 
# 子句            说明                        是否必须使用 
# SELECT         要返回的列或表达式             是 
# FROM           从数据中要检索的表             仅在从表选择数据时使用  
# WHERE          行级过滤                     否 
# GROUP BY       分组说明                     仅在按组计算聚集时使用 
# HAVING         组级过滤                     否 
# ORDER BY       输出排序顺序                  否
# LIMIT          要检索的行数                  否 
