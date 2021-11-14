# frozen_string_literal: true

module Validy
  Error = Class.new(StandardError)
  
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.prepend(Initializer)
  end

  module InstanceMethods
    def valid?
      @valid == true
    end

    def errors
      @errors
    end
    
    private

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
      define_method :validate do
        evaluate_validy
      end

      define_method :validate! do
        evaluate_validy(validy_raise: true)
      end

      # setters
      attributes.each do |attr, _|
        next unless self.instance_methods.include?("#{attr}=".to_sym)

        define_method("#{attr}=") do |value|
          instance_variable_set("@#{attr}", value)

          @validy_options[:validy_raise] ? validate! : validate
        end
      end
      
      private
      
      define_method :init_validy do |opts = {}|
        @errors = {}
        @valid = true
        @validy_options = {}
        @validy_options.merge!(validy_raise: (opts[:validy_raise] || attributes[:validy_raise] || false))
      end

      define_method :evaluate_validy do |opts = {}|
        init_validy(opts)
        allowed_variables = (instance_variables - [:@errors, :@valid, :@validy_options]).map{ |v| v.to_s[1..-1].to_sym }
        attributes = attributes.slice(*allowed_variables)

        attributes.each do |attr, validator_options|
          unless trigger(validator_options[:with])
            errors[attr] = validator_options[:error] || "#{attr} is invalid"
            @valid = false
            raise ::Validy::Error, @errors.to_json if @validy_options[:validy_raise]

            @valid
          end
        end

        @valid
      end
    end
    
    def validy!(attributes = {})
      attributes.merge!(validy_raise: true)
      validy(attributes)
    end
  end
  
  module Initializer
    def initialize(*)
      init_validy
      super
      @validy_options[:validy_raise] ? validate! : validate
    end
  end
end
