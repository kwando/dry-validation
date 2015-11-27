module Dry
  module Validation
    module Compilers
      class Hash
        def call(ast)
          ast.each_with_object({}) { |node, errors| errors.merge!(visit(node)) }
        end

        def visit(node, *args)
          __send__(:"visit_#{node[0]}", node[1], *args)
        end

        def visit_error(error)
          visit(error)
        end

        def visit_input(input, *args)
          name, value, rules = input
          { name => rules.map { |rule| visit(rule, name, value) } }
        end

        def visit_key(rule, name, value)
          _, predicate = rule
          visit(predicate, value, name)
        end

        def visit_val(rule, name, value)
          name, predicate = rule
          visit(predicate, value, name)
        end

        def visit_predicate(predicate, value, name)
          {
            code: predicate[0],
            value: value,
            options: visit(predicate)
          }
        end

        def visit_key?(*args)
          {}
        end

        def visit_empty?(*args)
          {}
        end

        def visit_exclusion?(*args)
          { list: args[0][0] }
        end

        def visit_inclusion?(*args)
          { list: args[0][0] }
        end

        def visit_gt?(*args)
          { num: args[0][0] }
        end

        def visit_gteq?(*args)
          { num: args[0][0] }
        end

        def visit_lt?(*args)
          { num: args[0][0] }
        end

        def visit_lteq?(*args)
          { num: args[0][0] }
        end

        def visit_int?(*args)
          {}
        end

        def visit_max_size?(*args)
          { num: args[0][0] }
        end

        def visit_min_size?(*args)
          { num: args[0][0] }
        end

        def visit_eql?(*args)
          { eql_value: args[0][0] }
        end

        def visit_size?(*args)
          num = args[0][0]

          if num.is_a?(Range)
            { left: num.first, right: num.last }
          else
            { num: args[0][0] }
          end
        end

        def visit_str?(*args)
          {}
        end

        def visit_hash?(*args)
          {}
        end

        def visit_array?(*args)
          {}
        end

        def visit_format?(*args)
          {}
        end

        def visit_nil?(*args)
          {}
        end

        def visit_filled?(*args)
          {}
        end
      end
    end
  end
end
