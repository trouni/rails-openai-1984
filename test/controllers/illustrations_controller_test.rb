require "test_helper"

class IllustrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get illustrations_create_url
    assert_response :success
  end

  test "should get show" do
    get illustrations_show_url
    assert_response :success
  end
end
