### 1. bulk参数

`:bulk => true`可以让`Rails`的`Migration`更有效率的执行，如果沒有加這個参数，或是直接使用`add_column`、`rename_column`、`remove_column`等方法，那麼`Rails`會拆開SQL來執行，例如：

```
change_table(:users) do |t|
  t.string :company_name
  t.change :birthdate, :datetime
end
```
会产生：

```
ALTER TABLE `users` ADD `im_handle` varchar(255)
ALTER TABLE `users` ADD `company_id` int(11)
ALTER TABLE `users` CHANGE `updated_at` `updated_at` datetime DEFAULT NULL
```
加上`:bulk => true`之后：

```
change_table(:users, :bulk => true) do |t|
  t.string :company_name
  t.change :birthdate, :datetime
end
```

这只会产生一条SQL语句：


```
ALTER TABLE `users` ADD COLUMN `im_handle` varchar(255), ADD COLUMN `company_id` int(11), CHANGE `updated_at` `updated_at` datetime DEFAULT NULL
```
这对已有不少资料量的资料库来说，会有不少执行速度上的差异，可以减少资料库因为修改被lock锁定的时间。


### 2.网站效能

#### （1）N+1 搜索
多使用includes()，可以有效避免 N+1

#### （2）索引(Indexes)
以下的字段都需加上索引，以提高网站搜索效率
```
外部键(Foreign key)
会被排序的字段(被放在order方法中)
会被查询的字段(被放在where方法中)
会被group的字段(被放在group方法中)
```


#### （3） 使用select
ActiveRecord默认的SQL会把所有字段的资料都读取出来，如果其中有text或binary字段资料量很大，就会每次都佔用很多不必要的内存拖慢效能。使用select可以只读取出你需要的资料：


```
Event.select(:id, :name, :description).limit(10)
```
进一步我们可以利用scope先设定好select范围：

```
class User < ApplicationRecord
  scope :short, -> { select(:id, :name, :description) }
end

User.short.limit(10)
```

#### （4）计数快取 Counter Cache
Counter cache功能可以把这个数字存进数据库，不再需要一笔笔的SQL count查询，并且会在Post数量有更新的时候，自动更新这个值。
编辑Models，加入:counter_cache => true：

```
class Topic < ApplicationRecord
  has_many :posts
end

class Posts < ApplicationRecord
  belongs_to :topic, :counter_cache => true
end
```

#### （5）Transaction for group operations
在Transaction交易范围内的SQL效能会加快，因为最后只需要COMMIT一次即可：


```
my_collection.each do |q|
  Quote.create({:phrase => q})
end

# Add transaction
Quote.transaction do
  my_collection.each do |q|
    Quote.create({:phrase => q})
 end
end
```


#### (6) 合理使用缓存 

1. Markdown 缓存: 在before_save 之前，先存储markdown的html。
1. Fragment Cache: 框架缓存
1. 数据缓存: Rails.cache
1. ETag: 没有使用过，但是可以学习
1. 静态资源缓存 (JS,CSS,图片)：合理利用 Rails Assets Pipeline，一定要开启！；在 Nginx 里面将 CSS, JS, Image 的缓存有效期设成 max；尽可能的减少一个页面 JS, CSS, Image 的数量，简单的方法是合并它们，减少 HTTP 请求开销；



### 3.效能分析工具

效能分析工具可以帮助我们找到哪一部分的程式最需要效能优化，哪些部分最常被使用者执行，如果能够优化效益最高。

1. rack-mini-profiler在页面的左上角显示花了多少时间，并且提供报表，推荐安装
1. request-log-analyzer这套工具可以分析Rails log档案
1. 透过商业Monitor产品：Skylight、New Relic或Scout
2. 

### 4. 程式量测工具

以下工具可以帮助我们量测程式的效能：

1. Benchmark standard library
1. Rails benchmark helper Rails 内建的一些 Helper
1. Rails Performance Testing 介绍的 rails/rails-perftest 工具
1. ruby-prof
1. evanphx/benchmark-ips
1. SamSaffron/memory_profiler
2. 

### 5. HTTP 量测工具

以下工具可以量测网站服务器的连线和Requests数量：

