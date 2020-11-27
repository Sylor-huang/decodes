
```
# 进入postgres
1. psql -U postgres 

# 创建用户
2. CREATE USER 用户名 WITH PASSWORD '*****';



#授予用户数据库权限
3. GRANT ALL PRIVILEGES ON DATABASE 数据库名 TO 用户名;

# 授予用户查看刚授权的数据库的里面的表的权限

GRANT ALL PRIVILEGES ON TABLE 表名  TO 用户名;

# 1.1创建数据库
create database 数据库名; 

# 1.2 创建属于dbuser 的数据库(与上面取一个)
CREATE DATABASE exampledb OWNER dbuser;


# 4. 如果是linux，创建Linux普通用户，与刚才新建的数据库用户同名，如 dbuser：

sudo adduser dbuser
sudo passwd dbuser

# 4.1 以dbuser的身份连接数据库exampledb：
su - dbuser
psql -d exampledb
```


```
# 进入psql
psql -d postgres

# ubuntu 第一次进入
sudo -u postgres psql

#添加超级用户
ALTER ROLE postgres superuser;

#导出命令

pg_dump -U postgres(用户名)  (-t 表名)  数据库名(缺省时同用户名)  > c:\fulldb.sql

```



```
# ubuntu 启动 postgresql 

sudo service postgresql start

# mac 启动 postgresql

pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# mac 关闭 postgresql 
pg_ctl -D /usr/local/var/postgres stop -s -m fast

# mac 设置开启启动postgreaql 
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```
