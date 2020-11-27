#### 1. vue的渲染过程

```
# 加载渲染过程

父 beforeCreate -> 父 created -> 父 beforeMount ->  子 beforeCreate -> 子 created -> 子 beforeMount -> 子 mounted -> 父 mounted

#子组件更新过程

父 beforeUpdate -> 子 beforeUpdate -> 子 updated -> 父 updated

#父组件更新过程

 父 beforeUpdate -> 父 updated

#销毁过程
 父 beforeDestroy ->  子 beforeDestroy -> 子 destroyed -> 父 destroyed
```

#### 2. 图片懒加载,滚动后到一定区域图片才加载
>对于图片过多的页面，为了加速页面加载速度，所以很多时候我们需要将页面内未出现在可视区域内的图片先不做加载， 等到滚动到可视区域后再去加载。这样对于页面加载性能上会有很大的提升，也提高了用户体验。我们在项目中使用 Vue 的 vue-lazyload 插件：
```

#（1）安装插件
npm install vue-lazyload --save-dev

#（2）在入口文件 man.js 中引入并使用
import VueLazyload from 'vue-lazyload'

#复制代码然后再 vue 中直接使用

Vue.use(VueLazyload)

# 复制代码或者添加自定义选项

Vue.use(VueLazyload, {
preLoad: 1.3,
error: 'dist/error.png',
loading: 'dist/loading.gif',
attempt: 1
})

#（3）在 vue 文件中将 img 标签的 src 属性直接改为 v-lazy ，从而将图片显示方式更改为懒加载显示：
<img v-lazy="/static/img/1.png">
复制代码以上为 vue-lazyload 插件的简单使用，如果要看插件的更多参数选项，可以查看 vue-lazyload 的 github 地址。
```


#### 3. sourceMap的调试

```
浏览器的 Setting > Scources > Enable JavaScript source maps
```

#### 4. 断点调试


```
Sources面板找到源文件，进行断点调试
如果没Console没报错，但是页面显示不正确。可以点击控制台的Sources面板，源文件都在 webpack:// 目录下，或者直接搜索文件，打开源文件后进行断点调试。
```

#### 5. webpack配置

```

vue-cli3的vue.config.js文件：

module.exports = {
    productionSourceMap: false, //默认是true
}
```

#### 6. 父组件可以监听到子组件的生命周期

```
// 第一种方法
// Parent.vue
<Child @mounted="doSomething"/>
    
// Child.vue
mounted() {
  this.$emit("mounted");
}

// 第二种方法
//  Parent.vue
<Child @hook:mounted="doSomething" ></Child>

doSomething() {
   console.log('父组件监听到 mounted 钩子函数 ...');
},
    
//  Child.vue
mounted(){
   console.log('子组件触发 mounted 钩子函数 ...');
},    
    
// 以上输出顺序为：
// 子组件触发 mounted 钩子函数 ...
// 父组件监听到 mounted 钩子函数 ...

```


#### 7. 组件中 data 为什么是一个函数


```
// data
data() {
  return {
	message: "子组件",
	childName:this.name
  }
}

// new Vue
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: {App}
})

```

> 因为组件是用来复用的，且 JS 里对象是引用关系，如果组件中 data 是一个对象，那么这样作用域没有隔离，子组件中的 data 属性值会相互影响，如果组件中 data 选项是一个函数，那么每个实例可以维护一份被返回对象的独立的拷贝，组件实例之间的 data 属性值不会互相影响；而 new Vue 的实例，是不会被复用的，因此不存在引用对象的问题。


#### 8. v-model 的原理

我们在 vue 项目中主要使用 v-model 指令在表单 input、textarea、select 等元素上创建双向数据绑定,我们知道 v-model 本质上不过是语法糖，v-model 在内部为不同的输入元素使用不同的属性并抛出不同的事件.

1. text 和 textarea 元素使用 value 属性和 input 事件；
2. checkbox 和 radio 使用 checked 属性和 change 事件；
3. select 字段将 value 作为 prop 并将 change 作为事件。


```
<input v-model='something'>
    
相当于

<input v-bind:value="something" v-on:input="something = $event.target.value">

```

如果在自定义组件中，v-model 默认会利用名为 value 的 prop 和名为 input 的事件，如下所示：

