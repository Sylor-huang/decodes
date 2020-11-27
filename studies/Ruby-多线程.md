- 每个正在系统上运行的程序都是一个进程。每个进程包含一到多个线程。
- 线程是程序中一个单一的顺序控制流程，在单个程序中同时运行多个线程完成不同的工作,称为多线程。
- Ruby 中我们可以通过 Thread 类来创建多线程，Ruby的线程是一个轻量级的，可以以高效的方式来实现并行的代码。

### 1. 创建 Ruby 线程

```
# 线程 #1 代码部分

Thread.new {
  # 线程 #2 执行代码
}
# 线程 #1 执行代码
```

### 2. 线程生命周期

1、线程的创建可以使用Thread.new,同样可以以同样的语法使用Thread.start 或者Thread.fork这三个方法来创建线程。

2、创建线程后无需启动，线程会自动执行。

3、Thread 类定义了一些方法来操控线程。线程执行Thread.new中的代码块。

4、线程代码块中最后一个语句是线程的值，可以通过线程的方法来调用，如果线程执行完毕，则返回线程值，否则不返回值直到线程执行完毕。

5、Thread.current 方法返回表示当前线程的对象。 Thread.main 方法返回主线程。

6、通过 Thread.Join 方法来执行线程，这个方法会挂起主线程，直到当前线程执行完毕。

### 3. 线程状态


```
可执行	run
睡眠	   Sleeping
退出	   aborting
正常终止	   false
发生异常终止	nil

```

### 4. 线程和异常

> 当某线程发生异常，且没有被rescue捕捉到时，该线程通常会被无警告地终止。但是，若有其它线程因为Thread#join的关系一直等待该线程的话，则等待的线程同样会被引发相同的异常。


```
begin
  t = Thread.new do
    Thread.pass    # 主线程确实在等join
    raise "unhandled exception"
  end
  t.join
rescue
  p $!  # => "unhandled exception"
end
```

>使用下列3个方法，就可以让解释器在某个线程因异常而终止时中断运行。
- 启动脚本时指定-d选项，并以调试模时运行。
- 用Thread.abort_on_exception设置标志。
- 使用Thread#abort_on_exception对指定的线程设定标志。


### 5. 线程同步控制

> 在Ruby中，提供三种实现同步的方式，分别是：

1. 通过Mutex类实现线程同步

2. 监管数据交接的Queue类实现线程同步

3. 使用ConditionVariable实现同步控制

#### (1) 通过Mutex类实现线程同步
通过Mutex类实现线程同步控制，如果在多个线程钟同时需要一个程序变量，可以将这个变量部分使用lock锁定。 代码如下：

#### (2) 监管数据交接的Queue类实现线程同步

Queue类就是表示一个支持线程的队列，能够同步对队列末尾进行访问。不同的线程可以使用统一个对类，但是不用担心这个队列中的数据是否能够同步，另外使用SizedQueue类能够限制队列的长度

SizedQueue类能够非常便捷的帮助我们开发线程同步的应用程序，应为只要加入到这个队列中，就不用关心线程的同步问题。

经典的生产者消费者问题：


```
#!/usr/bin/ruby
 
require "thread"
puts "SizedQuee Test"
 
queue = Queue.new
 
producer = Thread.new do
     10.times do |i|
          sleep rand(i) # 让线程睡眠一段时间
          queue << i   #把
          puts "#{i} produced"
     end
end
 
consumer = Thread.new do
     10.times do |i|
          value = queue.pop
          sleep rand(i/2)
          puts "consumed #{value}"
     end
end
 
consumer.join
```

### 6. 线程变量

> 线程可以有其私有变量，线程的私有变量在线程创建的时候写入线程。可以被线程范围内使用，但是不能被线程外部进行共享。

> 但是有时候，线程的局部变量需要别别的线程或者主线程访问怎么办？ruby当中提供了允许通过名字来创建线程变量，类似的把线程看做hash式的散列表。通过[]=写入并通过[]读出数据。我们来看一下下面的代码：

```
#!/usr/bin/ruby
 
count = 0
arr = []
 
10.times do |i|
   arr[i] = Thread.new {
      sleep(rand(0)/10.0)
      Thread.current["mycount"] = count  #赋值给线程定义的变量
      count += 1
   }   #线程定义为hash表
end
 
arr.each {|t| t.join; print t["mycount"], ", " }
puts "count = #{count}"

```
### 7.线程优先级

线程的优先级是影响线程的调度的主要因素。其他因素包括占用CPU的执行时间长短，线程分组调度等等。

可以使用 Thread.priority 方法得到线程的优先级和使用 Thread.priority= 方法来调整线程的优先级。

线程的优先级默认为 0 。 优先级较高的执行的要快


### 8. 线程互斥

> Mutex(Mutal Exclusion = 互斥锁)是一种用于多线程编程中，防止两条线程同时对同一公共资源（比如全局变量）进行读写的机制。


### 9.死锁
两个以上的运算单元，双方都在等待对方停止运行，以获取系统资源，但是没有一方提前退出时，这种状况，就称为死锁。

例如，一个进程 p1占用了显示器，同时又必须使用打印机，而打印机被进程p2占用，p2又必须使用显示器，这样就形成了死锁。

当我们在使用 Mutex 对象时需要注意线程死锁。