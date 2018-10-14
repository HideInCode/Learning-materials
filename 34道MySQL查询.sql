1.取得每个部门薪水最高的人员名称

a.选出每个部门最高薪水
select deptno,max(sal) maxsal from emp group by deptno;
+--------+---------+
| deptno | maxsal  |
+--------+---------+
|     20 | 3000.00 |
|     30 | 2850.00 |
|     10 | 5000.00 |
+--------+---------+
b.把结果集作为临时表t和emp e连接,条件:t.deptno = e.deptno and t.maxsal=e.sal
SELECT
	e.ename NAME,
	t.maxsal,
	d.dname deptname 
FROM
	emp e
	JOIN ( SELECT deptno, max( sal ) maxsal FROM emp GROUP BY deptno ) t ON t.deptno = e.deptno 
	AND t.maxsal = e.sal
	JOIN dept d ON t.deptno = d.deptno;
2.那些人的薪水在部门平均水平以上
select deptno,avg(sal) avgsal from emp group by deptno; t
+--------+-------------+
| deptno | avgsal      |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+

select 
	e.ename name,e.deptno,e.sal
from 
	emp e join (select deptno,avg(sal) avgsal from emp group by deptno) t 
on e.sal > t.avgsal and t.deptno=e.deptno;

3.取得部门中的平均薪水等级(所有人)
select deptno, avg(sal) avgsal from emp group by deptno;

select 
	t.deptno deptno,s.grade grade 
from 
	(select deptno, avg(sal) avgsal from emp group by deptno) t join salgrade s on t.avgsal between losal and hisal;
4.取得部门中所有人的薪水等级,并对部门薪水等级求平均
select e.deptno dept,e.ename name,e.sal salary,s.grade grade from emp e join salgrade s on e.sal between s.losal and hisal; t
select t.dept, avg(t.grade) avg_grade from (select e.deptno dept,e.ename name,e.sal salary,s.grade grade from emp e join salgrade s on e.sal between s.losal and hisal) t group by t.dept;
上面语句等价于
select e.deptno dept,avg(s.grade) from emp e join salgrade s on e.sal between s.losal and hisal group by e.deptno;
4.不用聚合函数,取得最高薪水,使用两种方法解决
select ename,sal from emp order by sal desc limit 1;
	自连接(双重select就是两个for,而join后面的是外循环,就是说join就是添加外循环)

select a.sal sal_a,b.sal sal_b from emp a join emp b on a.sal < b.sal;
select sal from emp where sal not in (select distinct a.sal sal_a from emp a join emp b on a.sal < b.sal);


select a.sal ,b.sal from emp b join emp a on b.sal < a.sal;

5.取得平均薪水最高的部门的部门编号(2种方案)
//可能有相等数据,取第一个可能会错误,所以要根据deptno找到重复的max
1.select deptno,avg(sal) avgsal from emp group by deptno order by avgsal desc limit 1;
1.select 
	deptno,avg(sal) as avgsal
from 
	emp 
group by 
	deptno
having 
	avg(sal) = (select avg(sal) avgsal from emp group by deptno order by avgsal desc limit 1);
2.聚合函数max
select 
	deptno,avg(sal) avgsal
from 
	emp
group by 
	deptno
having
	avg(sal) = (select max(t.avgsal) from (select deptno,avg(sal) avgsal from emp group by deptno ) t);
6.取得平均薪水最高的部门的部门名称
select 
	d.dname,m.avgsal
from
	dept d
join 
	(select 
	deptno,avg(sal) avgsal
from 
	emp
group by 
	deptno
having
	avg(sal) = (select max(t.avgsal) from (select deptno,avg(sal) avgsal from emp group by deptno ) t)) m
	on m.deptno=d.deptno;
7.求平均薪水的等级最高的部门名称

