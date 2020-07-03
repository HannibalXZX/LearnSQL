




#############################
# 第15章 联结表      
#############################

-- 创建联结 
# WHERE子句联结 
SELECT vend_name,prod_name,prod_price 
FROM vendors,products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name,prod_name;

-- 笛卡尔积 / 叉联结 
/*由没有联结条件的表关系返回的结果为笛卡尔积。
检索出的行的数目将是第一个表中的行数乘以第二个表的行数。*/

# 删除WHERE联结条件 
# 返回的数据用每个供应商匹配了每个产品，它包括了供应商不正确的产品
SELECT vend_name,prod_name,prod_price 
FROM vendors,products
ORDER BY vend_name,prod_name;

-- 内部联结 inner joIN ： 表间相等测试 
SELECT vend_name,prod_name,prod_price 
FROM vendors inner joIN products
on vendors.vend_id = products.vend_id;

# 编号为20005的订单中的物品及对应情况 
SELECT prod_name,vend_name,prod_price,quantity
FROM orderitems,products,vendors
WHERE products.vend_id = vendors.vend_id
AND orderitems.prod_id = products.prod_id
AND order_num = 20005;

# 订购产品TNT2的客户列表
SELECT cust_name,cust_contact
FROM customers,orders,orderitems
WHERE customers.cust_id = orders.cust_id
AND orders.order_num =  orderitems.order_num
AND prod_id = 'TNT2';


#############################
# 第16章 创建高级联结      
#############################

-- 使用表别名
# 给列名或计算字段起别名 
 SELECT concat(rtrim(vend_name),' (',rtrim(vend_COUNTry),')') AS vend_title
 FROM vendors ORDER BY vend_name;
 # 给表起别名 
 SELECT cust_name,cust_contact 
 FROM customers AS c,orders AS o,orderitems AS oi
 WHERE c.cust_id = o.cust_id
 AND oi.order_num = o.order_num
 AND prod_id = 'TNT2';
 
-- 自联结 
# ID为DTNTR该物品的供应商生产的其他物品
#方法：子查询 
SELECT prod_id,prod_name FROM products
WHERE vend_id = (SELECT vend_id FROM products WHERE prod_id = 'DTNTR');
 #方法：使用联结 
SELECT p1.prod_id,p1.prod_name
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id
AND p2.prod_id = 'DTNTR';

-- 自然联结
# 自然联结使每个列只返回一次
# 方法：通过对表使用通配符*，对所有其他表的列使用明确的子集 
SELECT c.*,o.order_num,o.order_date,oi.prod_id,oi.quantity,oi.item_price
FROM customers AS c,orders AS o,orderitems AS oi
WHERE c.cust_id = o.cust_id
AND oi.order_num = o.order_num
AND prod_id = 'FB';
 
-- 外部联结 
# 检索所有客户及其订单
# 方法： 内部联结 
SELECT customers.cust_id,orders.order_num
FROM customers inner joIN orders
on customers.cust_id = orders.cust_id;
 
# 检索所有客户及其订单,包括那些没有订单的客户
# 01 ： 左外部联结
SELECT customers.cust_id,orders.order_num
FROM customers left outer joIN orders
on customers.cust_id = orders.cust_id;

# 02 ：若使用 右外部联结 结果不同 
SELECT customers.cust_id,orders.order_num
FROM customers right outer joIN orders
on customers.cust_id = orders.cust_id;

# 03： 若使用 右外部联结 调换两表位置 结果同01代码相同 
SELECT customers.cust_id,orders.order_num
FROM orders right outer joIN customers
on customers.cust_id = orders.cust_id;
 
-- 使用带聚集函数的联结 
 # 检索所有客户分别对应的订单数，inner join 
SELECT customers.cust_name,
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers inner joIN orders 
on customers.cust_id = orders.cust_id
GROUP BY customers.cust_id; 
 
  # 检索所有客户分别对应的订单数，包括没有订单的客户，left outer join 
 SELECT customers.cust_name,
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers left outer joIN orders 
on customers.cust_id = orders.cust_id
GROUP BY customers.cust_id; 