1. httperf: 可以参考使用 httperf 做网站效能分析一文
1. wrk: Modern HTTP benchmarking tool
1. Apache ab: Apache HTTP server benchmarking tool


### 6. 阵列型Collection

如果是阵列的资料，像是`tr`或`li`这类会一直重复的Template元素，我们可以使用`collection`参数来处理，例如像以下的程式：

```
<ul>
    <% @people.each do |person| %>
        <%= render :partial => "person", :locals => { :person => person } %>
    <% end %>
<ul>
```

我们可以改写成使用collection参数来支援阵列形式：


```
<ul>
    <%= render :partial => "person", :collection => @people, :as => :person %>
<ul>
```

在`_person.html.erb`这个`partial`中，会有一个额外的索引变量`person_counter`纪录编号。

使用`collection`的好处不只是少打字而已，还有执行效能上的大大改善，Rails内部会针对这种形式做执行效率最佳化。



## ubuntu 安卓手机使用wireshark分析

1. ubuntu打开wifi热点，手机链接热点。
1. 打开终端，以管理员权限登录，然后使用命令tcpdump -s 0 -i any -w client.cap进行抓包,停止抓包直接ctrl+c即可


```
//参考链接：
https://www.jianshu.com/p/cf65f485223b
```

### 7.MySQL命令行导入导出sql文件
#### 一、导出数据库用mysqldump命令（注意mysql的安装路径，即此命令的路径）：
 1. 导出数据和表结构（常用）：
mysqldump -u用户名 -p密码 数据库名 > 数据库名.sql
#/usr/local/mysql/bin/   mysqldump -uroot -p abc > abc.sql
敲回车后会提示输入密码

2. 只导出表结构
mysqldump -u用户名 -p密码 -d 数据库名 > 数据库名.sql
#/usr/local/mysql/bin/   mysqldump -uroot -p -d abc > abc.sql

注：/usr/local/mysql/bin/  --->  mysql的data目录


#### 二、导入数据库
1. 首先建空数据库
mysql>create database abc;

2. 导入数据库
方法一：
（1）选择数据库
mysql>use abc;
（2）设置数据库编码
mysql>set names utf8;
（3）导入数据（注意sql文件的路径）
mysql>source /home/abc/abc.sql;
方法二：
mysql -u用户名 -p密码 数据库名 < 数据库名.sql
#mysql -uabc_f -p abc < abc.sql

### 8.查看mysql安装路径


```
指令 ps -ef|grep mysql
```

得出结果
root     17659     1  0  2011 ?        00:00:00 /bin/sh /usr/bin/mysqld_safe --datadir=/var/lib/mysql --socket=/var/lib/mysql/mysql.sock --log-error=/var/log/mysqld.log --pid-file=/var/run/mysqld/mysqld.pid   
mysql    17719 17659  0  2011 ?        03:14:57 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --user=mysql --pid-file=/var/run/mysqld/mysqld.pid --skip-external-
locking --socket=/var/lib/mysql/mysql.sock  

usr/bin/mysql 是指：mysql的运行路径 
var/lib/mysql 是指：mysql数据库文件的存放路径 
usr/lib/mysql 是指：mysql的安装路径


```
//terminal中用~/.bashrc,zsh中用~/.zshrc

export PATH=$PATH:/usr/local/mysql/bin

//
```

### 9.Benchmarks 查看程序运行的时间.

```
<% benchmark "Process data files" do %>
  <%= expensive_files_operation %>
<% end %>
```
这样将会在你的log记录中增加一笔像是“Process data files (345.2ms)”的纪录，你便可用来测量并改善你的程式码。

你也可以设定log的层级，默认是info：

```
<% benchmark "Low-level files", :level => :debug do %>
  <%= lowlevel_files_operation %>
<% end %>
```

### nginx服务器报错查看日志信息


```
tailf /tmp/passenger.log
```

### 10. whenever 命令

```
#设置
whenever --update-crontab --set environment=development
```

### 11. rails 运行与迁移的知识点


