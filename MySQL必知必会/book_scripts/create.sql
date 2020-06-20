########################################
# MySQL Crash Course
# http://www.forta.com/books/0672327120/
# Example table creation scripts
########################################


########################
# Create customers table
# 创建顾客表
########################
CREATE TABLE customers
(
  cust_id      int       NOT NULL AUTO_INCREMENT, -- 唯一的顾客ID
  cust_name    char(50)  NOT NULL , -- 顾客名
  cust_address char(50)  NULL , -- 顾客的地址
  cust_city    char(50)  NULL , -- 顾客的城市
  cust_state   char(5)   NULL , -- 顾客的州
  cust_zip     char(10)  NULL , -- 顾客的邮政编码
  cust_country char(50)  NULL , -- 顾客的城市
  cust_contact char(50)  NULL , -- 顾客的联系名
  cust_email   char(255) NULL , -- 顾客的联系email地址
  PRIMARY KEY (cust_id)
) ENGINE=InnoDB;

#########################
# Create orderitems table
# 创建 每个订单的实际物品
#########################
CREATE TABLE orderitems
(
  order_num  int          NOT NULL , -- 订单号（关联到orders表的order_num）
  order_item int          NOT NULL , -- 订单物品号（在某个订单的顺序，第一个物品，第二个物品）
  prod_id    char(10)     NOT NULL , -- 产品ID（关联到products表的prod_id）
  quantity   int          NOT NULL , -- 物品数量
  item_price decimal(8,2) NOT NULL , -- 物品价格
  PRIMARY KEY (order_num, order_item)
) ENGINE=InnoDB;


#####################
# Create orders table
# 创建顾客订单，不是订单细节
#####################
CREATE TABLE orders
(
  order_num  int      NOT NULL AUTO_INCREMENT, -- 唯一的订单号
  order_date datetime NOT NULL , -- 订单日期
  cust_id    int      NOT NULL , -- 订单顾客ID（关系到customers表的cust_id）
  PRIMARY KEY (order_num)
) ENGINE=InnoDB;

#######################
# Create products table
# 创建产品表
#######################
CREATE TABLE products
(
  prod_id    char(10)      NOT NULL, -- 唯一的产品ID
  vend_id    int           NOT NULL , -- 产品供应商的ID（关联到vendors表中vend_id）
  prod_name  char(255)     NOT NULL , -- 产品名
  prod_price decimal(8,2)  NOT NULL , -- 产品价格
  prod_desc  text          NULL , -- 产品描述
  PRIMARY KEY(prod_id)
) ENGINE=InnoDB;

######################
# Create vendors table
# 创建供应商表
######################
CREATE TABLE vendors
(
  vend_id      int      NOT NULL AUTO_INCREMENT, -- 唯一的供应商ID
  vend_name    char(50) NOT NULL , -- 供应商名
  vend_address char(50) NULL , -- 供应商地址
  vend_city    char(50) NULL , -- 供应商城市
  vend_state   char(5)  NULL , -- 供应商的州
  vend_zip     char(10) NULL , -- 邮政编码
  vend_country char(50) NULL , -- 供应商的国家
  PRIMARY KEY (vend_id)
) ENGINE=InnoDB;

###########################
# Create productnotes table
# 存储与特定产品有关的注释，并非所有产品都有有关注释
###########################
CREATE TABLE productnotes
(
  note_id    int           NOT NULL AUTO_INCREMENT, -- 唯一的注释ID
  prod_id    char(10)      NOT NULL, -- 产品ID
  note_date datetime       NOT NULL, -- 增加注释的日期
  note_text  text          NULL , -- 注释的文本
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
) ENGINE=MyISAM;
# 因为是使用全文本搜索，因此必须指定ENGINE=MyISAM

#####################
# Define foreign keys
#####################
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_num) REFERENCES orders (order_num);
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_products FOREIGN KEY (prod_id) REFERENCES products (prod_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_customers FOREIGN KEY (cust_id) REFERENCES customers (cust_id);
ALTER TABLE products ADD CONSTRAINT fk_products_vendors FOREIGN KEY (vend_id) REFERENCES vendors (vend_id);