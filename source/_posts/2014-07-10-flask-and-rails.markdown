---
layout: post
title: "Flask and Rails part 1"
date: 2014-07-10 17:41:11 +0800
comments: true
categories: ['Ruby', 'Rails', 'Python', 'Flask', 'SQLAchemy']
---

I have written flask recently,with a little project that I can study python.

I used to write Ruby on Rails, which is a very famous web framework and the most popular web framework all over the world.Rails is really really fast to develop most web products,MVC with RESTful design makes very thing easy. Based on meta-programming, the ActiveRecord makes data handles fly in the air.

But flask is also an awesome web framework after a few days since I write my project.It’s more like sinatra,which is a light ruby web framework.

### Request handle
With rails,you need to handle a request URL at `routes.rb`
```ruby
get ‘blogs’ => ‘blogs#index’
```
This code will handle `/blogs` GET method  to a controller named `blogs_controller.rb` in `app/controller/`,and pass the params to function named `index`. After process the request,rails will render a view named `index.html.erb` in `app/views/blogs/`.

With flask,you need to handle a request URL at `app.py`
```python
@app.route(‘/blogs’)
def index():
    return render_template(‘index')
```
### ORM

In my own words,ActiveRecord is much better than SQLAlchemy.

The Types of Associations in Rails:

* belongs_to
* has_one
* has_many
* has_many :through
* has_one :through
* has_and_belongs_to_many

Here are some data relationship implements of two ORM:

#### One to Many

With Rails:

```ruby     
class Customer < ActiveRecord::Base
  has_many :orders, dependent: :destroy
end
          
class Order < ActiveRecord::Base
  belongs_to :customer
end
```

 Now you can get a customer’s orders by:
```ruby
          @order = @customer.order.all()
```
Get an order’s customer by:
```ruby
          @customer = @order.customer
```

With SQLAchemy:

```python
class App(db.Model):
     __tablename__  = 'apps'
     owner_id       = db.Column(db.Integer, db.ForeignKey(‘users.id'))
     owner          = db.relationship('User', backref=db.backref('apps’))

class User(db.Model):
      __tablename__  =  'users'
       id            =  db.Column('id', db.Integer, primary_key=True)
```
Now you can get a user’s apps by:

```python
          app = user.apps
```
Get an app’s owner by:
```python
          user = app.owner
```
#### Many to Many



Although you need migration files in rails,since Flask and SQLAlchemy just configure data structure within model.The benefit of migration files comes out when you want to change your data structure of model.And now I finally known why my teacher ask me to design data structure at first,because other web framework have no ideas about what if our data structure changed.

With migration files in rails, you can change you data structure so easy that you can develop really really align.All details about the program becomes more and more clear after you start coding.