```
rake db:rollback  
#上面的命令通过撤销 change 方法或调用 down方法来回滚最后一个迁移。要想取消多个迁移，可以使用 STEP参数

rake db:rollback STEP=3  
#撤销最后三个迁移

db:migrate:redo
#任务用于回滚最后一个迁移并再次运行这个迁移

rake db:migrate:redo STEP=3
#如果需要重做 多个迁移，可以使用 STEP 参数

rake db:setup
#用于创建数据库，加载数据库模式，并使用种子数据初始化数据库

rake db:reset
#删除并重新创建数据库，其功能相当于rails db:drop db:setup。

rake db:migrate:up VERSION=20080906120000
#运行指定方法，VERSION为迁移文件的版本

rake db:migrate RAILS_ENV=test
#默认在开发环境中运行迁移。要想在其他环境中运行迁移，可以在执行任务时使用 RAILS_ENV 环境变量说明所需环境

rake db:schema:load
#使用该命令取代 rake db:migrate 来初始化空的数据库。
```

### 12. 数据验证

```
save 和 update 返回 false，create 返回对象本身
```

跳过验证的方法:

- decrement!
- decrement_counter
- increment!
- increment_counter 
- toggle!
- touch
- update_all
- update_attribute 
- update_column
- update_columns
- update_counters
- save(validate: false)
- 


### 13. 批量检索多个对象each,find_each,find_in_batches


```
# 如果 users 表有几千行记录，这样做效率很低 

User.all.each do |user|
    NewsMailer.weekly(user).deliver_now
end

#但随着数据表越来越大，这种方法越来越行不通，因为 User.all.each 会使 Active Record 一次性取回整个数据表，为每条记录创建模型对象，并把整个模型对象数组保存在内存中。
```


```
#find_each 方法检索一批记录，然后逐一把每条记录作为模型传入块
User.find_each do |user|
      NewsMailer.weekly(user).deliver_now
end

User.find_each(start: 2000, finish: 10000, batch_size: 5000) do |user|
      NewsMailer.weekly(user).deliver_now
end
```

find_in_batches 方法和 find_each方法类似，两者都是批量检索记录。区别在于，find_in_batches 方法会 把一批记录作为模型数组传入块，而不是像 find_each方法那样逐一把每条记录作为模型传入块。

和 find_each 方法一样，find_in_batches 方法可以使用 :batch_size、:start 和 :finish 选项。

### 15. exists?方法使用

```
#后面可以带多个参数或者不带参数

1. User.exists?(id:1,login:"innov")

2. Client.where(first_name: 'Ryan').exists?
```


### 16. 字段的计算方法


```
Client.size / Client.count 模型的数量

Client.average("orders_count")  #字段的平均值
Client.minimum("age")  #字段最小值
Client.maximum("age")  #字段的最大值
Client.sum("orders_count")  #字段的统计之和
```


### 17. rake 任务 whenever

```
bundle exec rails runner -e production "ExercisePublishTask.new.publish"
bundle exec rails runner -e production "ExercisePublishTask.new.end"
```

### 18. distinct的用法

```
#使用 distinct 方法可以确保集合中没有重复的对象。与 :through 选项一起使用最有用。
 class Person
    has_many :readings
    has_many :articles, -> { distinct }, through: :readings
end

#如果要确保只把不重复的记录写入关联模型的数据表(这样就不会从数据库中获取重复记录了)，需要在数 据表上添加唯一性索引。例如，数据表名为 readings，我们要保证其中所有的文章都没重复，可以在迁移中 加入以下代码
add_index :readings, [:person_id, :article_id], unique: true
```

#### 18.1 用法简介

```
# 用法简介1
User.select(:first_name, :age).distinct

#结果
=> #<ActiveRecord::Relation 
[#<User id: nil, first_name: "Hiroyuki", age: 31>,
 #<User id: nil, first_name: "Taro", age: 31>,
 #<User id: nil, first_name: "Ichiro", age: 31>,
 
# 用法简介2
User.distinct(:first_name)

#结果
=> #<ActiveRecord::Relation [
#<User id: 1, last_name: "Toda", first_name: "Hiroyuki", birthday: "1988-08-17", age: 31, created_at: "2019-09-13 01:49:32", updated_at: "2019-09-13 01:49:32">,
#<User id: 2, last_name: "Suzuki", first_name: "Hiroyuki", birthday: "1988-08-17", age: 31, created_at: "2019-09-13 01:49:44", updated_at: "2019-09-13 01:49:44">]>
```