#############################
# 第17章 组合查询      
#############################

-- 使用union 
# 价格小于等于5的所有物品
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <=5;
# 供应商1001和1002生产的所有物品
SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002);
# 价格小于等于5的所有物品的列表，而且包括供应商1001和1002生产的所有物品（不考虑价格）
# 方法1 使用union 
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <=5
union
SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002);
# 方法2 使用WHERE 
SELECT vend_id,prod_id,prod_price FROM products 
WHERE prod_price <=5 OR vend_id IN (1001,1002);

# union默认自动去除重复的行 
# union all，匹配所有行 ，不取消重复行 
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <=5
union all
SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002);  # 有一行出现2次 

# 对union组合结果进行排序
# union组合完只能使用一条ORDER BY语句，放在最后一个SELECT语句后面 
SELECT vend_id,prod_id,prod_price FROM products WHERE prod_price <=5
union
SELECT vend_id,prod_id,prod_price FROM products WHERE vend_id IN (1001,1002)
ORDER BY vend_id,prod_price;
 

#############################
# 第18章 全文本搜索       
#############################

-- 进行全文本搜索 
# MATCH() 指定被搜索的列，against()指定要使用的搜索表达式 
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('rabbit');

# 如果用LIKE语句 
SELECT note_text FROM productnotes WHERE note_text LIKE '%rabbit%';

# 演示排序如何工作 
/*  注意：RANK (R)在mysql 8.0.2 (reserved)版本中为keyword保留字
当字段名与MySQL保留字冲突时,可以用字符‘’将字段名括起来
或者改为其他名字，比如AS rank1等
*/
SELECT note_text, MATCH(note_text) against('rabbit') AS 'rank' FROM productnotes; 

-- 使用查询扩展 
 # 进行一个简单的全文本搜索，没有查询扩展
 SELECT note_text FROM productnotes WHERE MATCH(note_text) against('anvils');
 # 相同的搜索，这次使用查询扩展
 SELECT note_text FROM productnotes WHERE MATCH(note_text) against('anvils' with query expansion);

-- 布尔文本搜索
-- 全文本布尔操作符 
#    布尔操作符            说明
#    +                包含，词必须存在 
#    -                排除，词必须不出现
#    >                包含，而且增加等级值 
#    <                包含，且减少等级值 
#    ()                把词组成子表达式（允许这些表达式作为一个组被包含、排除、排列等）
#    ~                取消一个词的排序值
#     *                词尾的通配符
#    “ ”                定义一个短语（与单个词的列表不一样，它匹配整个短语一边包含或排除这个短语）

# 全文本搜索检索包含词heavy的所有行
# 关键字IN BOOLEAN MODE，实际上没有指定布尔操作符，其结果与没有指定布尔方式的结果相同
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('heavy' IN boolean mode);
# -rope* 排除包含rope*（任何以rope开始的词，包括ropes）的行
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('heavy -rope*' IN boolean mode);

# 匹配包含词rabbit和bait的行
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('+rabbit +bait' IN boolean mode);

# 不指定操作符，搜索匹配包含rabbit和bait中的至少一个词的行
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('rabbit bait' IN boolean mode);

# 搜索匹配短语rabbit bait而不是匹配两个词rabbit和bait。 
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('"rabbit bait"' IN boolean mode);

# 匹配rabbit和carrot，增加前者的等级，降低后者的等级
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('>rabbit <carrot' IN boolean mode);

# 必须匹配词safe和combination，降低后者的等级
SELECT note_text FROM productnotes WHERE MATCH(note_text) against('+safe +(<combination)' IN boolean mode);


#############################
# 第19章 插入数据 
#############################