1.求各个部门平均薪水的等级(结果只有部门名称.平均薪水,等级三个字段)
select t.avgsal,s.grade,t.dname from 
(select d.dname dname,avg(e.sal) avgsal from emp e join dept d on e.deptno=d.deptno group by dname) t
join salgrade s
on t.avgsal between s.losal and s.hisal;
2.获取最高等级值
select max(s.grade) from 
(select deptno,avg(sal) avgsal from emp group by deptno) t
join salgrade s
on t.avgsal between s.losal and s.hisal;
3.联合上两张表 给出avgsal,dname,grade,满足平均值为最大值
select t.avgsal,s.grade,t.dname from 
(select d.dname dname,avg(e.sal) avgsal from emp e join dept d on e.deptno=d.deptno group by dname) t
join salgrade s
on t.avgsal between s.losal and s.hisal
where
	s.grade=(select max(s.grade) from 
(select deptno,avg(sal) avgsal from emp group by deptno) t
join salgrade s
on t.avgsal between s.losal and s.hisal);

8.取得比普通员工(员工代码没有在mgr字段上出现的)的最高薪水还要高的姓名
1.先找到普通员工(注意not in (不能有null))
select * from emp where empno  not in (select distinct mgr from emp where mgr is not null)

2.找出普通员工最高薪水
select max(sal) from emp where empno not in (select distinct mgr from emp where mgr is not null)
3.找出薪水高于1600
select ename ,sal from emp 
where sal > (select max(sal) from emp where empno not in (select distinct mgr from emp where mgr is not null));


补充学习:
select 
	ename,sal,(case job when 'manager' then sal * 0.8 when 'salesman' then sal*1.5 end) newsal from emp;
	
9.取得薪水最高的前五
10.取得薪水最高的第六名到第十名
11取得最后入职的5名员工
12.取得每个薪水等级有多少个员工	
select e.ename, e.sal, s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal;
select t.sgrade ,count(*) from (select e.ename, e.sal, s.grade sgrade from emp e join salgrade s on e.sal between s.losal and s.hisal) t group by t.sgrade

select 
	count(*), s.grade 
from emp e join salgrade s on e.sal between s.losal and s.hisal
group by s.grade;
13.面试题
有3个表s(学生表),c(课程表),sc(学生选课表)
s(sno,sname) 代表 (学号,姓名)
c(cno,cname,cteacher) 代表(课号,课名,教师)
sc(sno,cno,scgrade)代表 (学号,课号,成绩)
问题
1.找出没选过"黎明"老师的所有学生姓名
	1.肯定要用补集求解,所以先求黎明苏所在表的相关信息
	select cno,cname from c where cteacher='黎明';
	2.选了晓组织的人
	select sno from sc where cno = (select cno from c where cteacher='黎明');
	 3.不在晓组织的人
	 select sname from s where sno not in (select sno from sc where cno = (select cno from c where cteacher='黎明'))
2.列出2门以上(含2门) 不及格学生姓名及他的所有成绩的平均成绩
	1.先选出2门不及格的学生
	select sno from sc where scgrade < 60 group by sno having count(*)>=2 ;
	2.连接s取姓名
	select s.sname from sc join s on sc.sno = s.sno where sc.scgrade < 60 group by s.sname having count(*)>=2 ;
	3.算出每个学生的平均成绩跟不及格的姓名连接(下面这个做法不行,因为其他成绩已经过滤掉了,只会求不及格成绩的平均线)
	select s.sname name, avg(sc.scgrade) avgscore from sc join s on sc.sno = s.sno where sc.scgrade < 60 group by s.sname having count(*)>=2 ;

	(求出所有学生平均成绩)
	select sc.sno,avg(sc.scgrade) avgscore from sc group  by sc.sno;
	select sno,avg(sc.scgrade) avgscore from sc group  by sno;

		SELECT
		t1.NAME NAME,
		t2.avgscore avgscore 
	FROM
		(
		SELECT
			s.sname NAME,
			s.sno sno 
		FROM
			sc
			JOIN s ON sc.sno = s.sno 
		WHERE
			sc.scgrade < 60 GROUP BY NAME, sno HAVING count( * ) >= 2 
		) t1
		JOIN ( SELECT sc.sno sno, avg( sc.scgrade ) avgscore FROM sc GROUP BY sc.sno ) t2 ON t1.sno = t2.sno 
	GROUP BY
		t1.sno;
	
