[![Code Climate](https://codeclimate.com/github/vinsol/basic_presenter.png)](https://codeclimate.com/github/vinsol/basic_presenter)

# BasicPresenter
# 



BasicPresenter adds a layer of presentation logic to your application.

Its inspired from https://github.com/railscasts/287-presenters-from-scratch/ and
http://svs.io/day/2012/12/27

## Inspiration

Rails being a flexible framework starts with all methods being part of model and
when it gets big, developers are haunted with the daunting task of its maintenance.

Leveraging Presentation pattern with Presenters requires lot of context loading with
separating view/derived methods from actual objects and moving them to presenters and making
relevant changes to instantiate right object wherever needed.

By letting the knowledge of Presenters slip through model leveraging delegation helps us with
the movement of view/derived methods from actual objects to presenters without letting other
code to know about the delegation and change. Strict movement and no other code change.

## Why use Presenters?

Presenters deal with presentation, so your models can concentrate on
domain logic. Instead of polluting models with presenter logic, you can implement the
presenter method in a presenter instead.

## Installation

Requires active_support

Add this line to your application&#39;s Gemfile:

    gem 'basic_presenter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install basic_presenter

Or to use the edge version, add this to your Gemfile:

    gem 'basic_presenter', :github => 'vinsol/basic_presenter'

## Usage


#### Creating Presenter Directory

```sh
rails g basic_presenter:install
```

#### Generating Presenters

To generate a presenter by itself:

```sh
rails g basic_presenter:presenter User
```

### Writing Presenters

Presenters are stored in `app/presenters`, they inherit from
`BasicPresenter::BasePresenter` and are named based on the model they
present. We also recommend you create an `ApplicationPresenter`.

### Accessing the Model

You can access the model using the `domain_object` method, or the model name (in this case `user`). For example:


```ruby
# app/models/user.rb
class User
  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end 
end

# app/presenters/application_presenter.rb
class ApplicationPresenter < BasicPresenter::BasePresenter 
end
  

# app/presenters/user_presenter.rb
class UserPresenter < ApplicationPresenter
  # You can access the model using the `domain_object` method,
  # or the model name (in this case `user`). For example:

  presents :user

  @delegation_methods = [:first_name, :last_name]

  # Use ActiveSupport `delegate`
  delegate *@delegation_methods, to: :user

  def full_name
    first_name + last_name
  end
end
```

The model name is either inferred from the model class name - taking
`User` and adding `Presenter` to it.  
`presents` creates a wrapper for domain model object to call it close to
domain than something like `domain_object`


### Wrapping Models with Presenters

#### Just pass the model to a new presenter instance:

```ruby
user = User.new('Vinsol', 'User')
user_presenter = UserPresenter.new(user)
user_presenter.full_name # Output: VinsolUser
```

#### Use model `#presenter` method

```ruby
# app/models/user.rb
class User
  include BasicPresenter::Concern

  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

user = User.new('Vinsol', 'User')
user.presenter.full_name # Output: VinsolUser
```

#### Override default_presenter class `UserPresenter` for User, you can set `AdminPresenter`

```ruby
# app/presenters/admin_presenter.rb
class AdminPresenter < ApplicationPresenter
  # You can access the model using the `domain_object` method,
  # or the model name (in this case `admin`). For example:

  presents :admin

  @delegation_methods = [:first_name, :last_name]

  # Use ActiveSupport `delegate`
  delegate *@delegation_methods, to: :admin

  def full_name
    "#{first_name}-#{last_name}"
  end
end

user = User.new('Vinsol', 'User')
user.presenter.full_name # Output: VinsolUser
user.presenter_class = AdminPresenter
user.presenter.full_name # Output: Vinsol-User
```

#### Enhancing `User` to allow calls like `user.presenter.full_name` to be `user.full_name`

```ruby
# app/models/user.rb
class User
  include BasicPresenter::Concern

  attr_accessor :first_name, :last_name

  @delegation_methods = [:full_name]

  # Use ActiveSupport `delegate`
  # No change in this line needed
  # As BasicPresenter::Concern Module always exposes presenter method
  # to return presenter instance

  delegate *@delegation_methods, to: :presenter

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

user = User.new('Vinsol', 'User')
user.presenter.full_name # Output: VinsolUser
user.full_name # Output: VinsolUser
user.presenter_class = AdminPresenter
user.presenter.full_name # Output: Vinsol-User
user.full_name # Output: Vinsol-User
```


### Testing

#### RSpec

**PENDING:** The specs are placed in `spec/presenters`. Add `type: :presenter` if they are placed elsewhere.

## Acknowledgements

- https://github.com/railscasts/287-presenters-from-scratch/
- http://svs.io/day/2012/12/27

## License

Mozilla Public License Version 2.0

Free to use in open source or proprietary applications, with the
caveat that any source code changes or additions to files covered
under MPL V2 can only be distributed under the MPL V2 or secondary
license as described in the full text.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

[![vinsol.com: Ruby on Rails, iOS and Android
developers](http://vinsol.com/vin_logo.png "Ruby on Rails, iOS and
Android developers")](http://vinsol.com)

Copyright (c) 2014 [vinsol.com](http://vinsol.com "Ruby on Rails, iOS
and Android developers"), released under the New MIT License