-- 插入完整的行 
# 插入一个新客户到customers表
# 简单但不安全，如果原来表列结构调整，会有问题 
INSERT INTO customers values (null,'Pep E. LaPew','100 MaIN Street','Los Angeles','CA','90046','USA',NULL,NULL);
# 表明括号内明确列名，更安全，稍繁琐 
INSERT INTO customers (cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry,cust_contact,cust_email)
values ('Pep E. LaPew','100 MaIN Street','Los Angeles','CA','90046','USA',NULL,NULL);

-- 插入多个行 
# 方法1： 提交多个INSERT 语句
INSERT INTO customers(cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry)
values('Pep E. LaPew','100 MaIN Street','Los Angeles','CA','90046','USA');
INSERT INTO customers(cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry)
values('M. Martian','42 Galaxy Way','New York','NY','11213','USA');
# 方法2： 只要每条INSERT语句中的列名（和次序）相同，可以如下组合各语句
# 单条INSERT语句有多组值，每组值用一对圆括号括起来，用逗号分隔
INSERT INTO customers(cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry)
values('Pep E. LaPew','100 MaIN Street','Los Angeles','CA','90046','USA'),('M. Martian','42 Galaxy Way','New York','NY','11213','USA');

-- 插入检索出来的值 
# 新建custnew表（非书本内容）
CREATE TABLE `custnew` (
  `cust_id` int(11) NOT NULL AUTO_inCREMENT,
  `cust_name` char(50) NOT NULL,
  `cust_address` char(50) DEFAULT NULL,
  `cust_city` char(50) DEFAULT NULL,
  `cust_state` char(5) DEFAULT NULL,
  `cust_zip` char(10) DEFAULT NULL,
  `cust_COUNTry` char(50) DEFAULT NULL,
  `cust_contact` char(50) DEFAULT NULL,
  `cust_email` char(255) DEFAULT NULL,
  PRIMARY KEY (`cust_id`)
) ENGinE=innoDB;

# 在表custnew中插入一行数据 （非书本内容）
INSERT INTO custnew (cust_id,cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry)
values(null,null,'mysql carsh course@learning.com','Y.CARY','BAKE WAY','NEW YorK','NY','112103','USA');

# 将custnew中内容插入到customers表中 
# 同书本代码不同，这里省略了custs_id,这样MySQL就会生成新值。
INSERT INTO customers (cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry)
SELECT cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_COUNTry FROM custnew;


#############################
# 第20章 更新和删除数据 
#############################

-- update语句 : 删除或更新指定列 
# 更新： 客户10005现在有了电子邮件地址
update customers set cust_email = 'elmer@fudd.com' WHERE cust_id = 10005;
# 更新： 多个列 
UPDATE customers 
SET cust_name = 'The Fudds',
    cust_email = 'elmer@fudd.com'
WHERE cust_id = 10005;

# 删除： 某个列的值，可设置它为NULL（假如表定义允许NULL值）
update customers set cust_email = null WHERE cust_id = 10005;

-- delete 语句： 删除整行而不是某列 
# 从customers表中删除一行
delete FROM customers WHERE cust_id = 10006;

-- truncate table语句 
# 如果想从表中删除 所有行，不要使用DELETE，可使用TRUNCATE TABLE语句
# TRUNCATE实际是删除原来的表并重新创建一个表，而不是逐行删除表中的数据


#############################
# 第21章 创建和操纵表  
#############################

-- 新建表 CREATE table
# 参书本配套文件CREATE.sql

-- 更新表 alter table 
# 给vendors表增加一个名为vend_phone的列
alter table vendors 
add vend_phone char(20);
# 删除刚刚添加的列
alter table vendors
drop column vend_phone;

# ALTER TABLE的一种常见用途是定义外键
# 以下为书本配套文件CREATE.sql中定义外键的语句 
ALTER TABLE orderitems ADD CONSTRAinT fk_orderitems_orders ForEIGN KEY (order_num) REFERENCES orders (order_num);
ALTER TABLE orderitems ADD CONSTRAinT fk_orderitems_products ForEIGN KEY (prod_id) REFERENCES products (prod_id);
ALTER TABLE orders ADD CONSTRAinT fk_orders_customers ForEIGN KEY (cust_id) REFERENCES customers (cust_id);
ALTER TABLE products ADD CONSTRAinT fk_products_vendors ForEIGN KEY (vend_id) REFERENCES vendors (vend_id);