#### 18.2 用法简介2

```
Location.joins(:users).where(users: {enabled: true}).distinct.order('locations.name')

#这个使用方法错误，会报错：

ActiveRecord::StatementInvalid: Mysql2::Error: Unknown column 'locations.name'


# 解决办法，先选择完，然后再进行排序：

class Location < ActiveRecord::Base
  has_many :users

  def self.enabled
    joins(:user).where(users: {enabled: true}).distinct
  end

  def self.by_name
    order(:name)
  end
end

Location.from(Location.enabled, :locations).by_name

```




### 19. group的查询用法

（1）表的结构和内容

```
==# Actress.rb表==

class Actress < ApplicationRecord
  has_many :movies
  has_many :tags, through: :movies
end

#Actress内容

SELECT id, name FROM actresses;
 id |    name
----+------------
  1 | 多部未華子
  2 | 佐津川愛美
  3 | 新垣結衣
  4 | 堀北真希
  5 | 吉高由里子
  6 | 悠城早矢
  
  
==# 2.Movie.rb表==

class Movie < ApplicationRecord
  has_many :tags
  belongs_to :actress
end

#movie表内容

SELECT id, actress_id, title, year FROM movies;
 id | actress_id |        title        | year
----+------------+---------------------+------
  1 |          2 | 蝉しぐれ            | 2005
  2 |          1 | 夜のピクニック      | 2006
  3 |          4 | ALWAYS 三丁目の夕日 | 2005
  4 |          2 | 忍道-SHINOBIDO-     | 2012
  5 |          2 | 貞子vs伽椰子        | 2016
  6 |          4 | 県庁おもてなし課    | 2013
  7 |          5 | 真夏の方程式        | 2013
  
==# Tag.rb表结构==

class Tag < ApplicationRecord
  belongs_to :movie
end

#tag表内容
SELECT id, movie_id, key FROM tags;
 id | movie_id |    key
----+----------+------------
  1 |        1 | 時代劇
  2 |        1 | 子役
  3 |        3 | 昭和
  4 |        5 | ホラー
  5 |        7 | ミステリー
  6 |        7 | 夏
  7 |        6 | 公務員
  8 |        6 | 地方活性
  9 |        1 | 夏
 10 |        4 | 時代劇
  
```

(2)统计movie表的演员数,并返回hash数组

```
# movie 表有actress_id字段，那么将会自动将actress_id分组并计数，以hash形式返回：

Movie.group(:actress_id).count
=> {4=>2, 1=>1, 5=>1, 2=>3}

#代码相当于：

SELECT
  COUNT(*) AS count_all,
  "movies"."actress_id" AS movies_actress_id
FROM
  "movies"
GROUP BY
  "movies"."actress_id"
```

(3)联合两个表时，统计 电影存在的演员的名称,并返回hash数组

```
Movie.joins(:actress).group("actresses.name").count

=> {"多部未華子"=>1, "佐津川愛美"=>3, "堀北真希"=>2, "吉高由里子"=>1}


#相当于：
SELECT
  COUNT(*) AS count_all,
  actresses.name AS actresses_name
FROM
  "movies"
  INNER JOIN
    "actresses"
  ON
    "actresses"."id" = "movies"."actress_id"
GROUP BY
  actresses.name
```

（4）统计每个演员的电影数,并返回hash数组

```
#使用预加载
Movie.group(:actress_id).select("actress_id, count(movies.id) as movie_count").preload(:actress).map { |m| [m.actress.name, m.movie_count] }.to_h
=> {"吉高由里子"=>1, "堀北真希"=>2, "佐津川愛美"=>3, "多部未華子"=>1}

#使用includes，防止n+1
Movie.group(:actress_id).select("actress_id, count(movies.id) as movie_count").includes(:actress).map { |m| [m.actress.name, m.movie_count] }.to_h

{"吉高由里子"=>1, "堀北真希"=>2, "佐津川愛美"=>3, "多部未華子"=>1}
```

(5)联合电影和演员表，按演员的电影数降序排列,并返回hash数组

