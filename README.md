# IvarEquatable

This Ruby gem which adds a module which when included to a class enables its instances to be compared based on their instance variables.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ivar_equatable

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ivar_equatable

## Usage

Include the `IvarEquatable` module in your class to make its
instances capable of comparing themselves with the `==` and `eql?` methods.

In order for two objects to be equal, they've got to have
the same instance variables, and the values stored in them have to return
`true` when compared using the `==` operator.

```rb
class MyClass
    include IvarEquatable

    attr_accessor :foo, :bar

    def initialize(foo: nil, bar: nil)
        @foo = foo
        @bar = bar
    end
end

obj1 = MyClass.new foo: :some_value
obj2 = MyClass.new foo: :some_value
obj1 == obj2 #=> true

obj1 = MyClass.new foo: :some_value
obj2 = MyClass.new foo: :other_value
obj1 == obj2 #=> false

obj1 = MyClass.new foo: :some_value
obj2 = MyClass.new foo: :some_value, bar: 2
obj1 == obj2 #=> false

obj1 = MyClass.new foo: { some: { nested: [:hash, :and, :array] } }
obj2 = MyClass.new foo: { some: { nested: [:hash, :and, :array] } }
obj1 == obj2 #=> true

obj1 = MyClass.new foo: { some: { nested: [:hash, :and, :array] } }
obj2 = MyClass.new foo: { some: { nested: :different } }
obj1 == obj2 #=> false

# works on subclasses
class ChildClass < MyClass; end

obj1 = MyClass.new foo: :some_value
obj2 = ChildClass.new foo: :some_value
obj1 == obj2 #=> true

# comparing instances of unrelated classes always returns `false`
class NonRelatedClass
    include IvarEquatable

    attr_accessor :foo, :bar

    def initialize(foo: nil, bar: nil)
        @foo = foo
        @bar = bar
    end
end

obj1 = MyClass.new foo: :some_value
obj2 = NonRelatedClass.new foo: :some_value
obj1 == obj2 #=> false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Verseth/ivar_equatable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