3.即学过1号课程又学过2号课程所有学生的姓名
	1.学过1号课程的所有学生(sname,cno)
	select s.sname sname,sc.cno cno from sc join s on s.sno=sc.sno where cno = 1;
	2.学过2号课程的所有学生(sname,cno)
	select s.sname sname,sc.cno cno from sc join s on s.sno=sc.sno where cno=2;
	
	3.求交集
	select t1.sname sname from (select s.sname sname,sc.cno cno from sc 
	join s on s.sno=sc.sno where cno = 1) t1 
	join (select s.sname sname,sc.cno cno from sc join s on s.sno=sc.sno where cno=2) t2 on t1.sname = t2.sname;
14.列出所有员工和领导的名字
 列出所有的领导,not in 领导就是员工(自连接)
 select distinct a.empno,a.ename,b.mgr from emp a join emp b on a.empno =b.mgr;//所有的领导
 select ename from emp where ename not in (select distinct a.ename from emp a join emp b on a.empno =b.mgr)
 
 这个地方我的理解有问题,我认为没有领导的员工是员工,但是题目意思是有的人都是员工,所以有:
 select a.ename empname,b.ename boss from emp a left join emp b on a.mgr=b.empno;
 15.找出入职日期早于其直接领导的员工编号,姓名,部门名称
	 1
				SELECT
			t.adno,
			t.aname,
			d.dname 
		FROM
			(
			SELECT
				a.empno eno,
				a.ename aname,
				a.hiredate ahdate,
				a.deptno adno,
				b.hiredate bhdate 
			FROM
				emp a
				LEFT JOIN emp b ON a.mgr = b.empno 
			) t
			JOIN dept d ON d.deptno = t.adno 
		WHERE
			t.ahdate < t.bhdate
			2.老司机做法选出员工直接老板和各自的入职日期,通过where筛选
			select a.empno aempno, a.ename aename,d.dname ddname, 
					b.empno bempno, b.ename bename
			from 
			
			emp a join emp b on a.mgr = b.empno
			join dept d on d.deptno = a.deptno
			
			where
			
			a.hiredate<b.hiredate;
16.列出部门名称和这些部门员工信息,同时列出没有员工的部门
select d.dname,e.* from emp e right join dept d on e.deptno=d.deptno order by d.dname asc;
17.列出至少有5个员工的所有部门(什么这里select后可以有groupby没有的东西)
select dept.*,emp.deptno,count(*) from emp join dept on emp.deptno = dept.deptno group by dept.deptno having count(*) >=5;
18.列出薪资比simith高的员工的个人信息
select * from emp where sal > (select sal from emp where ename='simith');
19.列出所有clerk职位的员工姓名,部门名称,部门人数
select e.ename ename,d.dname ddname, t.countall from emp e join dept d on d.deptno = e.deptno join (select e.deptno, count(*) countall from  emp e  group by e.deptno) t on t.deptno = d.deptno
where job='clerk' ;
select e.deptno, count(*) countall from  emp e group by e.deptno;
		
20.列出最低薪资大于1500的各工种及从事此工作的全部员工人数
select job,min(sal) minsal,count(*) from emp group by job having minsal >1500;

 21.在不知道部门编号的情况下列出sales部门的员工姓名
 这题又理解错误,emp的deptno是知道的,只有dept表中deptno不知道
 select deptno from dept where dname='sales';
 select ename from emp where deptno = ( select deptno from dept where dname='sales');
 22.列出薪资高于公司平均薪资的所有员工,所在部门,上级领导,员工的工资等级
 (这里注意用全连接找出king的信息)
SELECT
	e.mgr,
	e.ename,
	e.deptno,
	e2.ename boss,
	d.dname,
	s.grade 
FROM
	emp e
	LEFT JOIN emp e2 ON e.mgr = e2.empno
	JOIN dept d ON d.deptno = e.deptno
	JOIN salgrade s ON e.sal BETWEEN s.losal 
	AND s.hisal 
WHERE
	e.sal > ( SELECT avg( sal ) FROM emp );
23.列出与scott从事相同工作的所有员工及其部门名称
SELECT
	job 