```
#1.第一种方式
Movie.joins(:actress).group("actresses.name").order("count_all DESC").count
=> {"佐津川愛美"=>3, "堀北真希"=>2, "多部未華子"=>1, "吉高由里子"=>1}

#2. 第二种方式
Movie.group(:actress_id).select("actress_id, count(movies.id) as movie_count").order("movie_count desc").preload(:actress).map { |m| [m.actress.name, m.movie_count] }.to_h

{"佐津川愛美"=>3, "堀北真希"=>2, "吉高由里子"=>1, "多部未華子"=>1}

```

（6）演员根据主演电影的数量排序

```
Actress.joins(:movies).group('actresses.id').order(Arel.sql('count(actresses.id) desc'))


#=> [#<Actress:0x007f89619a7878
  id: 2,
  name: "佐津川愛美",
  created_at: Fri, 23 Mar 2018 01:03:30 JST +09:00,
  updated_at: Fri, 23 Mar 2018 01:03:30 JST +09:00>,
 #<Actress:0x007f89619a7738
  id: 4,
  name: "堀北真希",
  created_at: Fri, 23 Mar 2018 01:03:30 JST +09:00,
  updated_at: Fri, 23 Mar 2018 01:03:30 JST +09:00>,
 #<Actress:0x007f89619a75a8
  id: 5,
  name: "吉高由里子",
  created_at: Fri, 23 Mar 2018 01:03:30 JST +09:00,
  updated_at: Fri, 23 Mar 2018 01:03:30 JST +09:00>,
 #<Actress:0x007f89619a7468
  id: 1,
  name: "多部未華子",
  created_at: Fri, 23 Mar 2018 01:03:30 JST +09:00,
  updated_at: Fri, 23 Mar 2018 01:03:30 JST +09:00>]
```

（7）3张表联合，每个演员的电影标签数量

```
#1.当演员与tag表没有关联时
Actress.joins(movies: :tags).group("actresses.name").count

=> {"佐津川愛美"=>5, "堀北真希"=>3, "吉高由里子"=>2}

#2. 给演员添加相关的tag标签

#actress.rb 添加

has_many :tags, through: :movies

Actress.joins(:tags).group("actresses.name").count

=> {"佐津川愛美"=>5, "堀北真希"=>3, "吉高由里子"=>2}
```

(8)3张表联合，知道每个标签的演员数


```
Actress.joins(:tags).group("actresses.name").group("tags.key").count

=>{["堀北真希", "地方活性"]=>1,
 ["佐津川愛美", "子役"]=>1,
 ["佐津川愛美", "夏"]=>1,
 ["佐津川愛美", "ホラー"]=>1,
 ["吉高由里子", "ミステリー"]=>1,
 ["堀北真希", "昭和"]=>1,
 ["堀北真希", "公務員"]=>1,
 ["佐津川愛美", "時代劇"]=>2,
 ["吉高由里子", "夏"]=>1}
 
 
#上面的返回结果没有排序，下面的方法可以排序

## 1. 按演员名称排序
Actress.joins(:tags).group("actresses.name").group("tags.key").order("actresses.name").count

=> {["堀北真希", "昭和"]=>1,
 ["堀北真希", "公務員"]=>1,
 ["堀北真希", "地方活性"]=>1,
 ["佐津川愛美", "夏"]=>1,
 ["佐津川愛美", "子役"]=>1,
 ["佐津川愛美", "ホラー"]=>1,
 ["佐津川愛美", "時代劇"]=>2,
 ["吉高由里子", "夏"]=>1,
 ["吉高由里子", "ミステリー"]=>1}
 
## 2. 按演员名称及标签数排序

Actress.joins(:tags).group("actresses.name").group("tags.key").order("actresses.name, count_all DESC").count
=> {["堀北真希", "地方活性"]=>1,
 ["堀北真希", "昭和"]=>1,
 ["堀北真希", "公務員"]=>1,
 ["佐津川愛美", "時代劇"]=>2,
 ["佐津川愛美", "ホラー"]=>1,
 ["佐津川愛美", "夏"]=>1,
 ["佐津川愛美", "子役"]=>1,
 ["吉高由里子", "夏"]=>1,
 ["吉高由里子", "ミステリー"]=>1}

```

#### (9)另外的例子：使用having
> SQL语句用HAVING子句指明GROUP BY字段的约束条件。要想在Model.find生成的SQL语句中使用HAVING子句，可以使用 having 方法。例如:


