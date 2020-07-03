#############################
# 第9章 用正则表达式进行搜索 
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日
#############################

-- 基本字符匹配 
# 查找产品名中含有'1000'的所有行 
SELECT prod_name FROM products WHERE prod_name REGEXP "1000";

# .在正则表达式中，匹配任意 一个 字符 
SELECT prod_name FROM products WHERE prod_name REGEXP ".000";

-- LIKE 和 正则表达式的区别 ，是否在列值中匹配 
# LIKE在整个列中查找，如果被匹配的文本出现在列值中，匹配不到结果，除非使用通配符

#无返回结果
SELECT prod_name FROM products WHERE prod_name LIKE "1000" ORDER BY prod_name;     

# LIKE + 通配符# 返回结果'JetPack 1000'
SELECT prod_name FROM products WHERE prod_name LIKE "%1000" ORDER BY prod_name;  

# 返回结果 'JetPack 1000' 'JetPack 2000' 
SELECT prod_name FROM products WHERE prod_name LIKE "%000" ORDER BY prod_name;  

# Regexp在列值中匹配
SELECT prod_name FROM products WHERE prod_name REGEXP ".000" ORDER BY prod_name;  

# regexp如何匹配整个列，同LIKE效果呢，使用^和$定位符即可 

-- 正则表达式匹配默认不分大小写，需使用BinARY区分大小写  
SELECT prod_name FROM products WHERE prod_name REGEXP binary "JetPack .000";

-- 正则表达式的or操作符： |
SELECT prod_name FROM products WHERE prod_name REGEXP "1000|2000" ORDER BY prod_name;

-- 正则表达式匹配几个字符之一 [ ]# [123]匹配单一字符：1或2或3
SELECT prod_name FROM products WHERE prod_name REGEXP '[123] Ton' ORDER BY prod_name;  

# [1|2|3]同[123]，匹配单一字符：1或2或3
SELECT prod_name FROM products WHERE prod_name REGEXP '[1|2|3] Ton' ORDER BY prod_name;  

# '1|2|3 ton' 匹配 '1' 或 '2' 或 '3 ton'
SELECT prod_name FROM products WHERE prod_name REGEXP '1|2|3 ton' ORDER BY prod_name;

# 取反
SELECT prod_name FROM products WHERE prod_name REGEXP '[^123]' ORDER BY prod_name;  

-- 正则表达式匹配范围 
SELECT prod_name FROM products WHERE prod_name REGEXP '[1-5] Ton' ORDER BY prod_name;  

-- 正则表达式匹配特殊字符，必须用\\前导，进行转义 
-- 多数正则使用单反斜杠转义，但mysql使用双反斜杠，mysql自己解释一个，正则表达式库解释一个 
# '\\.' 匹配字符.
SELECT vend_name FROM vendors WHERE vend_name REGEXP "\\." ORDER BY vend_name;

# '.' 匹配任意字符， 每行都会被检索出来
SELECT vend_name FROM vendors WHERE vend_name REGEXP "." ORDER BY vend_name;

-- 正则表达式匹配字符类 
#    [:alnum:]    任意字母和数字（同[a-zA-Z0-9]） 
#    [:alpha:]    任意字符（同[a-zA-Z]） 
#    [:blank:]    空格和制表（同[\\t]） 
#    [:cntrl:]    ASCII控制字符（ASCII 0到31和127） 
#    [:digit:]    任意数字（同[0-9]） 
#    [:graph:]    与[:print:]相同，但不包括空格 
#    [:lower:]    任意小写字母（同[a-z]） 
#    [:print:]    任意可打印字符 
#    [:punct:]    既不在[:alnum:]又不在[:cntrl:]中的任意字符 
#    [:space:]    包括空格在内的任意空白字符（同[\\f\\n\\r\\t\\v]） 
#    [:upper:]    任意大写字母（同[A-Z]） 
#    [:xdigit:]   任意十六进制数字（同[a-fA-F0-9]）
 
# [:digit:]匹配任意数字 
SELECT prod_name FROM products WHERE prod_name REGEXP '[:digit:]' ORDER BY prod_name;

-- 匹配多个实例 
#    *        0个或多个匹配 
#    +        1个或多个匹配（等于{1,}）
#    ?        0个或1个匹配（等于{0,1}）
#    {n}      指定数目的匹配 
#    {n,}     不少于指定数目的匹配
#    {n,m}    匹配数目的范围（m不超过255）

# 返回了'TNT (1 stick)'和'TNT (5 sticks)'
SELECT prod_name FROM products WHERE prod_name REGEXP '\\([0-9] sticks?\\)'
ORDER BY prod_name;  

# [[:digit:]]{4}匹配连在一起的任意4位数字
SELECT prod_name FROM products WHERE prod_name REGEXP '[[:digit:]]{4}'
ORDER BY prod_name;  

-- 定位符
#    ^              文本的开始 
#    $              文本的结尾 
#    [[:<:]]        词的开始 
#    [[:>:]]        词的结尾

# 找出以一个数（包括以小数点开始的数）开始的所有产品
SELECT prod_name FROM products WHERE prod_name REGEXP '^[0-9\\.]' ORDER BY prod_name;

# 找出包括小数点和数字的所有产品
SELECT prod_name FROM products WHERE prod_name REGEXP '[0-9\\.]' ORDER BY prod_name;  

-- ^的双重作用 
# 在集合中（用[和]定义），用它来否定该集合
# 用来指串的开始处

-- 不适用数据库表进行正则表达式的测试：匹配返回1，无匹配返回0
SELECT 'hello' REGEXP '[0-9]'; # 返回 0 
SELECT 'hello' REGEXP '[:alnum:]'; # 返回 1
