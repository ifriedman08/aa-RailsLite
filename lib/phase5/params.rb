require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
      @params.merge!(parse_www_encoded_form(req.body)) if req.body
    end

    def [](key)
      keysym = key.to_sym
      keystr = key.to_s
      @params[keysym] || @params[keystr]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }


    def parse_www_encoded_form(www_encoded_form)
      array = URI::decode_www_form(www_encoded_form)
      result = {}
      array.each do |k_v_p|
        parsed_key = parse_key(k_v_p.first)
        current_hash = result
        parsed_key.each_with_index do |key, idx|
          if idx == parsed_key.length - 1
            current_hash[key] = k_v_p.last
          end
          current_hash[key] ||= {}
          current_hash = current_hash[key]
        end
      end
      result
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
