# frozen_string_literal: true

require 'spec_helper'

class ValidyFoo
  include Validy

  validy foo: { with: :foo_valid?, error: "No way, it is a rick!" },
           fool: { with: ->proc{ true }, error: "true is our all" }

  def initialize(foo=nil, fool=nil)
    @foo = foo
    @fool = fool
  end

  def foo_valid?
    @foo > 2
  end
end

describe Validy do
  describe '#validate!' do
    context 'when valid instance' do
      let(:valid_instance) { ValidyFoo.new(4) }
      
      it 'valid? returns true' do
        valid_instance.validate!
        expect(valid_instance.valid?).to eq true
      end

      it 'errors returns {}' do
        valid_instance.validate!
        expect(valid_instance.errors).to eq({})
      end
    end

    context 'when invalid instance' do
      let(:invalid_instance) { ValidyFoo.new(1) }
      
      it 'valid? returns false' do
        invalid_instance.validate!
        expect(invalid_instance.valid?).to eq false
      end

      it 'errors returns {}' do
        invalid_instance.validate!
        expect(invalid_instance.errors).to eq({:foo=>"No way, it is a rick!"})
      end
    end
  end
  
  describe '#setters' do
    let(:instance) { ValidyFoo.new(1) }
    
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
  end
end
