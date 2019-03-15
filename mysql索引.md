## MySQL索引

1.尽量通过主键查询,因为主键自动添加索引,效率较高.
2.索引是表的一部分,也是存在硬盘文件中.
3.mysql常用检索方法
	- 全剧扫描
	-利用索引
4.一张表的所有字段都可以加索引

## 索引的使用场景
	-该字段数据量庞大
	-该字段很少尽心DML操作,因为dml要更新索引
	-该字段经常出现在where中当做过滤条件
## 创建索引
	create index dept_dname_index on dept (dname);
	create unique index dept_dname_index on dept(dname);

## 删除索引
	drop index dept_dname_index on dept;

## 视图(虚拟表)
create view view_name as select * from user;

1. 提高检索效率
2. 隐藏表的细节

## 导出数据库和表

1.导出数据库
	mysqldump 数据库名字>D:\hello.sql -uroot -p
2.导出单独表
	mysqldump 数据库名字 表名>D:\hello.sql -uroot -p

3.导入
	source 加sql文件路径
