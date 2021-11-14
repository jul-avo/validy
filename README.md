## Validy

![Gem](https://img.shields.io/gem/dt/validy.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/nucleom42/validy.svg)
![Gem](https://img.shields.io/gem/v/validy.svg)

**Problem:**

* Want to have a easy way to validate instance variables in plain ruby object? 
* Wants to update you class with validation helpers like: **validate, validate!, valid?, errors** ..?
* Have a fabulous coding standard for services where responsibility is validation?

**Solution:**

* Just include Validy into your class and either instantiate your class as usual with MyClass.new or use setters(if defined) or trigger validation process, by explicitly call **validate!** method.

**Notes:**

* Wants to force raise an exception while creating an object if validation failed? Set **validy!** params instead of **validy**:
```ruby
validy! foo: { with: :foo_valid?, error: "No way, it is a rick!" }

..
# foo_valid? returns false
pry(main)> ValidyFoo.new(0)

=> Validy::Error: '{"foo":"No way, it is a rick!"}'
```

## Install

```ruby

gem install validy

```

## Rails

```ruby

gem 'validy'

```

## Examples

```ruby
class ValidyFoo
  include Validy

  validy foo: { with: :foo_valid?, error: "No way, it is a rick!" },
         fool: { with: -> proc{ true }, error: "true is our all" }

  attr_accessor :foo

  def initialize(foo=nil, fool=nil)
    @foo = foo
    @fool = fool
  end

  def foo_valid?
    @foo > 2
  end
  
  def inner_setter
    @foo = -3
    #explicit validation call when its a part of inner logic, not initializer or setter 
    validate
  end
end

# ...

# valid 
pry(main)> instance = ValidyFoo.new(4)
pry(main)> instance.valid?

=> true

pry(main)> instance.errors

=> {}

# invalid 
pry(main)> instance = ValidyFoo.new(0)
pry(main)> instance.valid?

=> false

pry(main)> instance.errors

=> {:foo=>"No way, it is a rick!"}

pry(main)> instance

=> #<ValidyFoo:0x00007fd90a840450 @errors={:foo=>"No way, it is a rick!"}, @foo=1, @fool=nil, @valid=false>

# set valid value over the setter
pry(main)> instance.foo = 7
pry(main)> instance.valid?

=> true

# inner setter with validate
pry(main)> instance.inner_setter
pry(main)> instance.valid?

=> false

# call validate, so silent check will be performed
pry(main)> instance.validate
pry(main)> instance.valid?

=> false

# call validate! so error will be raise in case of failing validation
pry(main)> instance.validate!

=> Validy::Error: '{"foo":"No way, it is a rick!"}'
```

### Notes