FROM
	emp 
WHERE
	ename = 'scott';
SELECT
	e.ename,
	d.dname,
	e.job 
FROM
	emp e
	JOIN dept d ON e.deptno = d.deptno 
WHERE
	job = ( SELECT job FROM emp WHERE ename = 'scott' );
24.列出薪资等于部门30中员工的薪资的其他员工的姓名和薪金
	SELECT DISTINCT
	sal 
FROM
	emp 
WHERE
	deptno = 30;
	
	SELECT
	ename,
	sal 
FROM
	emp 
WHERE
	( sal IN ( SELECT DISTINCT sal FROM emp WHERE deptno = 30 ) ) 	AND deptno <> 30;
	
25.列出薪资高于部门30中员工的薪资的其他员工的姓名和薪金
	

SELECT
	ename,
	sal 
FROM
	emp 
WHERE
	sal > ( SELECT max( t.sal ) FROM ( SELECT DISTINCT sal FROM emp WHERE deptno = 30 ) t );
26.列出在每个部门工作的员工数量,平均工资和平均服务期限(工龄)
(所有,每个这些关键字很有可能要全连接)
SELECT
	e.deptno,
	count( e.ename ) totalmember,
	IFNULL(avg( sal ) ,0) avgsal,
	IFNULL(avg(	( ( TO_DAYS( now( ) ) - TO_DAYS( hiredate ) ) / 356 )),0) year
FROM
	emp e
	RIGHT JOIN dept d ON e.deptno = d.deptno 
GROUP BY
	deptno;
27.列出所有员工的姓名,部门名称,工资
select e.ename,d.dname,e.sal from emp e join dept d on e.deptno=d.deptno;
28.列出所有部门的详细信息和人数
select d.deptno,d.dnae,d.loc,count(e.ename) from emp e right join dept d on e.deptno=d.deptno group by d.deptno,d.dname,d.loc;
29.列出各个工作岗位最低工资和符合最低工资的人姓名
(判空与去重)
select job,min(sal) minsal from emp group by job;

SELECT
	t.job,
	e.ename,
	t.minsal 
FROM
	emp e
	JOIN ( SELECT job, min( sal ) minsal FROM emp GROUP BY job ) t ON e.job = t.job 
	AND e.sal = t.minsal 
ORDER BY
	t.minsal ASC;
30.获取各个部门mgr的最低薪资
SELECT
	deptno,
	min( sal ) minsal 
FROM
	emp 
	where
	job='manager'
GROUP BY
	deptno;
31.取出所有员工年薪,由低到高排序
SELECT
	ename,
	sal * 12+ ifnull( comm, 0 ) yearsal 
FROM
	emp 
ORDER BY
	yearsal ASC;
32.取出员工领导薪水超过3000的员工名称和领导名称
SELECT
	e.ename,
	e2.ename leader
FROM
	emp e
	JOIN emp e2 ON e.mgr = e2.empno 
	AND e2.sal > 3000;
33.取出含有s的部门,给出此部门的工资合计,部门人数
SELECT
	d.dname empname,
	count( e.ename ) totalpersons,
	SUM( ifnull( e.sal, 0 ) ) sumsal 
FROM
	emp e
	RIGHT JOIN dept d ON e.deptno = d.deptno 
WHERE
	d.dname LIKE '%s%' 
GROUP BY
	d.dname;
34.给任职超过30年的人加薪10%;
工作时间计算公式(年)
(( TO_DAYS( now( ) ) - TO_DAYS( hiredate ) ) / 365 ) year

create table emp_bak as select * from emp;


总结
作业到此完成,所有的问题都可分成小问题来拼出来,这个过程中除了注意sql的语法,mysql的特殊语法,还要考虑判空,去重,是否要全连接等.
查询数据的思路
1.我需要哪些字段?这些字段分别在那些表里?这些表靠什么连接?
2.涉及多表字段(自连接也算) 要先分开查询,查询时要注意判空与去重,以及选用合适的过滤方法和分组函数.
3.连接时选用内还是外连接,是要用增加查询字段,进行子查询,还是表连接要先后判断一下.