-- 删除表
# 删除customers2表（假设它存在）
drop table customers2;

-- 重命名表 
# 使用RENAME TABLE语句可以重命名一个表 (假设存在下述表)
rename table customers2 to customers;
# 对多个表重命名(假设存在下述表)
rename table backup_customers to customer,
             backup_vendors to vendors,
             backup_products to products;


#############################
# 第22章 使用视图   
#############################

/*视图提供了一种MySQL的SELECT语句层次的封装，可用来简化数据处理以及重新格式化基础数据或保护基础数据。 */ 

-- 创建视图 CREATE view
-- 创建视图的语句 show CREATE view viewname
-- 删除视图 drop view viewname
-- 更新视图 1. 先drop后CREATE 2. 直接用CREATE OR repalce view

# 创建一个名为productcustomers的视图
CREATE view productcustomers as
SELECT cust_name,cust_contact,prod_id
FROM customers,orders,orderitems
WHERE customers.cust_id = orders.cust_id
AND orders.order_num = orderitems.order_num;
# 检索订购了产品TNT2的客户
SELECT cust_name,cust_contact FROM productcustomers WHERE prod_id = 'TNT2';

# 用视图重新格式化检索出的数据
# (来自第10章）在单个组合计算列中返回供应商名和位置
SELECT concat(rtrim(vend_name),' (',rtrim(vend_COUNTry),')') AS vend_title FROM vendors ORDER BY vend_name;
# 若经常使用上述格式组合，可以创建视图 
CREATE view vendorlocations as
SELECT concat(rtrim(vend_name),' (',rtrim(vend_COUNTry),')') AS vend_title FROM vendors ORDER BY vend_name;
# 检索出以创建所有邮件标签的数据
SELECT * FROM vendorlocations;

# 用视图过滤不想要的数据
# 定义customeremaillist视图，它过滤没有电子邮件地址的客户
CREATE view customeremaillist as 
SELECT cust_id,cust_name,cust_email FROM customers
WHERE cust_email is NOT null;
SELECT * FROM customeremaillist;

# 使用视图与计算字段
# (来自第10章）检索某个特定订单中的物品，计算每种物品的总价格
SELECT prod_id,quantity,item_price,quantity*item_price AS expANDed_price FROM orderitems WHERE order_num = 20005;
# 将其转换为一个视图
CREATE view orderitemsexpANDed as 
SELECT order_num,prod_id,quantity,item_price,quantity*item_price AS expANDed_price FROM orderitems;
# 创建视图的时候SELECT添加了列名order_num,否则无法按照order_num进行过滤查找 
SELECT * FROM orderitemsexpANDed WHERE order_num = 20005;

# 更新视图 
# 视图中虽然可以更新数据，但是有很多的限制。
# 一般情况下，最好将视图作为查询数据的虚拟表，而不要通过视图更新数据


#############################
# 第23章 使用存储过程    
#############################

-- 创建存储过程 
# 返回产品平均价格的存储过程
delimiter //
CREATE procedure productpricing()
begin
    SELECT avg(prod_price) AS priceaverage FROM products;
end //
delimiter ;
# 调用上述存储过程 
call productpricing();

-- 删除存储过程,请注意:没有使用后面的()，只给出存储过程名。
drop procedure productpricing;

-- 使用参数 out
# 重新定义存储过程productpricing
delimiter //
CREATE procedure productpricing(out pl decimal(8,2), out ph decimal(8,2), out pa decimal(8,2))
begin
    SELECT min(prod_price) INTO pl FROM products;
    SELECT max(prod_price) INTO ph FROM products;
    SELECT avg(prod_price) INTO pa FROM products;
end //
delimiter ;

