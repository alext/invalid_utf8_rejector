require 'spec_helper'
require 'rack/test'

require 'invalid_utf8_rejector'

describe InvalidUTF8Rejector::Middleware do
  include Rack::Test::Methods

  def app
    InvalidUTF8Rejector::Middleware.new( proc {|env| @inner_app_called = true; [200, {}, "Inner app response for env:\n#{env.inspect}"]} )
  end

  before :each do
    @inner_app_called = false
  end

  it "should pass a valid request to the inner app" do
    get "/foo?bar=baz"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/Inner app response/)
    expect(@inner_app_called).to be_true
  end

  describe "handling invalid UTF-8 in requests" do

    it "should reject invalid UTF-8 chars in the path without calling the app" do
      get "/foo%A0bar"
      expect(last_response.status).to eq(400)
      expect(@inner_app_called).to be_false
    end

    it "should reject malformed UTF-8 chars in the path without calling the app" do
      get "/br54ba%9CAQ%C4%FD%928owse"
      expect(last_response.status).to eq(400)
      expect(@inner_app_called).to be_false
    end

    it "should reject invalid UTF-8 chars in the query_string without calling the app" do
      # Set params to nil.  Without this, it defaults to empty hash, and rack-test tries to merge this with 
      # the given params which blows up with an invalid UTF-8 error before reaching our code
      get "/foo?ba%a0r", nil
      expect(last_response.status).to eq(400)
      expect(@inner_app_called).to be_false
    end

    it "should reject malformed UTF-8 chars in the query_string without calling the app" do
      # Set params to nil.  Without this, it defaults to empty hash, and rack-test tries to merge this with 
      # the given params which blows up with an invalid UTF-8 error before reaching our code
      get "/foo?bar=br54ba%9CAQ%C4%FD%928owse", nil
      expect(last_response.status).to eq(400)
      expect(@inner_app_called).to be_false
    end
  end

  describe "handling invalid % encoded requests" do
    it "should reject invalid % encoding in the path without calling the app" do
      status, headers, body = raw_rack_get('/foo%+bar')
      expect(status).to eq(400)
      expect(@inner_app_called).to be_false
    end

    it "should reject invalid % encoding in the query_string without calling the app" do
      status, headers, body = raw_rack_get('/foo', 'bar%=baz')
      expect(status).to eq(400)
      expect(@inner_app_called).to be_false
    end
  end

  # helper to bypass rack-test which errors when attempting to parse the invalid URLs
  def raw_rack_get(path, query = nil)
    env = {
      'REQUEST_METHOD' => 'GET',
      'SCRIPT_NAME' => '',
      'PATH_INFO' => path,
      'QUERY_STRING' => query,
      'SERVER_NAME' => 'example.org',
      'SERVER_PORT' => 80,
    }
    status, headers, body = app.call(env)
  end
end
