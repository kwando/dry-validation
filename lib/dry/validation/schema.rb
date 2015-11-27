require 'dry/validation/schema/definition'
require 'dry/validation/predicates'
require 'dry/validation/error'
require 'dry/validation/rule_compiler'
require 'dry/validation/compilers/ast'
require 'dry/validation/compilers/hash'

module Dry
  module Validation
    class Schema
      extend Dry::Configurable
      extend Definition

      setting :predicates, Predicates

      def self.predicates
        config.predicates
      end

      def self.error_compiler
        Compilers::Ast.new
      end

      def self.rules
        @__rules__ ||= []
      end

      attr_reader :rules

      attr_reader :error_compiler

      def initialize(error_compiler = self.class.error_compiler)
        @rules = RuleCompiler.new(self).(self.class.rules.map(&:to_ary))
        @error_compiler = error_compiler
      end

      def call(input)
        error_compiler.call(ast(input))
      end

      def [](name)
        if methods.include?(name)
          Predicate.new(name, &method(name))
        else
          self.class.predicates[name]
        end
      end

      private

      def ast(input)
        rules.each_with_object(Error::Set.new) do |rule, errors|
          result = rule.(input)
          errors << Error.new(result) if result.failure?
        end.map(&:to_ary)
      end
    end
  end
end