```
// 父组件：
<ModelChild v-model="message"></ModelChild>

// 子组件：
<div>{{value}}</div>

props:{
    value: String
},
methods: {
  test1(){
     this.$emit('input', '小红')
  },
},

```

#### 9. Vue 组件间通信有哪几种方式

（1）props / $emit 适用 父子组件通信

（2）ref 与 $parent / $children 适用 父子组件通信

> ref：如果在普通的 DOM 元素上使用，引用指向的就是 DOM 元素；如果用在子组件上，引用就指向组件实例.
$parent / $children：访问父 / 子实例

（3）EventBus （$emit / $on） 适用于 父子、隔代、兄弟组件通信

> 这种方法通过一个空的 Vue 实例作为中央事件总线（事件中心），用它来触发事件和监听事件，从而实现任何组件间的通信，包括父子、隔代、兄弟组件。

（4）$attrs/$listeners 适用于 隔代组件通信

（5）provide / inject 适用于 隔代组件通信

> 祖先组件中通过 provider 来提供变量，然后在子孙组件中通过 inject 来注入变量。 provide / inject API 主要解决了跨级组件间的通信问题，不过它的使用场景，主要是子组件获取上级组件的状态，跨级组件间建立了一种主动提供与依赖注入的关系。

（6）Vuex 适用于 父子、隔代、兄弟组件通信

> Vuex 是一个专为 Vue.js 应用程序开发的状态管理模式。每一个 Vuex 应用的核心就是 store（仓库）。“store” 基本上就是一个容器，它包含着你的应用中大部分的状态 ( state )。

1. Vuex 的状态存储是响应式的。当 Vue 组件从 store 中读取状态的时候，若 store 中的状态发生变化，那么相应的组件也会相应地得到高效更新。
2. 改变 store 中的状态的唯一途径就是显式地提交  (commit) mutation。这样使得我们可以方便地跟踪每一个状态的变化。
3. 主要包括以下几个模块：

（1）State：定义了应用状态的数据结构，可以在这里设置默认的初始状态。

（2）Getter：允许组件从 Store 中获取数据，mapGetters 辅助函数仅仅是将 store 中的 getter 映射到局部计算属性。

（3）Mutation：是唯一更改 store 中状态的方法，且必须是同步函数。

（4）Action：用于提交

（5）mutation，而不是直接变更状态，可以包含任意异步操作。

（6）Module：允许将单一的 Store 拆分为多个 store 且同时保存在单一的状态树中。


#### 10. 使用过 Vue SSR 吗？

> Vue.js 默认渲染页面生成html标签是在客户端完成。
SSR大致的意思就是 渲染页面生成html标签是在服务端完成，直接返回html代码给客户端。

SSR的优缺点：

一，优点 

（1） 更好的 SEO， 因为 SPA 页面的内容是通过 Ajax 获取，而搜索引擎爬取工具并不会等待 Ajax 异步完成后再抓取页面内容，所以在 SPA 中是抓取不到页面通过 Ajax 获取到的内容；而 SSR 是直接由服务端返回已经渲染好的页面（数据已经包含在页面中），所以搜索引擎爬取工具可以抓取渲染好的页面；
（2） 更快的内容到达时间（首屏加载更快）： SPA 会等待所有 Vue 编译后的 js 文件都下载完成后，才开始进行页面的渲染，文件下载等需要一定的时间等，所以首屏渲染需要一定的时间；SSR 直接由服务端渲染好页面直接返回显示，无需等待下载 js 文件及再去渲染等，所以 SSR 有更快的内容到达时间；

二，缺点

（1）更多的开发条件限制；如：服务端渲染只支持 beforCreate 和 created 两个钩子函数，如果需要使用其他的钩子，需特殊处理；而且服务端渲染应用程序，需要处于 Node.js server 运行环境

（2）更多的服务器负载：在 Node.js 中渲染完整的应用程序，显然会比仅仅提供静态文件的 server 更加大量占用CPU 资源 (CPU-intensive - CPU 密集)

#### 11. vue-router 路由模式

vue-router 有 3 种路由模式：hash、history、abstract


