## postgresql 安装

```
1. brew install postgresql  #安装
2. initdb /usr/local/var/postgres  #初始化
3. pg_ctl -D /usr/local/var/postgres -l  /usr/local/var/postgres/server.log startpg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
```



## 创建数据库和账户


```
1. createdb
2. psql  #登录
3. CREATE USER user_name WITH PASSWORD 'password';  #创建用户
4. DROP DATABASE postgres;   #删除默认的数据库
5. ALTER ROLE postgres CREATEDB;

```

### 如果是rails


```
rails new app_name -d postgresql
rake db:create
```

### 否则的话手动创建数据库


```
1. CREATE DATABASE postgres OWNER user_name;   #创建数据库
2. GRANT ALL PRIVILEGES ON DATABASE postgres to user_name;  #给数据库添加用户
```

