#############################
# 第6章 过滤数据
# 第一作者：ShinyCC
# 来源：https://blog.csdn.net/weixin_40159138/java/article/details/90075289
# 第二作者：Shaw
#############################

# 价格等于2.50的产品名、产品价格
SELECT prod_name,prod_price FROM products WHERE prod_price = 2.50;  

# 默认不区分大小写
SELECT prod_name,prod_price FROM products WHERE prod_name = "fuses";  

# 价格小于10的产品名、产品价格
SELECT prod_name,prod_price FROM products WHERE prod_price < 10;

 # 价格小于等于10的产品名、产品价格
SELECT prod_name,prod_price FROM products WHERE prod_price <=10;

# 不匹配检查

# 检索不是由1003供应商制造的所有产品 
SELECT vend_id,prod_name FROM products WHERE vend_id <> 1003;

# 同上，检索不是由1003供应商制造的所有产品 
SELECT vend_id,prod_name FROM products WHERE vend_id != 1003;

# 范围值检索，BETWEEN A AND B，包括A和B

# 价格 大于等于5，小于等于10 的产品名、产品价格
SELECT prod_name,prod_price FROM products WHERE prod_price BETWEEN 5 AND 10;

# 空值检查

# 返回prod_price为空值NULL的prod_name,无对应数据 
SELECT prod_name FROM products WHERE prod_price IS NULL;

# 检索cust_email为空值时的cust_id
SELECT cust_id FROM customers WHERE cust_email IS NULL;

/* 在通过过滤选择出不具有特定值的行时，你可能希望返回具有NULL值得行。
但是，不行。因为未知具有特殊的含义，数据库不知道他们是否匹配，所以在匹配过滤和不匹配过滤中不返回NULL。
因此，在过滤数据时，一定要验证返回数据中确实给出了被过滤列具有NULL的行。 
*/