#### 12. 什么是 MVVM
Model–View–ViewModel （MVVM） 是一个软件架构设计模式，MVVM 的出现促进了前端开发与后端业务逻辑的分离，极大地提高了前端开发效率，MVVM 的核心是 ViewModel 层；
ViewModel 是由前端开发人员组织生成和维护的视图数据层。在这一层，前端开发者对从后端获取的 Model 数据进行转换处理，做二次封装，包括视图的状态和行为两部分（Model 层的数据模型是只包含状态的）

> 比如页面的这一块展示什么，而页面加载进来时发生什么，点击这一块发生什么，这一块滚动时发生什么这些都属于视图行为（交互），视图状态和行为都封装在了 ViewModel 里。这样的封装使得 ViewModel 可以完整地去描述 View 层


#### 13. Vue 是如何实现数据双向绑定的

Vue 数据双向绑定主要是指：数据变化更新视图，视图变化更新数据

1. 输入框内容变化时，Data 中的数据同步变化。即 View => Data 的变化。
2. Data 中的数据变化时，文本节点的内容同步变化。即 Data => View 的变化。

其中，View 变化更新 Data ，可以通过事件监听的方式来实现，所以 Vue 的数据双向绑定的工作主要是如何根据 Data 变化更新 View。

（1）监听器 Observer：对数据对象进行遍历，包括子属性对象的属性，利用 Object.defineProperty() 对属性都加上 setter 和 getter。这样的话，给这个对象的某个值赋值，就会触发 setter，那么就能监听到了数据变化。
（2）解析器 Compile：解析 Vue 模板指令，将模板中的变量都替换成数据，然后初始化渲染页面视图，并将每个指令对应的节点绑定更新函数，添加监听数据的订阅者，一旦数据有变动，收到通知，调用更新函数进行数据更新。
（3） 订阅者 Watcher：Watcher 订阅者是 Observer 和 Compile 之间通信的桥梁 ，主要的任务是订阅 Observer 中的属性值变化的消息，当收到属性值变化的消息时，触发解析器 Compile 中对应的更新函数。
（4）订阅器 Dep：订阅器采用 发布-订阅 设计模式，用来收集订阅者 Watcher，对监听器 Observer 和 订阅者 Watcher 进行统一管理。

#### 14. Proxy 与 Object.defineProperty 优劣对比

Proxy 的优势如下:

1. Proxy 可以直接监听对象而非属性；
1. Proxy 可以直接监听数组的变化；
1. Proxy 有多达 13 种拦截方法,不限于 apply、ownKeys、deleteProperty、has 等等是 Object.defineProperty 不具备的；
1. Proxy 返回的是一个新对象,我们可以只操作新的对象达到目的,而 Object.defineProperty 只能遍历对象属性直接修改；
1. Proxy 作为新标准将受到浏览器厂商重点持续的性能优化，也就是传说中的新标准的性能红利；

Object.defineProperty 的优势如下:

兼容性好，支持 IE9


#### 15. 虚拟 DOM 的优缺点

（1） 保证性能下限； 虽然不是最极致优化的，但是比直接操作DOM性能要强。即保证性能的下限
（2）无需手动操作 DOM；只需要写好 View-Model 的代码逻辑，框架会根据虚拟 DOM 和 数据双向绑定，帮我们以可预期的方式更新视图，极大提高我们的开发效率；
（3）跨平台开发；

（4） 缺点： 无法进行极致优化


#### 16. 虚拟 DOM 的实现原理主要包括以下 3 部分：

1. 用 JavaScript 对象模拟真实 DOM 树，对真实 DOM 进行抽象；
1. diff 算法 — 比较两棵虚拟 DOM 树的差异；
1. pach 算法 — 将两个虚拟 DOM 对象的差异应用到真正的 DOM 树。


#### 17. Vue 中的 key 有什么作用

key 是为 Vue 中 vnode 的唯一标记，通过这个 key，我们的 diff 操作可以更准确、更快速


#### 18. 你有对 Vue 项目进行哪些优化

（1）代码层面的优化

1. v-if 和 v-show 区分使用场景
1. computed 和 watch  区分使用场景
1. v-for 遍历必须为 item 添加 key，且避免同时使用 v-if
1. 长列表性能优化（Object.freeze 方法来冻结一个对象，一旦被冻结的对象就再也不能被修改了。）
1. 事件的销毁
1. 图片资源懒加载
1. 路由懒加载
1. 第三方插件的按需引入
1. 优化无限列表性能
1. 服务端渲染 SSR or 预渲染

