require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "author creates a draft and publishes it later" do
    visit new_user_session_path

    fill_in "Email", with: users(:one).email
    fill_in "Password", with: "password123"
    click_button "Log in"

    click_link "Posts"
    click_link "Write a post"

    fill_in "Title", with: "Systems Thinking for Rails"
    fill_in_rich_text_area "<div><p>Draft body for a new article.</p></div>"
    fill_in "Tags", with: "rails, hotwire, rails"
    uncheck "Publish this post"
    click_button "Create Post"

    assert_text "Draft saved."
    assert_text "This draft is private and visible only to you."
    assert_text "rails"
    assert_text "hotwire"
    assert_current_path post_path(Post.order(:created_at).last)

    click_link "Edit post"
    check "Publish this post"
    click_button "Update Post"

    assert_text "Post updated."
    assert_text "Published"

    click_link "Back to posts"
    assert_text "Systems Thinking for Rails"
  end

  test "clicking a tag chip opens filtered results" do
    visit post_path(posts(:published_post))

    click_link "rails"

    assert_current_path posts_path(tag: "rails")
    assert_text "Showing results for tag"
    assert_text "Building with Turbo Frames"
  end

  private

  def fill_in_rich_text_area(html)
    page.execute_script(<<~JS, html)
      const editor = document.querySelector("trix-editor")
      editor.editor.loadHTML(arguments[0])
      editor.dispatchEvent(new Event("input", { bubbles: true }))
      editor.dispatchEvent(new Event("change", { bubbles: true }))
    JS
  end
end
