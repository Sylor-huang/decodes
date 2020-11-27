> 学习资料来源w3school

#### 1. Ruby 类中的变量

Ruby 提供了五种类型的变量：

1. **局部变量**：局部变量是在方法中定义的变量。局部变量在方法外是不可用的。在后续的章节中，您将看到有关方法的更多细节。局部变量以小写字母或 _ 开始。
2. **实例变量**：实例变量可以跨任何特定的实例或对象中的方法使用。这意味着，实例变量可以从对象到对象的改变。实例变量在变量名之前放置符号（@）。
3. **类变量**：类变量可以跨不同的对象使用。类变量属于类，且是类的一个属性。类变量在变量名之前放置符号（@@）。
4. **全局变量**：类变量不能跨类使用。如果您想要有一个可以跨类使用的变量，您需要定义全局变量。全局变量总是以美元符号（$）开始。
5. **常量**：常量以大写字母开头。定义在类或模块内的常量可以从类或模块的内部访问，定义在类或模块外的常量可以被全局访问。常量不能定义在方法内，会报错。
6. **伪变量**：它们是特殊的变量，有着局部变量的外观，但行为却像常量。您不能给这些变量赋任何值。

> self: 当前方法的接收器对象。
true: 代表 true 的值。
false: 代表 false 的值。
nil: 代表 undefined 的值。
FILE: 当前源文件的名称。
LINE: 当前行在源文件中的编号。


#### 2. 操作运算符

1. **<=>**
> 联合比较运算符。如果第一个操作数等于第二个操作数则返回 0，如果第一个操作数大于第二个操作数则返回 1，如果第一个操作数小于第二个操作数则返回 -1。


```
1 <=> 3
> -1

3 <=> 1
> 1

3 <=> 3
> 0
```


2. **1..10 和 1...10**
> 1..10包含结束点（1到10）； 1...10 不包含结束点，(1到9)

#### 3. 如果服务器产生 core.* 文件

```
sysctl -w kernel.core_pattern=/dev/null
```


```
# 1. 获取文件的文件名
default_name = "https://www.ruby-lang.org/images/header-ruby-logo@2x.png"
  n = 10000000
  
Benchmark.bm do |x|
    #x.report("file") { n.times do   ; File.basename(default_name); end }
    x.report ("split") { n.times do   ; default_name.split("/").last; end }
end

#split 稍微快点
  
  
 #2.
 
  result= Benchmark.ms do
    exercise.create_exercise_questions_by_random_settings
  end
  Rails.logger.info("创建试题时长:#{result}毫秒")
```

