require "test_helper"

class StatusControllerTest < ActionDispatch::IntegrationTest

  test 'index' do
    get status_url
    assert_response :success
  end

end
