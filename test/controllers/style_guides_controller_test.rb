require "test_helper"

class StyleGuidesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get style_guide_url
    assert_response :success
  end
end