```
Order.select("date(created_at) as ordered_date, sum(price) as total_price").
group("date(created_at)").having("sum(price) > ?", 100)
```

#### (10) unscope 方法


```
# 可以使用 unscope 方法删除某些条件。 例如:


Article.where('id > 10').limit(20).order('id asc').unscope(:order)
```

#### (11) reverse_order 方法


```
# 可以使用 reverse_order 方法反转排序条件。

Client.where("orders_count > 10").order(:name).reverse_order
```


```
#可以使用 unscope 方法删除某些条件。 例如:

Article.where('id > 10').limit(20).order('id asc').unscope(:order)

```



### 20. rails的事务和锁
> 来源:https://blog.csdn.net/feigeswjtu/article/details/51830874
#### 20.1 事务的基本介绍
> 事务是指并发控制的单位，是用户定义的一个操作序列。简单的来说事务里面的多个操作，要么都不执行，要么一起执行。事务可以帮助开发者保证应用中的数据一致性。常见的使用事务的场景是银行转账，钱从一个账户转移到另外一个账户。如果中间的某一步出错，那么整个过程应该重置（Rollback）

> Rails中，通过ActiveRecord对象的类方法或者实例方法即可实现事务


```
ActiveRecord::Base.transaction do
  david.withdrawal(100)
  mary.deposit(100)
end

Client.transaction do
  @client.users.create!
  @user.clients(true).first.destroy!
  Product.first.destroy!
end

@client.transaction do
  @client.users.create!
  @user.clients(true).first.destroy!
  Product.first.destroy!
end

#上述三个方法都是可以的
```

> 可以看到上面的例子中，**每个事务中均含有多个不同的 model** 。**==在同一个事务中调用多个 model 对象是常见的行为，因为事务是和一个数据库连接绑定在一起的，而不是某个 model 对==象**；而同时，==也只有在对多个纪录进行操作，并且希望这些操作作为一个整体的时候，事务才是必要的==。
另外，Rails 已经把类似 #save 和 #destroy 的方法包含在一个事务中了，因此，对于单条数据库记录来说，不需要再使用显式的调用了。

> Rails 中约定，**==带有叹号的函数一般会在失败时抛异常==**，所以我们自己写带有!号的方法也一定要在失败时raise一个异常，这样才符合rails的规范。
同时，我也看到一些代码中，在事务块中使用了 #find_by 方法，实际上，**==find_by 等魔术方法当找不到记录的时候会返回 nil，而 #find 方法在找不到记录的时候会抛出一个ActiveRecord::RecordNotFound 异常==**。

#### 20.2 何时使用嵌套事务？

> 错误使用或者过多使用嵌套异常是比较常见的错误。当你把一个 transaction 嵌套在另外一个事务之中时，就会存在父事务和子事务，这种写法有时候会导致奇怪的结果。比如下面来自于Rails API 文档的例子

```
User.transaction do
  User.create(:username => 'Kotori')
  User.transaction do
    User.create(:username => 'Nemu')
    raise ActiveRecord::Rollback
  end
end
```

> 上面提到，ActiveRecord::Rollback 不会传播到上层的方法中去，==因此这个例子中，父事务并不会收到子事务抛出的异常。因为子事务块中的内容也被合并到了父事务中去，因此这个例子中，两条 User 记录都会被创建！==
可以把嵌套事务这样理解，子事务中的内容被归并到了父事务中，这样子事务变空。
为了保证一个子事务的 rollback 被父事务知晓，必须手动在子事务中添加 :require_new => true 选项。比如下面的写法：

```
User.transaction do
  User.create(:username => 'Kotori')
  User.transaction(:requires_new => true) do
    User.create(:username => 'Nemu')
    raise ActiveRecord::Rollback
  end
end
```

> 事务是跟当前的数据库连接绑定的，因此，如果你的应用同时向多个数据库进行写操作，那么必须把代码包裹在一个嵌套事务中去。比如：


```
Client.transaction do
  Product.transaction do
    product.buy(@quantity)
    client.update_attributes!(:sales_count => @sales_count + 1)
  end
```

#### 20.3 事务相关的回调

