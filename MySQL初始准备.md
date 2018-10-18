#MySQL安装

1. 用管理员方式打开dos窗口
2. mysqld --initialize --console 记录这时出现的temp密码
3. mysql install 安装软件
4. net start mysql 启动MySQL服务,用来连接

5.修改密码 

登录前:mysqladmin -u用户名 -p临时密码 password 新密码
登入MySQL后:set password for root@localhost = password('新密码')

#sql语言分类

1. 查询语言DQL

select 字段 from 表名;

2. 操作语言DML

insert into 表名 (字段) values (字段对应的值);
delete from 表名 where 过滤条件; ->"不接where就清空表数据"
update set 表名 字段=值 where 过滤条件; ->"不接where就全更新表数据"

3. 定义语言DDL

表和数据库结构的增删改:create,drop,alter

4. 事务控制TCL

开始事务:start transaction
事务完结:1.成功 commit
		2.失败 rollback
		
5. 数据控制语言

数据控制语句，用于控制不同数据段直接的许可和访问级别的语句。这些语句定义了数据库、表、字段、用户的访问权限和安全级别。主要的语句关键字包括 grant、revoke 等。
-grant、revoke
#查看表结构
-desc 表名;
#show

1. show tables或show tables from database_name; -- 显示当前数据库中所有表的名称。 
2. show databases; -- 显示mysql中所有数据库的名称。 
3. show columns from table_name from database_name; 或show columns from database_name.table_name; -- 显示表中列名称。 
4. show grants for user_name; -- 显示一个用户的权限，显示结果类似于grant 命令。 
5. show index from table_name; -- 显示表的索引。 
6. show status; -- 显示一些系统特定资源的信息，例如，正在运行的线程数量。 
7. show variables; -- 显示系统变量的名称和值。 
8. show processlist; -- 显示系统中正在运行的所有进程，也就是当前正在执行的查询。大多数用户可以查看他们自己的进程，但是如果他们拥有process权限，就可以查看所有人的进程，包括密码。 
9. show table status; -- 显示当前使用或者指定的database中的每个表的信息。信息包括表类型和表的最新更新时间。 
10. show privileges; -- 显示服务器所支持的不同权限。 
11. show create database database_name; -- 显示create database 语句是否能够创建指定的数据库。 
12. show create table table_name; -- 显示create database 语句是否能够创建指定的数据库。 
13. show engines; -- 显示安装以后可用的存储引擎和默认引擎。 
14. show innodb status; -- 显示innoDB存储引擎的状态。 
15. show logs; -- 显示BDB存储引擎的日志。 
16. show warnings; -- 显示最后一个执行的语句所产生的错误、警告和通知。 
17. show errors; -- 只显示最后一个执行语句所产生的错误。 
18. show [storage] engines; --显示安装后的可用存储引擎和默认引擎。