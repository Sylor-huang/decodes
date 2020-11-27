### 1. 启动/链接redis
```
#启动
redis-server

# 链接
redis-cli
```

### 1.1 Redis持久化机制：RDB和AOF
> Redis提供了两种持久化方案：RDB持久化和AOF持久化，一个是快照的方式，一个是类似日志追加的方式

#### 1.1.1 RDB快照持久化
> RDB持久化是通过快照的方式，即在指定的时间间隔内将内存中的数据集快照写入磁盘。在创建快照之后，用户可以备份该快照，可以将快照复制到其他服务器以创建相同数据的服务器副本，或者在重启服务器后恢复数据。RDB是Redis默认的持久化方式, save和bgsave命令会触发

#### 1.1.2 AOF持久化
> AOF持久化会把被执行的写命令写到AOF文件的末尾，记录数据的变化。默认情况下，Redis是没有开启AOF持久化的，开启后，每执行一条更改Redis数据的命令，都会把该命令追加到AOF文件中，这是会降低Redis的性能，但大部分情况下这个影响是能够接受的，另外使用较快的硬盘可以提高AOF的性能。AOF需要记录Redis的每个写命令，步骤为：命令追加（append）、文件写入（write）和文件同步（sync


### 2. redis的五种数据类型

```
：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。
```

### 3. 键的操作方式


序号|命令| 代码
--- | ---|---
1|删除 | DEL KEY_NAME
2|序列化给定 key ，并返回被序列化的值  | DUMP KEY_NAM
3|检查给定 key 是否存在,若 key 存在返回 1 ，否则返回 0 | EXISTS KEY_NAME
4|设置 key 的过期时间，key 过期后将不再可用。设置成功返回 1, 否则为0，单位以秒计| Expire KEY_NAME TIME_IN_SECONDS
5|以 UNIX 时间戳(unix timestamp)格式设置 key 的过期时间。key 过期后将不再可用， 成功为1，否则为0 | Expireat KEY_NAME TIME_IN_UNIX_TIMESTAMP （示例: EXPIREAT runoobkey 1293840000)
6|PEXPIRE 命令和 EXPIRE 命令的作用类似，但是它以毫秒为单位设置 key 的生存时间，而不像 EXPIRE 命令那样，以秒为单位|PEXPIRE key milliseconds
7|TTL查看剩余时间, 以秒为单位，返回给定 key 的剩余生存时间,当 key 不存在时，返回 -2 。当 key存在但没有设置剩余生存时间时，返回 -1 。否则，以秒为单位，返回 key 的剩余生存时间。(PTTL返回的是毫秒)| ttl key_name 或者 pttl key_name
8|PEXPIREAT 命令用于设置 key 的过期时间，以毫秒计。key 过期后将不再可用,设置成功返回 1，否则为0；查看剩余时间为pttl|PEXPIREAT runoobkey 1555555555005
9|查找所有符合给定模式 pattern 的 key，符合给定模式的 key 列表 (Array)。| 如果 keys的名称为： "runoob1", "runoob2", "runoob3"..., 用  **KEYS runoob*** 可查相关的key，获取 redis 中所有的 key 可用使用 KEYS *
10|将当前数据库的 key 移动到给定的数据库 db 当中|move key_name other_redis_database
11|移除给定 key 的过期时间，使得 key 永不过期, 成功为1， 否则为0| persist key_name
12|从当前数据库中随机返回一个 key，当数据库不为空时，返回一个 key 。 当数据库为空时，返回 nil （windows 系统返回 null） |randomkey
13|删除当前数据库的所有key|FLUSHDB
14|修改 key 的名称, 改名成功时提示 OK ，失败时候返回一个错误|RENAME old_key_name new_key_nam
15|在新的 key 不存在时修改 key 的名称,修改成功时，返回 1 。 如果 NEW_KEY_NAME 已经存在，返回 0 | renamenx old_key_name new_key_name
16|Scan 命令用于迭代数据库中的数据库键,SCAN 命令是一个基于游标的迭代器，每次被调用之后， 都会向用户返回一个新的游标， 用户在下次迭代时需要使用这个新游标作为 SCAN 命令的游标参数， 以此来延续之前的迭代过程。SCAN 返回一个包含两个元素的数组， 第一个元素是用于进行下一次迭代的新游标， 而第二个元素则是一个数组， 这个数组中包含了所有被迭代的元素。如果新游标返回 0 表示迭代已结束。|SCAN cursor [MATCH pattern] [COUNT count]，cursor - 游标；pattern - 匹配的模式。count - 指定从数据集里返回多少元素，默认值为 10 。
17|返回 key 所储存的值的类型,返回 key 的数据类型，数据类型有：1,none (key不存在)；2，string (字符串)；3，list (列表)；4，set (集合)；5，zset (有序集)；6，hash (哈希表)| type key_name


