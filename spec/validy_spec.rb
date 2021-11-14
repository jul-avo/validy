# frozen_string_literal: true

require 'spec_helper'

class ValidyFoo
  include Validy
  
  attr_accessor :foo

  validy foo: { with: :foo_valid?, error: "No way, it is a rick!" },
           fool: { with: ->proc{ true }, error: "true is our all" }

  def initialize(foo=nil, fool=nil)
    @foo = foo
    @fool = fool
  end

  def foo_valid?
    @foo > 2
  end

  def inner_setter
    @foo = -3
    validate!
  end
end

describe Validy do
  describe '#initializer' do
    context 'when valid instance' do
      let(:valid_instance) { ValidyFoo.new(4) }
      
      it 'valid? returns true' do
        expect(valid_instance.valid?).to eq true
      end

      it 'errors returns {}' do
        expect(valid_instance.errors).to eq({})
      end
    end

    context 'when invalid instance' do
      let(:invalid_instance) { ValidyFoo.new(1) }
      
      it 'valid? returns false' do
        expect(invalid_instance.valid?).to eq false
      end

      it 'errors returns {}' do
        expect(invalid_instance.errors).to eq({:foo=>"No way, it is a rick!"})
      end
    end
  end
  
  describe '#setters' do
    let(:instance) { ValidyFoo.new(1, 8) }
    
    context 'when set valid value over the setter' do
      before { instance.foo = 5 }
      
      it 'valid? returns true' do
        expect(instance.valid?).to eq true
      end

      it 'errors returns {}' do
        expect(instance.errors).to eq({})
      end
    end

    context 'when set invalid value over the setter' do
      before { instance.foo = 0 }

      it 'valid? returns false' do
        expect(instance.valid?).to eq false
      end

      it 'errors returns {}' do
        expect(instance.errors).to eq({:foo=>"No way, it is a rick!"})
      end
    end
    
    context 'when no setter defined' do
      it 'will not create a setter under the hood' do
        expect{ instance.fool }.to raise_error
      end
    end
  end

  describe '#inner_setter' do
    let(:instance) { ValidyFoo.new(5) }
    
    context 'when set class variable via method' do
      it 'valid? returns false' do
        instance.inner_setter
        expect(instance.valid?).to eq false
      end

      it 'errors returns {}' do
        instance.inner_setter
        expect(instance.errors).to eq({:foo=>"No way, it is a rick!"})
      end
    end
  end
end
