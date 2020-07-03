#############################
# 第10章 创建计算字段 
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日
#############################

-- 拼接字段 concat()
SELECT concat(vend_name,' (',vend_country,')') FROM vendors ORDER BY vend_name;  

-- 删除数据左侧多余空格 ltrim()
-- 删除数据两侧多余空格 trim()
-- 删除数据右侧多余空格 rtrim()

SELECT concat(rtrim(vend_name),' (',rtrim(vend_country),')') FROM vendors ORDER BY vend_name;

-- as赋予别名
SELECT concat(rtrim(vend_name),' (',rtrim(vend_country),')') AS vend_title FROM vendors ORDER BY vend_name;

-- 执行算数计算
SELECT prod_id,quantity,item_price FROM orderitems WHERE order_num = 20005;

# 计算总价expanded_price
SELECT prod_id,quantity, item_price, quantity * item_price AS expanded_price
FROM orderitems WHERE order_num = 20005;  

-- 简单测试计算 
SELECT 2*3;
SELECT TRIM(' abc ');
SELECT NOW();  # 返回当前日期和时间