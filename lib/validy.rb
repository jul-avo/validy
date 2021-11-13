# frozen_string_literal: true

module Validy
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def valid?
      @valid == true
    end

    def errors
      @errors
    end

    def trigger(handler, args = {})
      if handler.respond_to?(:call)
        handler.call(args)
      elsif handler && respond_to?(handler)
        send(handler)
      end
    end
  end

  module ClassMethods
    def validy(attributes = {})
      define_method :validate! do
        @errors = {}
        @valid = true

        allowed_variables = (instance_variables - [:@errors, :@valid]).map{ |v| v.to_s[1..-1].to_sym }
        attributes.slice(*allowed_variables)

        attributes.each do |attr, validator_options|
          unless trigger(validator_options[:with])
            errors[attr] = validator_options[:error] || "#{attr} is invalid"
            @valid = false
          end
        end
        @valid
      end

      attributes.each do |attr, _|
        define_method("#{attr}=") do |value|
          instance_variable_set("@#{attr}", value)

          validate!
        end
      end
    end
  end
end