# 为调用上述存储过程，必须指定3个变量名
call productpricing(@pricelow,@pricehigh,@priceaverage);
# 显示检索出的产品平均价格
SELECT @priceaverage;
# 获得3个值
SELECT @pricehigh,@pricelow,@priceaverage;

-- 使用参数 IN 和 out
# 使用in和OUT参数,存储过程ordertotal接受订单号并返回该订单的合计
delimiter //
CREATE procedure ordertotal(
    IN onumber int,                   # onumber定义为in，因为订单号被传入存储过程
    out ototal decimal(8,2)            # ototal为OUT，因为要从存储过程返回合计
)
begin
    SELECT sum(item_price*quantity) FROM orderitems 
    WHERE order_num = onumber
    INTO ototal;
end //
delimiter ;
# 给ordertotal传递两个参数；
# 第一个参数为订单号，第二个参数为包含计算出来的合计的变量名
call ordertotal(20005,@total);
# 显示此合计
SELECT @total;
# 得到另一个订单的合计显示
call ordertotal(20009,@total);
SELECT @total;

-- 建立智能存储过程 
# 获得与以前一样的订单合计，但只针对某些顾客对合计增加营业税

-- Name:ordertotal
-- Parameters: onumber = order number
--                taxable = 0 if NOT taxable, 1 if taxable
--                ototal  = order total variable
delimiter //
CREATE procedure ordertotal(
    IN onumber int,
    IN taxable boolean,
    out ototal decimal(8,2)
) comment 'obtaIN order total, optionally adding tax'
begin
    -- declare variable fOR total 定义局部变量total
    declare total decimal(8,2);
    -- declare tax percentage 定义局部变量税率 
    declare taxrate int default 6;
    -- get the order total 获得订单合计
    SELECT SUM(item_price * quantity)
    FROM orderitems
    WHERE order_num = onumber INTO total;
    -- is this taxable? 是否要增加营业税？ 
    if taxable then
        -- Yes,so add taxrate to the total 给订单合计增加税率
        SELECT total+(total/100*taxrate) INTO total;
    end if;
    -- AND finally,save to out variable 最后，传递给输出变量 
    SELECT total INTO ototal;
END //
delimiter ;
# 调用上述存储过程，不加税 
call ordertotal(20005,0,@total);
SELECT @total;
# 调用上述存储过程，加税 
call ordertotal(20005,1,@total);
SELECT @total;

# 显示用来创建一个存储过程的CREATE语句
show CREATE procedure ordertotal;

# 获得包括何时、由谁创建等详细信息的存储过程列表
# 该语句列出所有存储过程
show procedure status;
# 过滤模式 
show procedure status LIKE 'ordertotal';


#############################
# 第24章 使用游标     
#############################

-- 创建、打开、关闭游标 
# 定义名为ordernumbers的游标，检索所有订单
delimiter //
CREATE procedure processorders()
begin
    -- decalre the cursOR 声明游标 
    declare ordernumbers cursor
    for
    SELECT order_num FROM orders;
    
    -- open the cursOR 打开游标
    open ordernumbers;
    -- close the cursOR 关闭游标
    close ordernumbers;
end //
delimiter ;

-- 使用游标数据 
# 例1：检索 当前行 的order_num列，对数据不做实际处理
delimiter //
CREATE procedure processorders()
begin

    -- declare local variables 声明局部变量
    declare o int;
    
    -- decalre the cursOR 声明游标 
    declare ordernumbers cursor
    for
    SELECT order_num FROM orders;
    
    -- open the cursOR 打开游标
    open ordernumbers;
    
    -- get order number 获得订单号 
    fetch ordernumbers INTO o;
    /*fetch检索 当前行 的order_num列（将自动从第一行开始）到一个名为o的局部声明变量中。
    对检索出的数据不做任何处理。*/
        
    -- close the cursOR 关闭游标
    close ordernumbers;

END //
delimiter ;

