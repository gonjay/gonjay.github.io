---
layout: post
title: "PostGIS 查询附近的人"
date: 2015-05-15 16:03:50 +0800
comments: true
categories: 
---
# 关于 PostGIS

![](http://postgis.net/images/postgis-logo.png)

PostGIS 是 PostGreSQL 关系型数据库中一个特别的数据库组件。增加了对地理位置对象的支持，并允许用 SQL 对位置信息的查询。

笔者因为要开发一个约炮软件，遇到了这个需求，发现 MySQL 中巨坑爹的用矩形来把不同地理位置信息进行划分，不能忍就换了 PostGIS，蛮好的满足了我的约炮软件需求。

<!--more-->

## 可能遇到的问题

在 `CREATE EXTENSION postgis;` 的时候遇到了

	ERROR:  could not open extension control file "/usr/share/postgresql/9.1/extension/postgis.control": No such file or directory

谷歌找到了解决办法 [stackoverflow](http://stackoverflow.com/questions/18696078/postgresql-error-when-trying-to-create-an-extension)

运行：

	apt-get install postgresql-9.1-postgis-scripts

## 创建合适的数据结构

然后重新连上postgres，并连上database，运行：

```sql
	CREATE EXTENSION postgis;
	CREATE EXTENSION postgis_topology;
	CREATE EXTENSION postgis_tiger_geocoder;
```

此时 SELECT POSTGIS_VERSION(); 应该可以显示当前的GIS版本，我们来创建一个users表，再往里面塞一些数据：

```sql
CREATE TABLE users ( id int4, name varchar(50), the_geom geometry(Point, 4326) );

INSERT INTO users (id, the_geom, name) VALUES (1,ST_GeomFromText('POINT(114.316559 30.48828)',4326),'小吴');
INSERT INTO users (id, the_geom, name) VALUES (1,ST_GeomFromText('POINT(114.314008 30.486568)',4326),'小是');
INSERT INTO users (id, the_geom, name) VALUES (1,ST_GeomFromText('POINT(114.313685 30.479379)',4326),'小傻');
INSERT INTO users (id, the_geom, name) VALUES (1,ST_GeomFromText('POINT(114.317853 30.479799)',4326),'小笔');
```

其中Point GPS 数据来源于 http://api.map.baidu.com/lbsapi/getpoint/

## 查找附近的人

把小吴Point(114.316559, 30.48828)附近的人按照距离排序

```sql
select id, ST_AsText(the_geom) from users order by the_geom <-> 'SRID=4326;POINT(114.316559 30.48828)'::geometry limit 10;
```

把小是Point(114.314008, 30.486568)附近的人按照距离排序

```sql
select id, ST_AsText(the_geom) from users order by the_geom <-> 'SRID=4326;POINT(114.314008 30.486568)'::geometry limit 10;
```

查找1000m以内的人

```sql
select id, ST_AsText(the_geom) from users where ST_DWithin(the_geom::geography, ST_GeographyFromText('POINT(114.316559 30.48828)'), 10.0);
```

并计算出距离

```sql
select id, ST_AsText(u.the_geom), ST_Distance(ST_GeomFromText('POINT(114.316559 30.48828)',4326), u.the_geom) from users as u
where ST_DWithin(the_geom::geography, ST_GeographyFromText('POINT(114.316559 30.48828)'), 10000.0)
order by the_geom <-> 'SRID=4326;POINT(114.316559 30.48828)'::geometry;
```

输出:

```
id	st_astext
st_distance(百公里)
1	POINT(114.316559 30.48828)
0
1	POINT(114.314008 30.486568)
0.00307222150893915
1	POINT(114.317853 30.479799)
0.00857914896711785
1	POINT(114.313685 30.479379)
0.00935348475168029
```

另外一种按照距离排序的sql写法

```sql
-- Closest street to Broad Street station is Wall St
SELECT streets.gid, streets.name
FROM
  nyc_streets streets,
  nyc_subway_stations subways
WHERE subways.name = 'Broad St'
ORDER BY ST_Distance(streets.geom, subways.geom) ASC
LIMIT 1;
```