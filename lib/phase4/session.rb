require 'json'
require 'webrick'
require 'byebug'


module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @cook = Hash.new
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cook = JSON.parse(cookie.value)
        end
      end
    end

    def [](key)
      @cook[key]
    end

    def []=(key, val)
      @cook[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cook = WEBrick::Cookie.new('_rails_lite_app', @cook.to_json)
      res.cookies << cook
    end
  end
end