# 例2：循环检索数据，从第一行到最后一行，对数据不做实际处理
delimiter //
CREATE procedure processorders()
begin
    -- declare local variables 声明局部变量
    declare done boolean default 0;
    declare o int;
   
    -- decalre the cursOR 声明游标 
    declare ordernumbers cursor
    for
    SELECT order_num FROM orders;
   
    -- declare continue hANDler
    declare continue hANDler fOR sqlstate '02000' set done =1;
    -- SQLSTATE '02000'是一个未找到条件，当REPEAT由于没有更多的行供循环而不能继续时，出现这个条件。
    
    -- open the cursOR 打开游标
    open ordernumbers;
    
    -- loop through all rows 遍历所有行 
    repeat
    
    -- get order number 获得订单号 
    fetch ordernumbers INTO o;
    -- FETCH在REPEAT内，因此它反复执行直到done为真
    
    -- end of loop
    until done end repeat;
    
    -- close the cursOR 关闭游标
    close ordernumbers;

end //
delimiter ;


# 例3：循环检索数据，从第一行到最后一行，对取出的数据进行某种实际的处理
delimiter //
CREATE procedure processorders()
begin
    -- declare local variables 声明局部变量 
    declare done boolean default 0;
    declare o int;
    declare t decimal(8,2);
    
    -- declare the cursOR 声明游标
    declare ordernumbers cursor
    for
    SELECT order_num FROM orders;
    
    -- declare continue hANDler
    declare continue hANDler fOR sqlstate '02000' set done = 1;
    
    -- CREATE a table to store the results 新建表以保存数据
    CREATE table if NOT exists ordertotals
    (order_num int,total decimal(8,2));
    
    -- open the cursOR 打开游标
    open ordernumbers;
    
    -- loop through all rows 遍历所有行
    repeat
    
    -- get order number 获取订单号
    fetch ordernumbers INTO o;
    
    -- get the total fOR this order 计算订单金额
    call ordertotal(o,1,t);  # 参见23章代码，已创建可使用
    
    -- INSERT order AND total INTO ordertotals 将订单号、金额插入表ordertotals内
    INSERT INTO ordertotals(order_num,total) values(o,t);
    
    -- end of loop
    until done end repeat;
    
    -- close the cursOR 关闭游标
    close ordernumbers;

end // 
delimiter ;
# 调用存储过程 precessorders()
call processorders();
# 输出结果
SELECT * FROM ordertotals;


#############################
# 第25章 使用触发器      
#############################

-- 创建触发器 
CREATE trigger newproduct after INSERT on products fOR each row SELECT 'product added' INTO @new_pro;
# mysql 5.0以上版本在TRIGGER中不能返回结果集，定义了变量 @new_pro;
INSERT INTO products(prod_id,vend_id,prod_name,prod_price) values ('ANVNEW','1005','3 ton anvil','6.09'); # 插入一行 
SELECT @new_pro;  # 显示Product added消息

-- 删除触发器 
drop trigger newproduct;

-- 使用触发器 
# INSERT触发器
CREATE trigger neworder after INSERT on orders fOR each row SELECT new.order_num INTO @order_num;
INSERT INTO orders(order_date,cust_id) values (now(),10001);
SELECT @order_num;

# delete触发器
# 使用OLD保存将要被删除的行到一个存档表中 
delimiter //
CREATE trigger deleteorder before delete on orders fOR each row
begin
    INSERT INTO archive_orders(order_num,order_date,cust_id)
    values(old.order_num,old.order_date,old.cust_id); # 引用一个名为OLD的虚拟表，访问被删除的行
end //
delimiter ;

# update触发器
# 在更新vendors表中的vend_state值时，插入前先修改为大写格式 
CREATE trigger updatevendOR before update on vendors 
fOR each row set new.vend_state = upper(new.vend_state);
# 更新1001供应商的州为china
update vendors set vend_state = 'china' WHERE vend_id =1001;
# 查看update后数据，1001供应商对应的vend_state自动更新为大写的CHinA
SELECT * FROM vendors;


#############################
# 第26章 管理事务处理 
#############################

