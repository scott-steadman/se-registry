require "test_helper"

class PwaControllerTest < ActionDispatch::IntegrationTest
  test "manifest returns success with correct content type" do
    get pwa_manifest_path(format: :json)
    assert_response :success
    assert_equal "application/manifest+json", response.content_type
  end

  test "manifest response contains valid JSON" do
    get pwa_manifest_path(format: :json)
    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("name")
    assert json.key?("display")
  end

  test "service_worker returns success with correct content type" do
    get pwa_service_worker_path
    assert_response :success
    assert_equal "application/javascript", response.content_type
  end

  test "service_worker response contains javascript" do
    get pwa_service_worker_path
    assert_response :success
    assert response.body.include?("self.addEventListener")
  end
end