### 4. 六种数据的基本操作方式

```
## 1. string 

set : 设置键，"SET runoobkey redis"
get : 获取键, "GET runoobkey"

# 2. hash 是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象

# 3. lists 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）

lpush key value1 [value2]  将一个或多个值插入到列表头部
lpushx key value 将一个值插入到已存在的列表头部

# 4.  Set 是 String 类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据.

sadd key member1 [member2]  向集合添加一个或多个成员

# 5. zset(sorted set)有序集合和集合一样也是string类型元素的集合,且不允许重复的成员。

不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。

有序集合的成员是唯一的,但分数(score)却可以重复

# 6. HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小。
在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。
```

### 5. redis事务
> Redis 事务可以一次执行多个命令， 并且带有以下三个重要的保证：

- 批量操作在发送 EXEC 命令前被放入队列缓存。
- 收到 EXEC 命令后进入事务执行，事务中任意命令执行失败，其余的命令依然被执行。
- 在事务执行过程，其他客户端提交的命令请求不会插入到事务执行命令序列中。

> 一个事务从开始到执行会经历以下三个阶段:

1. 开始事务。
1. 命令入队。
1. 执行事务

> 单个 Redis 命令的执行是原子性的，但 Redis 没有在事务上增加任何维持原子性的机制，所以 Redis 事务的执行并不是原子性的。事务可以理解为一个打包的批量执行脚本，但批量指令并非原子化的操作，中间某条指令的失败不会导致前面已做指令的回滚，也不会造成后续的指令不做。

### 6. Redis 连接命令


```
# 进入redis后(redis-cli)： 

AUTH password   #验证密码是否正确

ECHO message   #打印字符串

PING     #返回pong, 则是已允许

QUIT   #关闭当前连接

SELECT index   #切换到指定的数据库,默认数据库为0-16,数据库只能是数字，理论上是可以无穷大，只要内存足够

info   #获取 redis 服务器的统计信息

```


### 7. Redis 数据备份与恢复


```

## 备份

SAVE   #创建当前数据库的备份,该命令将在 redis 安装目录中创建dump.rdb文件

Bgsave #该命令在后台执行

## 恢复 

如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可


## 获取 redis 目录

CONFIG GET dir

```


### 8. 设置密码


```
> CONFIG get requirepass   

1) "requirepass"
2) ""   #表示未设置密码


> CONFIG set requirepass "runoob"
> OK   #表示设置了密码为 "runoob"

#设置密码后，客户端连接 redis 服务就需要密码验证，否则无法执行命令


> AUTH "runoob"   #表示验证密码，并登录进入，若正确则可以使用redis命令，否则报错
```

### 9. Redis 管道技术

> Redis是一种基于客户端-服务端模型以及请求/响应协议的TCP服务。这意味着通常情况下一个请求会遵循以下步骤：

1. 客户端向服务端发送一个查询请求，并监听Socket返回，通常是以阻塞模式，等待服务端响应。
1. 服务端处理命令，并将结果返回给客户端。

> Redis 管道技术可以在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。