-- 事务 transaction 指一组sql语句
-- 回退 rollback 指撤销指定sql语句的过程
-- 提交 commit 指将未存储的sql语句结果写入数据库表
-- 保留点 savepoint 指事务处理中设置的临时占位符，可以对它发布回退（与回退整个事务处理不同）

-- 控制事务处理
# 开始事务及回退 
SELECT * FROM ordertotals;   # 查看ordertotals表显示不为空
start transaction;           # 开始事务处理 
delete FROM ordertotals;     # 删除ordertotals表中所有行
SELECT * FROM ordertotals;   # 查看ordertotals表显示 为空
rollback;                     # rollback语句回退 
SELECT * FROM ordertotals;   # rollback后，再次查看ordertotals表显示不为空

# commit 提交 
start transaction;
delete FROM orderitems WHERE order_num = 20010;
delete FROM orders WHERE order_num = 20010;
commit;   # 仅在上述两条语句不出错时写出更改 

# savepoint 保留点 
# 创建保留点
savepoint delete1;
# 回退到保留点 
rollback to delete1;
# 释放保留点 
release savepoint delete1;

-- 更改默认的提交行为 
set autocommit = 0;  # 设置autocommit为0（假）指示MySQL不自动提交更改


#############################
# 第27章 全球化和本地化
#############################

-- 字符集和校对顺序
# 查看所支持的字符集完整列表
show character set;
# 查看所支持校对的完整列表,以及它们适用的字符集
show collation;
# 确定所用系统的字符集和校对
show variables LIKE 'character%';
show variables LIKE 'collation%';
# 使用带子句的CREATE TABLE，给表指定字符集和校对
CREATE table mytable
(
    column1 int,
    column2 varchar(10)
) default character set hebrew 
  collate hebrew_general_ci;
# 除了能指定字符集和校对的表范围外，MySQL还允许对每个列设置它们
CREATE table mytable
(
    column1 int,
    column2 varchar(10),
    column3 varchar(10) character set latin1 collate latin1_general_ci
)default character set hebrew 
 collate hebrew_general_ci;
# 校对collate在对用ORDER BY子句排序时起重要的作用
# 如果要用与创建表时不同的校对顺序排序,可在SELECT语句中说明 
SELECT * FROM customers ORDER BY lastname,firstname collate latin1_general_cs;


#############################
# 第28章 安全管理
#############################

-- 管理用户
# 需要获得所有用户账号列表时
# mysql数据库有一个名为user的表，它包含所有用户账号。user表有一个名为user的列
use mysql;
SELECT user FROM user;

-- 创建用户账号 
# 使用CREATE user
CREATE user ben identified by 'p@$$w0rd';
# 重命名一个用户账号
rename user ben to bforta;
# 删除用户账号 
drop user bforta;
# 查看赋予用户账号的权限
show grants fOR bforta;
# 允许用户在（crashcourse数据库的所有表）上使用SELECT，只读
grant SELECT on crashcourse.* to bforta;
# 重新查看赋予用户账号的权限，发生变化 
show grants fOR bforta;
# 撤销特定的权限
revoke SELECT on crashcourse.* FROM bforta;
# 简化多次授权
grant SELECT,INSERT on crashcourse.* to bforta;

-- 更改口令

# 原来课本中使用的password()加密函数，在8.0版本中已经移除 
# password() :This function wAS removed IN MySQL 8.0.11.
set password fOR bforta = 'n3w p@$$w0rd';  


-- 如果不指定用户名，直接修改当前登录用户的口令 
set password = 'n3w p@$$w0rd';


#############################
# 第29章 数据库维护 
#############################

# 分析表 键状态是否正确
analyze table orders;
# 检查表是否存在错误 
check table orders,orderitems;
check table orders,orderitems quick; # QUICK只进行快速扫描
# 优化表OPTIMIZE TABLE，消除删除和更新造成的磁盘碎片，从而减少空间的浪费
optimize table orders;
 
————————————————
版权声明：本文为CSDN博主「ShinyCC」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_40159138/java/article/details/90075289