（2）Webpack 层面的优化

1. Webpack 对图片进行压缩
1. 减少 ES6 转为 ES5 的冗余代码
1. 提取公共代码
1. 模板预编译
1. 提取组件的 CSS
1. 优化 SourceMap
1. 构建结果输出分析
1. Vue 项目的编译优化

（3）基础的 Web 技术的优化


1. 开启 gzip 压缩
1. 浏览器缓存
1. CDN 的使用


#### 19. 对于即将到来的 vue3.0 特性你有什么了解的吗

1. Proxy 替换Object.definProtery() 方法，可以对对象操作，可以对数组操作，有多种劫持方法，返回为一个新的对象
2. 允许使用基于函数的方式编写组件
3. 基于 treeshaking 优化，提供了更多的内置功能

#### 20 。vue-router有哪几种导航钩子

1. 是全局导航钩子（全局守卫）：router.beforeEach(to,from,next)，作用：跳转前进行判断拦截。
2. 全局解析守卫router.beforeResolve,在导航被确认前，所有组件内守卫和异步路由组件被解析之后，解析守卫就被调用。（2.5.0新增）。
3. 单独路由独享的守卫beforeEnter,在路由配置时定义，与全局守卫的方法是一样的。
4. 组件内的守卫。直接在路由组件内定义守卫，


#### 21. 跨域问题使用npm 来配置http-proxy-middleware

#### 22. router-link 的参数解释

1. to: 相当于 href
2. replace：boolean，默认为false，开启后，导航后不会留下 history 记录
3. append：boolean，默认为false，开启后，则在当前 (相对) 路径前添加基路径。我们从 /a 导航到一个相对路径 b，如果没有配置 append，则路径为 /b，如果配了，则为 /a/b
4. tag： string， 默认为"a"， 可以为 "li","div"等
5. active-class ： string, 默认为"router-link-active",
6. exact: boolean, 默认为false，链接是否激活的精准匹配（完全等于）
7. event：string | Array<string>， 默认"click", 声明可以用来触发导航的事件。可以是一个字符串或是一个包含字符串的数组
8. exact-active-class : string, 默认值为：“router-link-exact-active”， 配置当链接被精确匹配的时候应该激活的 class

#### 20. 说说你使用 Vue 框架踩过最大的坑是什么？怎么解决的

1. 使用iview框架，在 modal弹框里不能使用多语言的 $t(),需单独引入
2. vuejs的I18n 现在没有找到合适的方法来拆分按需引入 zh.js.现在的中文都是写在一个文件里
3. 翻页时，父组件的数据变化，但是子组件内容没有变化。子组件对props数据进行 watch,请添加 deep: true
4. 

#### 21. 监听`resize`事件与销毁`resize`事件放到一起，使用hook功能


```
export default {
  mounted() {
    this.chart = echarts.init(this.$el)
    // 请求数据，赋值数据 等等一系列操作...
    
    // 监听窗口发生变化，resize组件
    window.addEventListener('resize', this.$_handleResizeChart)
    // 通过hook监听组件销毁钩子函数，并取消监听事件
    this.$once('hook:beforeDestroy', () => {
      window.removeEventListener('resize', this.$_handleResizeChart)
    })
  },
  updated() {},
  created() {},
  methods: {
    $_handleResizeChart() {
      // this.chart.resize()
    }
  }
}

```

#### 22. 监听子组件的 mounted, updated方法

```
<template>
  <!--通过@hook:updated监听组件的updated生命钩子函数-->
  <!--组件的所有生命周期钩子都可以通过@hook:钩子函数名 来监听触发-->
  <custom-select @hook:updated="$_handleSelectUpdated" />
</template>
<script>
import CustomSelect from '../components/custom-select'
export default {
  components: {
    CustomSelect
  },
  methods: {
    $_handleSelectUpdated() {
      console.log('custom-select组件的updated钩子函数被触发')
    }
  }
}
</script>

作者：前端进击者
链接：https://juejin.im/post/6844904196626448391
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```



