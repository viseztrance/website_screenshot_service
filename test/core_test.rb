require 'core'
require 'test/unit'
require 'rack/test'

set :environment, :test

class CoreTest < Test::Unit::TestCase
  
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_should_require_a_key
    get '/'
    assert_equal 'Invalid key', last_response.body
  end

  def test_should_receive_not_found_reponse_with_a_non_existent_url
    get '/?key=somerandomtestkey&url=http://example4902.org'
    assert_equal 'Location could not be opened', last_response.body
  end

  def test_request_should_receive_a_valid_image
    get '/?key=somerandomtestkey&url=http://github.com'
    assert_equal 'image/png', last_response.headers['Content-Type']
  end

end
