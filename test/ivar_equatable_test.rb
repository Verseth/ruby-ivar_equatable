# frozen_string_literal: true

require 'test_helper'

class IvarEquatableTest < ::Minitest::Test
  module Writable
    # Sets instance variables and
    # defines methods based on given
    # keyword arguments
    def initialize(**kwargs)
      kwargs.each do |key, val|
        instance_variable_set(:"@#{key}", val)
        define_singleton_method(key) do
          instance_variable_get(:"@#{key}")
        end
      end
    end
  end

  class TestObject
    include IvarEquatable
    include Writable
  end

  class ChildTestObject < TestObject; end

  class OtherTestObject
    include IvarEquatable
    include Writable
  end

  def setup
    @obj = TestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(eluwina: 3)
        ]
      },
    )
  end

  should 'have a version number' do
    refute_nil ::IvarEquatable::VERSION
  end

  should 'be equal when instance vars are equal' do
    other = TestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(eluwina: 3)
        ]
      },
    )
    assert_equal other, @obj
    assert_equal @obj, other
  end

  should 'not be equal when instance vars are not equal' do
    other = TestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(siema: 3)
        ]
      },
    )
    assert other != @obj
    assert @obj != other
  end

  should 'be eql when instance vars are equal' do
    other = TestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(eluwina: 3)
        ]
      },
    )
    assert other.eql?(@obj)
    assert @obj.eql?(other)
  end

  should 'not be eql when instance vars are not equal' do
    other = TestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(siema: 3)
        ]
      },
    )
    assert !other.eql?(@obj)
    assert !@obj.eql?(other)
  end

  should 'not be eql when instance vars are equal and class is different' do
    other = OtherTestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(eluwina: 3)
        ]
      },
    )
    assert !other.eql?(@obj)
    assert !@obj.eql?(other)
  end

  should 'be eql when instance vars are equal and class is related' do
    other = ChildTestObject.new(
      hash_attr: {
        array_attr: [
          TestObject.new(eluwina: 3)
        ]
      },
    )
    assert other.eql?(@obj)
    assert @obj.eql?(other)
  end
end