> 上面提到 #save 和 #destroy 方法被自动包裹在一个事务中，因此相关的回调，比如 #after_save 仍然属于事务的一部分，因此回调代码也有可能被回滚。
因此，如果你希望代码在事务外部执行的话，那么可以使用 #after_commit 或者 # after_rollback 这样的回调函数。

#### 20.4 事务的陷阱

> 不要在事务内部去捕捉 ActiveRecord::RecordInvalid 异常。因为某些数据库下，这个异常会导致事务失效，比如 Postgres。一旦事务失效，要想让代码正确工作，就必须从头重新执行事务。
另外，测试回滚或者事务回滚相关的回调时，最好关掉 transactional_fixtures 选项，一般的测试框架中，这个选项是打开的。


#### 20.5 不正确的事务使用方法

 - 单条记录操作时使用事务
 - 不必要的使用嵌套式事务
 - 事务中的代码不会导致回滚
 - 在 controller 中使用事务（那在哪里用？）

#### 20.6 锁

> rails中的lock语句用的锁是我们常说的悲观锁，sql的语句一般是: select ... from ... where ...for update
一般情况下，事务要和锁一起用，本文提到的订单超卖的问题就是未使用锁导致的，代码如下：


```
sku = User.find_by_id(sku_id)
ActiveRecord::Base.transaction do
  if(sku.stock > 0)
    sku.update_attributes!(stock: sku.stock - 1)
    Order.create!(order_attrs)
  end            
end
```

> 在高并发的情况下，会出现这个问题，多个并发都同时执行到并满足第三行代码的条件，if条件下的语句都会执行，就会出现超卖的问题，那么怎么做不会超卖呢？就是加锁。


```

sku = User.find_by_id(sku_id)
ActiveRecord::Base.transaction do
  sku.lock!
  if(sku.stock > 0)
    sku.update_attributes!(stock: sku.stock - 1)
    Order.create!(order_attrs)
  end            
end

```
> 支付时使用with_lock，那么需要更新的自动需要加索引，如果不加索引的话，那么会锁全表，否则只是行锁\


```

product = Product.find(1)
product.with_lock do 
  product.stock -= 1
  product.save!
end
```

> "select * from where xxx for update" 时，在 repeat read的隔离级别下，MySQL 加锁机制取决于sku的索引

- 如果name没有索引，则锁全表。
- 如果name 有普通索引，则锁一个区间 - range lock。
- 如果 name 是唯一索引，仅仅锁一行。
- 如果name 是主键，仅仅锁一行。

>乐观锁本质上算是一个利用多版本管理来控制并发的技术，如果事务提交之后，数据库发现写入进程传入的版本号与目前数据库中的版本号不一致，说明有其他人已经修改过数据，不再允许本事务的提交。所以，使用乐观锁之前需要给数据库增加一列 :lock_version，Rails 会自动识别这一列，像数据库提交数据的时候自动带上。另外，乐观锁是默认打开的，如果要关闭，需要配置一下。如果事务提交失败，那么 Rails 会抛一个ActiveRecord::StaleObjectError 的异常。
### 21. where 查询

#### 21.1 where查询语法推荐
```
# 强烈推荐使用下面这种写法:
    Client.where("orders_count = ?", params[:orders]) 
    
    Author.joins(:articles).where(articles: { author: author })
# 而不是:
    Client.where("orders_count = #{params[:orders]}")

```

> 原因是出于参数的安全性考虑。把变量直接放入条件字符串会导致变量原封不动地传递给数据库，这意味着
即使是恶意用户提交的变量也不会被转义。这样一来，整个数据库就处于风险之中，因为一旦恶意用户发现
自己能够滥用数据库，他就可能做任何事情。所以，永远不要把参数直接放入条件字符串。

#### 21.2 时间选择的最佳方式


```
# 获取昨天的记录

Client.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
```

#### 21.3 NOT查询


```
Client.where.not(locked: true)
```

### 22. 关联扩展

> Rails 基于关联代理对象自动创建的功能是死的，可以通过匿名模块、新的查找方法、创建对象的方法等进行
扩展。例如:

```
class Author < ApplicationRecord
      has_many :books do
        def find_by_book_prefix(book_number)
          find_by(category_id: book_number[0..2])
        end 
      end
    end
```
> 如果扩展要在多个关联中使用，可以将其写入具名扩展模块。例如:


