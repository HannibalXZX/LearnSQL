#############################
# 第8章 用通配符进行过滤 
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
# 时间：2020年07月03日
#############################

/*
通配符：用来匹配值得一部分的特殊字符 
搜索模式：由字面值、通配符或两者组合构成的搜索条件 
LIKE操作符：为在搜索子句中使用通配符，必须使用LIKE操作符。
指示mysql，其后跟的搜索模式利用通配符匹配而不是直接相等匹配进行比较。 
*/

-- 通配符类型 
# 百分号 % 通配符 ：表示任何字符（包括0个字符 ）出现任意次数 
# 特殊：注意 % 不能匹配NULL空值！
 
# 找到所有以词jet起头的产品 
SELECT prod_id,prod_name FROM products WHERE prod_name LIKE "jet%";

# 通配符可以在搜索模式任意位置使用
# 比如下方出现在头尾两处 ，匹配任意位置包含文本anvil的值 
SELECT prod_id,prod_name FROM products WHERE prod_name LIKE "%anvil%"; 

# 比如下方出现在搜索模式的中间，匹配所有以s开头e结尾的值 
SELECT prod_name FROM products WHERE prod_name LIKE "s%e"; 

# 下划线 _ 通配符 ：匹配一个字符，不能多不能少 
SELECT prod_id,prod_name FROM products
WHERE prod_name LIKE "_ ton anvil";

# 技巧：把通配符至于搜索模式的开始处，搜索起来是最慢的！ 
