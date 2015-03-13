require 'uri'

module InvalidUTF8Rejector
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if request_uri_clean?(env)
        @app.call(env)
      else
        [400, {}, [""]]
      end
    end

    private

    def request_uri_clean?(env)
      clean_utf8?(env["PATH_INFO"]) and clean_utf8?(env["QUERY_STRING"])
    end

    def clean_utf8?(str)
      return true if str.nil?
      URI.decode_www_form_component(str).force_encoding('UTF-8').valid_encoding?
    rescue ArgumentError # triggered by an invalid % encoded string.
      false
    end
  end
end
