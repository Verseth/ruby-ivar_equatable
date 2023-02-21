# frozen_string_literal: true

require 'set'

require_relative 'ivar_equatable/version'

# Include in a class to make its instances capable
# of comparing themselves with other objects of the same class
# by calling `==` on their instance variables.
#
# Example:
#
#     class MyClass
#       include IvarEquatable
#
#       attr_accessor :foo, :bar
#
#       def initialize(foo: nil, bar: nil)
#         @foo = foo
#         @bar = bar
#       end
#     end
#
#     obj1 = MyClass.new foo: :some_value
#     obj2 = MyClass.new foo: :some_value
#     obj1 == obj2 #=> true
#
#     obj1 = MyClass.new foo: :some_value
#     obj2 = MyClass.new foo: :other_value
#     obj1 == obj2 #=> false
#
#     obj1 = MyClass.new foo: :some_value
#     obj2 = MyClass.new foo: :some_value, bar: 2
#     obj1 == obj2 #=> false
#
module IvarEquatable
  # @param other [Object]
  # @return [Boolean]
  def eql?(other)
    return true if equal?(other)
    return false unless other.is_a?(self.class) || is_a?(other.class)

    # @type [Set<Symbol>]
    self_ivars = instance_variables.to_set
    # @type [Set<Symbol>]
    other_ivars = other.instance_variables.to_set

    return false unless self_ivars == other_ivars

    self_ivars.each do |ivar|
      return false if instance_variable_get(ivar) != other.instance_variable_get(ivar)
    end

    true
  end

  alias == eql?
end
