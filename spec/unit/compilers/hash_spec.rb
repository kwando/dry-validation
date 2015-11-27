require 'dry/validation/compilers/hash'

RSpec.describe Dry::Validation::Compilers::Hash do
  let(:klass) { Dry::Validation::Compilers::Hash }
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

    it 'converts error ast into another format' do
      expect(error_compiler.(ast)).to eql(
        name: [{ code: :key?, value: nil, options: {} }],
        age: [{ code: :gt?, value: 18, options: { num: 18 } }],
        email: [{ code: :filled?, value: '', options: {} }],
        address: [{ code: :filled?, value: '', options: {} }]
      )
    end
  end

  describe '#visit_predicate' do
    describe ':empty?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:empty?, []], [], :tags)

        expect(msg).to eql(code: :empty?, value: [], options: {})
      end
    end

    describe ':exclusion?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:exclusion?, [[1, 2, 3]]], 2, :num)

        expect(msg).to eql(code: :exclusion?, value: 2, options: { list: [1, 2, 3] })
      end
    end

    describe ':inclusion?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:inclusion?, [[1, 2, 3]]], 2, :num)

        expect(msg).to eql(code: :inclusion?, value: 2, options: { list: [1, 2, 3] })
      end
    end

    describe ':gt?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:gt?, [3]], 2, :num)

        expect(msg).to eql(code: :gt?, value: 2, options: { num: 3 })
      end
    end

    describe ':gteq?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:gteq?, [3]], 2, :num)

        expect(msg).to eql(code: :gteq?, value: 2, options: { num: 3 })
      end
    end

    describe ':lt?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:lt?, [3]], 2, :num)

        expect(msg).to eql(code: :lt?, value: 2, options: { num: 3 })
      end
    end

    describe ':lteq?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:lteq?, [3]], 2, :num)

        expect(msg).to eql(code: :lteq?, value: 2, options: { num: 3 })
      end
    end

    describe ':hash?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:hash?, []], '', :address)

        expect(msg).to eql(code: :hash?, value: '', options: {})
      end
    end

    describe ':array?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:array?, []], '', :phone_numbers)

        expect(msg).to eql(code: :array?, value: '', options: {})
      end
    end

    describe ':int?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:int?, []], '2', :num)

        expect(msg).to eql(code: :int?, value: '2', options: {})
      end
    end

    describe ':max_size?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:max_size?, [3]], 'abcd', :num)

        expect(msg).to eql(code: :max_size?, value: 'abcd', options: { num: 3 })
      end
    end

    describe ':min_size?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:min_size?, [3]], 'ab', :num)

        expect(msg).to eql(code: :min_size?, value: 'ab', options: { num: 3 })
      end
    end

    describe ':nil?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:nil?, []], nil, :num)

        expect(msg).to eql(code: :nil?, value: nil, options: {})
      end
    end

    describe ':size?' do
      it 'returns valid message when arg is int' do
        msg = error_compiler.visit_predicate([:size?, [3]], 'ab', :num)

        expect(msg).to eql(code: :size?, value: 'ab', options: { num: 3 })
      end

      it 'returns valid message when arg is range' do
        msg = error_compiler.visit_predicate([:size?, [3..4]], 'ab', :num)

        expect(msg).to eql(code: :size?, value: 'ab', options: { left: 3, right: 4 })
      end
    end

    describe ':str?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:str?, []], 3, :num)

        expect(msg).to eql(code: :str?, value: 3, options: {})
      end
    end

    describe ':format?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:format?, [/^F/]], 'Bar', :str)

        expect(msg).to eql(code: :format?, value: 'Bar', options: {})
      end
    end

    describe ':eql?' do
      it 'returns valid message' do
        msg = error_compiler.visit_predicate([:eql?, ['Bar']], 'Foo', :str)

        expect(msg).to eql(code: :eql?, value: 'Foo', options: { eql_value: 'Bar' })
      end
    end
  end
end
