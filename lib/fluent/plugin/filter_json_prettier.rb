require 'fluent/plugin/filter'
require 'yajl'

module Fluent::Plugin
  class JsonPrettierFilter < Filter
    Fluent::Plugin.register_filter('json_prettier', self)
    config_param :keys_map, :hash, default: {}, symbolize_keys: false, value_type: :string

    def configure(conf)
      super
    end

    def filter(tag, time, record)
      @keys_map.each{|input, output|
        record[output] = Yajl.dump(record[input], :pretty => true)
      }
      record
    end
  end
end