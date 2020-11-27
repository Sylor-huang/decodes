无价的 Gems

> 一个最重要的编程理念是 "不要重造轮子！" 。若你遇到一个特定问题，你应该要在你开始前，看一下是否有存在的解决方案。下面是一些在很多 Rails 项目中 "无价的" gem 列表（全部兼容 Rails 3.1）：

1. active_admin - 有了 ActiveAdmin，创建 Rails 应用的管理介面就像儿戏。你会有一个很好的仪表盘，图形化 CRUD 介面以及更多东西。非常灵活且可客制化。

1. capybara - Capybara 旨在简化整合测试 Rack 应用的过程，像是 Rails、Sinatra 或 Merb。Capybara 模拟了真实用户使用 web 应用的互动。 它与你测试在运行的驱动无关，并原生搭载 Rack::Test 及 Selenium 支持。透过外部 gem 支持 HtmlUnit、WebKit 及 env.js 。与 RSpec & Cucumber 一起使用时工作良好。

1. carrierwave - Rails 最后一个文件上传解决方案。支持上传档案（及很多其它的酷玩意儿的）的本地储存与云储存。图片后处理与 ImageMagick 整合得非常好。

1. clientsidevalidations - 一个美妙的 gem，替你从现有的服务器端模型验证自动产生 Javascript 用户端验证。高度推荐！

1. compass-rails - 一个优秀的 gem，添加了某些 css 框架的支持。包括了 sass mixin 的蒐集，让你减少 css 文件的代码并帮你解决浏览器兼容问题。

1. cucumber-rails - Cucumber 是一个由 Ruby 所写，开发功能测试的顶级工具。 cucumber-rails 提供了 Cucumber 的 Rails 整合。

1. devise - Devise 是 Rails 应用的一个完整解决方案。多数情况偏好使用 devise 来开始你的客制验证方案。

1. fabrication - 一个很好的假数据产生器（编辑者的选择）。

1. factory_girl - 另一个 Fabrication 的选择。一个成熟的假数据产生器。 Fabrication 的精神领袖先驱。

1. faker - 实用的 gem 来产生仿造的数据（名字、地址，等等）。

1. feedzirra - 非常快速及灵活的 RSS 或 Atom 种子解析器。

1. friendly_id - 透过使用某些具描述性的模型属性，而不是使用 id，允许你创建人类可读的网址。

1. guard - 极佳的 gem 监控文件变化及任务的调用。搭载了很多实用的扩充。远优于 autotest 与 watchr。

1. kaminari - 很棒的分页解决方案。

1. machinist - 假数据不好玩，Machinist 才好玩。

1. rspec-rails - RSpec 是 Test::MiniTest 的取代者。我不高度推荐 RSpec。 rspec-rails 提供了 RSpec 的 Rails 整合。

1. simpleform - 一旦用过 simpleform（或 formatastic），你就不想听到关于 Rails 缺省的表单。它是一个创造表单很棒的DSL。

1. simplecov-rcov - 为了 SimpleCov 打造的 RCov formatter。若你想使用 SimpleCov 搭配 Hudson 持续整合服务器，很有用。

1. simplecov - 代码覆盖率工具。不像 RCov，完全兼容 Ruby 1.9。产生精美的报告。必须用！
1. 
1. slim - Slim 是一个简洁的模版语言，被视为是远远优于 HAML(Erb 就更不用说了)的语言。唯一会阻止我大规模地使用它的是，主流 IDE 及编辑器对它的支持不好。但它的效能是非凡的。

1. spork - 一个给测试框架（RSpec 或 现今 Cucumber）用的 DRb 服务器，每次运行前确保分支出一个乾净的测试状态。 简单的说，预载很多测试环境的结果是大幅降低你的测试启动时间，绝对必须用！

1. sunspot - 基于 SOLR 的全文检索引擎。


```
gem install parallel   #多线程/进程处理任务
```

```
gem 'harmonious_dictionary'  #敏感词汇
```


```
gem "audited", "~> 4.9"  #操作的记录
```


```
gem 'bulk_insert'  #快速的批量插入，批量通知时有效
```
