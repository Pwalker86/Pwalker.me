require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home requires authentication" do
    get pages_home_url
    assert_redirected_to new_user_session_url
  end

  test "root routes to home and requires authentication" do
    get root_url
    assert_redirected_to new_user_session_url
  end

  test "style guide markdown is served" do
    get styleguide_markdown_url

    assert_response :success
    assert_equal "text/markdown", response.media_type
    assert_includes response.body, "# Blogging Site Style Guide"
  end
end