```
module FindRecentExtension
      def find_recent
        where("created_at > ?", 5.days.ago)
      end
    end
```


```
class Author < ApplicationRecord
     has_many :books, -> { extending FindRecentExtension }
end


class Supplier < ApplicationRecord
     has_many :deliveries, -> { extending FindRecentExtension }
end
```

### 23. Rails mysql中查询 有joins, select, includes的时候，会出现报错：

```
incompatible with sql_mode=only_full_group_by in mysql


#解决办法, 在config/database.yml中设置

development: # Or test, or production, or all of them.
  ...
  variables:
    sql_mode: TRADITIONAL

```


#### 24. 正则表达式


```
# 匹配中文
/\p{Han}+/

#匹配 0-9, A-Z, a-z的
/\p{Word}+/u
```

#### 25. 初始化数据库时

```
把 schema.rb 保存在版本管控之下。

使用 rake db:scheme:load 取代 rake db:migrate 来初始化空的数据库。
```

#### 26. presence

```
# object.presence 相当于
object.present? ? object : nil
```


#### 27. num.zero? 


```
num.zero?   #判断是否为0， num一般搭配 .to_i使用
```

#### 28. 在模型层以外使用查询方法

> 每当你想用where、order、joins、includes、group、having或者其他查询方法时，记得要把它们放在模型层(Model)里，避免在别的地方也想查找全部用户并进行排序，就会出现冗余代码。

#### 29. 条件判断时使用unless或者否定的表达式
> 尽量使用if而非unless，用肯定的表达式多过肯定的表达式。实在不行就添加个反意的方法，比如我们在User模型里加的那个。

#### 30. 在模型(Model)的实例方法里，本来不需要的时候使用了“self.”

> 在模型里，只有在实例方法里需要赋值时，才会用到“self.”，否则通篇的“self.”只会徒增代码复杂度

```
# app/models/user.rb, 不好的，滥用了self
class User < ActiveRecord::Base

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end


# app/models/user.rb, 好的，除非是实例方法赋值时，才需要self
class User < ActiveRecord::Base

  def full_name
    "#{first_name} #{last_name}"
  end

end
```

#### 31. 使用条件表达式并且返回了条件


```
# app/models/user.rb， 不好的

class User < ActiveRecord::Base

  def full_name
    if name
      name
    else
      "No name"
    end
  end
end

# app/models/user.rb， 或者这个
class User < ActiveRecord::Base

  def full_name
    name ? name : "No name"
  end
end

# app/models/user.rb， 好的方法
class User < ActiveRecord::Base

  def full_name
    name || "No name"
  end

end
```

> 简单来说这段代码会在name不为false或nil时将其返回，否则返回"No name".使用得当的话，||和&&这些操作符会对提升你的代码品质提供巨大助力。

#### 32. Sandi Metz 的规则

1. 每个类代码不可以超过100行
1. 每个方法代码不可以超过5行
1. 方法参数不可以超过4个，hash项也包括在内
1. 控制器之可以初始化一个对象。而且视图层只可以使用一个实例变量，并且只可以在这个对象上调用方法（@object.collaborator.value这种是不可以的）


33. arry转二进制为十进制

```
arr = [1,0,0,1,0] #arr为二进制的集合

arr.join("").to_i(2)   

# 或

Integer(arr.join, 2)
```

### 34. rails5 以后的判断attribute_name是否change

（1）after_create/after_update 之前的

修正前 | 修正後
---|---
attribute_changed? | will_save_change_to_attribute?
attribute_change | attribute_change_to_be_saved
attribute_was |	attribute_in_database
changes |	changes_to_save
changed? |	has_changes_to_save?
changed	| changed_attribute_names_to_save
changed_attributes | attributes_in_database

（2）after_create/after_update 之后的

修正前 | 修正後
---|---
attribute_changed? |	saved_change_to_attribute?
attribute_change |	saved_change_to_attribute
attribute_was |	attribute_before_last_save
changes |	saved_changes
changed? |	saved_changes?
changed |	saved_changes.keys
changed_attributes |	saved_changes.transform_values(&:first)








