require 'helper'

class JsonPrettierFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::JsonPrettierFilter).configure(conf)
  end

  sub_test_case 'filter' do
    test 'check empty map' do
      config = %[
        @type json_prettier
        keys_map {}
      ]
      d = create_driver(config)

      d.run(default_tag: 'test') do
        d.feed({'foo' => 'bar'})
      end
      filtered = d.filtered
      assert_equal 1, filtered.length
      assert_equal 1, filtered[0][1].length
      assert_equal 'bar', filtered[0][1]['foo']
      assert_false filtered[0][1].key?('foo_json')
    end

    test 'check single map' do
      config = %[
        @type json_prettier
        keys_map {"foo": "foo_json"}
      ]
      d = create_driver(config)

      d.run(default_tag: 'test') do
        d.feed({'foo' => 'bar', 'fooo' => 'baar'})
      end
      filtered = d.filtered
      assert_equal 1, filtered.length
      assert_equal 3, filtered[0][1].length
      assert_equal 'bar', filtered[0][1]['foo']
      assert_equal '"bar"', filtered[0][1]['foo_json']
      assert_equal 'baar', filtered[0][1]['fooo']
    end

    test 'check multi map' do
      config = %[
        @type json_prettier
        keys_map {"foo": "foo_json", "fooo": "pretty_fooo"}
      ]
      d = create_driver(config)

      d.run(default_tag: 'test') do
        d.feed({'foo' => 'bar', 'fooo' => 'baar'})
      end
      filtered = d.filtered
      assert_equal 1, filtered.length
      assert_equal 4, filtered[0][1].length
      assert_equal 'bar', filtered[0][1]['foo']
      assert_equal '"bar"', filtered[0][1]['foo_json']
      assert_equal 'baar', filtered[0][1]['fooo']
      assert_equal '"baar"', filtered[0][1]['pretty_fooo']
    end

    test 'check complex hash' do
      config = %[
        @type json_prettier
        keys_map {"foo": "foo_json"}
      ]
      d = create_driver(config)

      d.run(default_tag: 'test') do
        d.feed({'foo' => {
            'message' => 'sample message',
            'multibyte' => 'マルチバイト文字列',
            'nested' => [0, 'nested', 'array'],
        }})
      end
      filtered = d.filtered
      assert_equal 2, filtered[0][1].length
      assert_equal({
        'message' => 'sample message',
        'multibyte' => 'マルチバイト文字列',
        'nested' => [0, 'nested', 'array'],
      }, filtered[0][1]['foo'])
      jsonized_text = "{\n" +
          "  \"message\": \"sample message\",\n" +
          "  \"multibyte\": \"マルチバイト文字列\",\n" +
          "  \"nested\": [\n" +
          "    0,\n" +
          "    \"nested\",\n" +
          "    \"array\"\n" +
          "  ]\n" +
          "}"
      assert_equal(jsonized_text, filtered[0][1]['foo_json'])
    end
  end
end
