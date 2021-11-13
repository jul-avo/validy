## Validy

![Gem](https://img.shields.io/gem/dt/validy.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/nucleom42/validy.svg)
![Gem](https://img.shields.io/gem/v/validy.svg)

**Problem:**

* Want to have a easy way to validate instance variables in plain ruby object? 
* Wants to update you class with validation helpers like: **validate!, valid?, errors** ..?
* Have a nice coding standard for services where responsibility is validation?

**Solution:**

* Just include Validy into your call and either use setter in order to trigger validation process, or explicitly call **validate!** method.

**Notes:**

* Simple as that. Keep tracking.

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

  def initialize(foo=nil, fool=nil)
    @foo = foo
    @fool = fool
  end

  def foo_valid?
    @foo > 2
  end
end

# ...

# valid 
pry(main)> instance = ValidyFoo.new(4)
pry(main)> instance.validate!
pry(main)> instance.valid?

=> true

pry(main)> instance.errors

=> {}

# invalid 
pry(main)> instance = ValidyFoo.new(0)
pry(main)> instance.validate!
pry(main)> instance.valid?

=> false

pry(main)> instance.errors

=> {:foo=>"No way, it is a rick!"}

pry(main)> instance

=> #<ValidyFoo:0x00007fd90a840450 @errors={:foo=>"No way, it is a rick!"}, @foo=1, @fool=nil, @valid=false>

# set valid value over the setter

pry(main)> instance.foo = 7
pry(main)> instance.valid?
# no need to call validate!
=> true
```

### Notes
