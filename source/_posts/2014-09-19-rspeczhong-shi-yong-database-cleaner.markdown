---
layout: post
title: "Rspec中使用database_cleaner"
date: 2014-09-19 16:56:50 +0800
comments: true
categories: 
---
这两天重新写Rspec测试，参考了 ruby-china 的测试用例和配置方法。

在使用Rspec的过程中因为有使用 FactoryGirl ，发现在一些用例中使用user的时候会发生

	Validation failed: Email has already been taken (ActiveRecord::RecordInvalid)

因为在生成user的时候没有使用单例模式，所有每次向 FactoryGirl 要 user 的时候都会重新生成新的数据，所以就和之前发生冲突了。

参考 ruby-china 的测试代码，发现是使用了 database_cleaner 使得每个测试用例之后清扫了测试数据库，就不会引发冲突了。

```ruby
  config.before(:each) do
    DatabaseCleaner.orm = :mongoid
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    Rails.cache.clear
  end
```


但是当我把 database_cleaner 配置好并加到我项目 rspec 中的时候，却遇到了

	/gems/database_cleaner-0.8.0/lib/database_cleaner/active_record/truncation.rb:62:in `<module:ConnectionAdapters>': superclass mismatch for class SQLite3Adapter (TypeError)

网上搜索一堆无效之后，转而使用另外一个解决方案

```ruby
  config.after(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
```

也就是在跑完每个测试用例之后，删除掉数据库中所有的 Model 数据

由于这样一段代码，接下来我遇到了一个更加头疼的问题。因为我使用 Devise 的 `sign_in user` 在每个测试用例中来模拟登陆后的用户，结果发现，前后两个测试用例，总是出现第一个用例能通过，第二个用例死活通过不了。

```ruby
class TeamsController < ApplicationController
  before_action :authenticate_user!
end

# 第一个 examples 能通过，第二个 examples 无法通过
describe TeamsController, :type => :controller do
  user = FactoryGirl.create(:user)

  describe ":index" do
    it "should show list of teams" do
      sign_in user
      get :index
      expect(response).to be_success
    end
  end

  describe ":new" do
    it "should allow access from authenticated user" do
      sign_in user
      get :new
      expect(response).to be_success
    end
  end

end
```

将第二个 examples 的 response.body 打印出来，发现

	<html><body>You are being <a href="http://test.host/users/sign_in">redirected</a>.</body></html>

无解，然后分别打印两个用例的 controller.current_user，发现后一个是 nil

最终我将 database_cleaner 升级到了 1.3.0 重新bundle了一下，解决了 `superclass mismatch for class SQLite3Adapter` 的问题，移除了那段删除所有 Model 数据的 trick 代码所有的问题全部解决了。