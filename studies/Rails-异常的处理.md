### Ruby 异常

```
begin #开始
 
 raise.. #抛出异常
 
rescue [ExceptionType = StandardException] #捕获指定类型的异常默认值是 StandardException
 $! #表示异常信息
 $@ #表示异常出现的代码位置
else #其余异常
 ..
ensure #不管有没有异常，进入该代码块
 
end #结束
```
> 从 begin 到 rescue 中的一切是受保护的。如果代码块执行期间发生了异常，控制会传到 rescue 和 end 之间的块。

### 使用 retry 语句

```
begin
    # 这段代码抛出的异常将被下面的 rescue 子句捕获
rescue
    # 这个块将捕获所有类型的异常
    retry  # 这将把控制移到 begin 的开头
end
```

> 如果被retry仍然报错，本实例代码会无限尝试。所以异常处理时，谨慎使用 retry。


### 使用 raise 语句


```
begin  
    puts 'I am before the raise.'  
    raise 'An error has occurred.'  
    puts 'I am after the raise.'  
rescue  
    puts 'I am rescued.'  
end  
puts 'I am after the begin block.'
```
### 使用 ensure 语句

> 有时候，无论是否抛出异常，您需要保证一些处理在代码块结束时完成。例如，您可能在进入时打开了一个文件，当您退出块时，您需要确保关闭文件。

> ensure 子句做的就是这个。ensure 放在最后一个 rescue 子句后，并包含一个块终止时总是执行的代码块。它与块是否正常退出、是否抛出并处理异常、是否因一个未捕获的异常而终止，这些都没关系，ensure 块始终都会运行。


```
begin 
   #.. 过程
   #.. 抛出异常
rescue 
   #.. 处理错误 
ensure 
   #.. 最后确保执行
   #.. 这总是会执行
end
```


### 使用 else 语句

> 如果提供了 else 子句，它一般是放置在 rescue 子句之后，任意 ensure 之前。else 子句的主体只有在代码主体没有抛出异常时执行。


```
begin 
   #.. 过程 
   #.. 抛出异常
rescue 
   #.. 处理错误
else
   #.. 如果没有异常则执行
ensure 
   #.. 最后确保执行
   #.. 这总是会执行
end
```

### 类 Exception

> Ruby 的标准类和模块抛出异常。所有的异常类组成一个层次，包括顶部的 Exception 类在内。下一层是七种不同的类型：

- Interrupt
- NoMemoryError
- SignalException
- ScriptError
- StandardError
- SystemExit


> ScriptError 和 StandardError 都有一些子类，但是在这里我们不需要了解这些细节。最重要的事情是创建我们自己的异常类，它们必须是类 Exception 或其子代的子类。


```
class FileSaveError < StandardError
   attr_reader :reason
   def initialize(reason)
      @reason = reason
   end
end

File.open(path, "w") do |file|
begin
    # 写出数据 ...
rescue
    # 发生错误
    raise FileSaveError.new($!)
end
end
```

> 在这里，最重要的一行是 raise FileSaveError.new($!)。我们调用 raise 来示意异常已经发生，把它传给 FileSaveError 的一个新的实例，由于特定的异常引起数据写入失败。
