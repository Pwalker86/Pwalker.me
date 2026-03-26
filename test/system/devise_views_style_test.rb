require "application_system_test_case"

class DeviseViewsStyleTest < ApplicationSystemTestCase
  test "session page uses editorial auth surface" do
    visit new_user_session_path

    assert_selector "section.sg-canvas"
    assert_selector "nav[aria-label='Authentication links']"
    assert_button "Log in"
  end

  test "registration page uses editorial auth surface" do
    visit new_user_registration_path

    assert_selector "section.sg-canvas"
    assert_text "Create your account"
    assert_button "Sign up"
  end

  test "password recovery page uses editorial auth surface" do
    visit new_user_password_path

    assert_selector "section.sg-canvas"
    assert_text "Forgot your password?"
    assert_button "Send me password reset instructions"
  end
end
