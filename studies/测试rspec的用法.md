### 1. rspec 的用法

```
bundle exec rspec spec/models/user_spec.rb
```

### 2. factory_bot_rails
> 创建假数据

```ruby
# 自动使用以下文件
factories.rb
test/factories.rb
spec/factories.rb
factories/*.rb
test/factories/*.rb
spec/factories/*.rb
```

```ruby
#示例
FactoryBot.define do
  factory :report do
    sequence(:subject) { |n| "Test subject-#{n}" }
    event_time { '2019-03-08 11:11' }
    description { 'Something went wrong' }
    reason { 'reason' }
    impact { 'impact' }
    solution { 'solution' }
    lession { 'lession' }
    user
    related_users { [1] }
  end
end
```

### 3. 针对only Ruby项目
```Ruby 
# 1. 新建测试文件
rspec --init

#2. 运行测试
rspec spec/models/user_spec.rb
```


### 4. rspect 


1. 根据条件分开测试时，使用 `context`
2. 根据方法来测试时，使用`descript`.(本质上没有大的区别)

### 5. 测试的部分示例
```ruby

# 返回 index的结果 

require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  describe "GET #index" do
    it "should assgins all posts to @posts" do
      post = Post.create(title:"Testing post", content:"lorem ipsm")
      get :index
      expect(assigns(:posts)).to eq [post]
    end
  end
end

# 备注： 
# 1. get :index 这里前面get是指定使用的http method（也就是get post patch delete），后面则是用symbol來指定action
# 2. 这里是assigns(:posts)，也就是我们在controller中的@posts
# 3. 后面是预期传回来的值，現在新的写法是expect(assigns(:posts)).to eq [post]
```

```ruby

# 返回 show的结果

describe "GET #show" do
    it "should assigns post to @post" do
      post = Post.create(title:"Testing post", content:"lorem ipsm")  
      get :show, id: post
      expect(assigns(:post)).to eq post 
    end
  end
  
# 备注： 
# 1. 这里是assigns(:post)，也就是我们在controller中的@post
# 2. 后面是预期传回来的值，現在新的写法是expect(assigns(:post)).to eq post
```

```ruby
# 返回 new的结果

describe "GET #new" do
    it "should assigns a new post to @post" do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end
```

```ruby 
# 返回 create 及 params 验证

describe "POST #create" do
    context "with valid params" do
      it "should create a post" do
        valid_post_params = {title: "Valid title", content: "Valid content"}
        expect {
          post :create, post: valid_post_params
        }.to change(Post, :count).by(1)
      end
      it "should redirect to post" do
        valid_post_params = {title: "Valid title", content: "Valid content"}
        post :create, post: valid_post_params
        expect(response).to redirect_to Post.last
      end
    end

    context "with invalid params" do
      it "should not create a post" do
        invalid_post_params = {title: "", content: "doesn't matter"}
        expect {
          post :create, post: invalid_post_params
        }.not_to change(Post, :count)
      end
      it "should render edit template" do
        invalid_post_params = {title: "", content: "doesn't matter"}
        post :create, post: invalid_post_params
        expect(response).to render_template(:new)
      end
    end
  end
  
  #备注 
  
  # 1. .to change(Post, :count).by(1) 很直觀的，如果create成功，那Post的count就會自動多一個。
 # 2. .not_to change(Post, :count) 沒create成功，not_to 就是to的反向（這裡也可以改寫成.to change(Post, :count).by(0)）
```

```ruby 
# 返回 update 及 params 验证
describe "PUT #update" do

    let(:post) { Post.create(title: "For test", content: "lalala") }

    context "with valid params" do
      it "should update post's attributes" do
        valid_post_params = {title: "Changed title" }
        put :update, id: post, post: valid_post_params
        post.reload
        expect(post.title).to eq valid_post_params[:title]
      end

      it "should redirect to show page" do
        valid_post_params = {title: "Changed title" }
        put :update, id: post, post: valid_post_params
        expect(response).to redirect_to(post)
      end
    end

    context "with invalid params" do

      it "should not update post's attributes" do
        invalid_post_params = {title: "", content: "doesn't matter"}
        put :update, id: post, post: invalid_post_params
        post.reload
        expect(post.content).not_to eq invalid_post_params[:content]
      end

      it "should render edit template" do
        invalid_post_params = {title: "", content: "doesn't matter"}
        put :update, id: post, post: invalid_post_params
        expect(response).to render_template(:edit)
      end
    end
  end
  
  #备注 
  # let 在使用的時候才會用到，所以不直接用variable來做（每一個it都是一個新的）

# 但是用let!可以讓他在宣告的時候就直接執行這一行
```

```ruby 
# 删除
 describe "DELETE #destroy" do
    let!(:post) { Post.create(title: "OK bye", content: "doesn't matter") } 

    it "should delete a post" do
       expect {
        delete :destroy, id: post
       }.to change(Post, :count).by(-1)
    end

    it "should redirect to index page" do
      delete :destroy, id: post
      expect(response).to redirect_to(posts_url)
    end
  end
```

```ruby 
# 测试respond 结果，需使用 render_views
context '#index' do
    render_views

    it 'should render page if query results is empty' do
      get :index
      expect(response).to be_successful
    end

    it 'should correct when sort by app id' do
      get :index, params: { sort_field: 'display_app_id', sort_order: 'desc' }
      expect(response).to be_successful
    end

    it 'when sort_field is "na", should change to "net_spend" ' do
      params = {
        sort_field: "na"
      }
      get :index, params: params
      expect(controller.params[:sort_field]).to eq("net_spend")   #测试返回的controller params 
    end
  end
  
  # 备注： 
  # 1. response 有多种方法， 可以使用 
  # expect(response.status).to eq(200) 判断状态值；
  # expect(response.content_type).to eq "text/html" 判断返回头部信息
  # expect(controller.params[:sort_field]).to eq("net_spend")  可以获取运行后的 controller 里的params值
```

```ruby 

# 引入 ENV的变量 
# allow 方法 用于包装一个对象来准备在其上存储一个方法

allow(ENV).to receive(:[]).with("CLICK_TABLE_NAME").and_return("click_logs")

# allow_any_instance_of 用于包装一个类，准备在其实例上存储一个方法
allow_any_instance_of(FeedmobFmApi::Client).to receive_message_chain(:get).and_raise(Faraday::ClientError.new(400))

# expect_any_instance_of 用于包装类，以准备在其实例上设置模拟期望； receive_message_chain  对对象上的消息链进行存根/模拟或双重测试（描述方法的）。
expect_any_instance_of(self.class).to receive_message_chain(:pg_connection, :exec).with("sql 语句")
```