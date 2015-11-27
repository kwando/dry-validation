require 'dry/validation/compilers/ast'

RSpec.describe Dry::Validation::Compilers::Ast do
  let(:klass) { Dry::Validation::Compilers::Ast }
  subject(:error_compiler) { klass.new }

  describe '#call' do
    let(:ast) do
      [
        [:error, [:input, [:name, nil, [[:key, [:name, [:predicate, [:key?, []]]]]]]]],
        [:error, [:input, [:age, 18, [[:val, [:age, [:predicate, [:gt?, [18]]]]]]]]],
        [:error, [:input, [:email, "", [[:val, [:email, [:predicate, [:filled?, []]]]]]]]],
        [:error, [:input, [:address, "", [[:val, [:address, [:predicate, [:filled?, []]]]]]]]]
      ]
    end

    it 'is the identity function' do
      expect(error_compiler.(ast)).to eql(ast)
    end
  end
end
