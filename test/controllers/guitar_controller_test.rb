require "test_helper"

class GuitarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guitar_index_url
    assert_response :success
  end
end
