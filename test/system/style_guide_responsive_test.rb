require "application_system_test_case"

class StyleGuideResponsiveTest < ApplicationSystemTestCase
  test "shows phone viewport label" do
    resize_to(390, 844)

    visit style_guide_path

    assert_text "Phone layout active"
  end

  test "shows tablet viewport label" do
    resize_to(820, 1180)

    visit style_guide_path

    assert_text "Tablet layout active"
  end

  test "shows desktop viewport label" do
    resize_to(1440, 1024)

    visit style_guide_path

    assert_text "Desktop layout active"
  end

  private

  def resize_to(width, height)
    page.current_window.resize_to(width, height)
  end
end
