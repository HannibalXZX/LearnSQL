#############################
# 第11章 利用数据处理函数  
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日
#############################

-- 文本处理函数 
#    left()             返回串左边的字符 
#    length()           返回串的长度 
#    locate()           找出串的一个子串 
#    lower()            将串转换为小写
#    ltrim()            去掉串左边的空格
#    right()            返回串右边的字符 
#    rtrim()            去掉串右边的空格  
#    soundex()          返回串的soundex值
#    substring()        返回子串的字符 
#    upper()            将串转换为大写

-- UPPER()函数 转换文本为大写 
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase FROM vendors ORDER BY vend_name;

# soundex() 描述语音表示的字母数字模式的算法,对串按照发音比较而不是字母比较

# 无返回 
SELECT cust_name,cust_contact FROM customers WHERE cust_contact = 'Y. Lie';  

# 按发音搜索
SELECT cust_name,cust_contact FROM customers WHERE soundex(cust_contact) = soundex('Y. Lie');  

-- 日期和时间处理函数 
#    adddate()        增加一个日期（天，周等）
#    addtime()        增加一个时间（时、分等）
#    curdate()        返回当前日期 
#    curtime()        返回当前时间 
#    date()           返回日期时间的日期部分     
#    datediff()       计算两个日期之差 
#    date_add()       高度灵活的日期运算函数 
#    date_format()    返回一个格式化的日期或时间串 
#    day()            返回一个日期的天数部分     
#    dayofweek()      对于一个日期，返回对应的星期几 
#    hour()           返回一个时间的小时部分 
#    minute()         返回一个时间的分钟部分 
#    month()          返回一个日期的月份部分 
#    now()            返回当前日期和事件 
#    second()         返回一个时间的秒部分 
#    time()           返回一个日期时间的时间部分 
#    year()           返回一个日期的年份部分 

# 首选的日期格式yyyy-mm-dd，避免多义性 
SELECT cust_id,order_num FROM orders WHERE order_date = "2005-09-01";

# order_date为datetime数据类型，含有时间信息；如果时间信息不是00:00:00,上句查找无结果
SELECT * FROM orders;

# 按照date()日期进行过滤信息，更可靠 
SELECT cust_id,order_num FROM orders WHERE date(order_date) = "2005-09-01";

# 检索2005年9月下的订单 
SELECT cust_id,order_num FROM orders WHERE year(order_date) = 2005 AND month(order_date) = 9;
SELECT cust_id,order_num FROM orders WHERE date(order_date) BETWEEN "2005-09-01" AND "2005-09-30";

-- 数值处理函数 
#    abs()            返回一个数的绝对值
#    cos()            返回一个角度的余弦
#    exp()            返回一个数的指数值
#    mod()            返回除操作的余数
#    pi()             返回圆周率    
#    sin()            返回一个角度的正弦 
#    sqrt()           返回一个数的平方根 
#    tan()            返回一个角度的正切 