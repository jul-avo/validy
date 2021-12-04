## Validy

![Gem](https://img.shields.io/gem/dt/validy.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/nucleom42/validy.svg)
![Gem](https://img.shields.io/gem/v/validy.svg)

**Problem:**

* Want to have a easy way to validate instance variables in plain ruby object? 
* Wants to update you class with validation helpers like: **validate, validate!, valid?, errors** ..?
* Have a fabulous coding standard for services where responsibility is validation?

**Solution:**

* Just include Validy into your class and either instantiate your class as usual with MyClass.new or use setters(if defined) or trigger validation process, by explicitly call **validate** or **validate!** method.

**Notes:**

* Wants to force raise an exception while creating an object if validation failed? Set **validy!** params instead of **validy**:
```ruby
class ValidyFoo
  include Validy

  attr_accessor :foo, :fool

  validy! foo: { with: :bigger_than_two? , error: "No way, it is a rick!" },
         fool: { with: :not_eq_to_ten? }

  def initialize(foo=nil, fool=10)
    @foo = foo
    @fool = fool
  end

  def bigger_than_two?
    # return boolean in order to evaluate validy
    @foo && @foo > 2
  end

  def not_eq_to_ten?
    # add customized error from the validation method
    add_error fool: "#{@fool} not eq to 10" unless @fool == 10
    true
  end
..
pry(main)> ValidyFoo.new(0, 11)
# error message will be taken from the validy error attribute
# if not set over the add_error method
=> Validy::Error: '{"foo":"No way, it is a rick!", "fool": "11 not eq to 10"}'

pry(main)> ValidyFoo.new

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

  attr_accessor :foo, :fool

  validy foo: { with: :bigger_than_two? , error: "No way, it is a rick!" },
          fool: { with: :not_eq_to_ten? }
  # error message takes by following priority: 
  # either set by 'add_error' method or set by validy error: param or default one
  
  def initialize(foo=nil, fool=10)
    @foo = foo
    @fool = fool
  end

  def bigger_than_two?
    # return boolean in order to evaluate validy
    @foo && @foo > 2
  end

  def not_eq_to_ten?
    # add customized error from the validation method
    add_error fool: "#{@fool} not eq to 10" unless @fool == 10
    # do not forget to return boolean value
    true
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

# set invalid value while instantiating
pry(main)> instance = ValidyFoo.new(0, 11)
pry(main)> instance.valid?

=> false

pry(main)> instance.errors

=> {:foo=>"No way, it is a rick!", :fool=>"11 not eq to 10"}

pry(main)> instance

=> #<ValidyFoo:0x00007fd90a840450 @errors={:foo=>"No way, it is a rick!", :fool=>"11 not eq to 10"}, @foo=1, @fool=nil, @valid=false>

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