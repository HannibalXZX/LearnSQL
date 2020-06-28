SELECT @@profiling; -- 查看mysql的资源消耗情况

SET profiling=1;

SELECT * FROM student;

DESC student;

SELECT name FROM student;

show profiles; -- 查看当前会话产生的profiles

SHOW profile; -- 获取上一次查询的执行时间alter

SHOW profile for query 2; -- 指定的query时长

SELECT version();