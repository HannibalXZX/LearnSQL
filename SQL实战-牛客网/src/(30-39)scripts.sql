###########################################
# intro: 牛客网中的SQL实战 30-29 题答案与过程
# url : https://www.nowcoder.com/ta/sql
# author:shaw
# date : 2020-07-09
############################################

### 题号查找：ex_题号

########
# ex_30、子查询的方式找出属于Action分类的所有电影对应的title,description
SELECT title, description
FROM film, film_category fc
WHERE film.film_id = fc.film_id
AND fc.category_id = (
SELECT category_id FROM category
WHERE name = "Action"
);

SELECT f.title,f.description FROM film AS f
WHERE f.film_id
IN (
     SELECT fc.film_id FROM film_category AS fc
     WHERE fc.category_id IN (
                               SELECT c.category_id FROM category as c
                               WHERE c.name = 'Action'));


