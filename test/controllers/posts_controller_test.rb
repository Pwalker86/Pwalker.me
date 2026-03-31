require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published_post = posts(:published_post)
    @draft_post = posts(:draft_post)
    @other_users_draft = posts(:other_users_draft)
    @user = users(:one)
  end

  test "index shows published posts" do
    get posts_url

    assert_response :success
    assert_match @published_post.title, response.body
    assert_no_match @draft_post.title, response.body
  end

  test "show allows public access to published posts" do
    get post_url(@published_post)

    assert_response :success
    assert_match @published_post.title, response.body
  end

  test "show hides drafts from the public" do
    get post_url(@draft_post)

    assert_response :not_found
  end

  test "show hides another users draft from signed in users" do
    sign_in @user

    get post_url(@other_users_draft)

    assert_response :not_found
  end

  test "show allows owners to see their drafts" do
    sign_in @user

    get post_url(@draft_post)

    assert_response :success
    assert_match "This draft is private and visible only to you.", response.body
  end

  test "new requires authentication" do
    get new_post_url

    assert_redirected_to new_user_session_url
  end

  test "owner can create a draft post" do
    sign_in @user

    assert_difference("Post.count", 1) do
      post posts_url, params: {
        post: {
          title: "New Draft From Test",
          body: "Draft body copy",
          published: "0"
        }
      }
    end

    created_post = Post.order(:created_at).last
    assert_equal @user, created_post.user
    assert_equal "new-draft-from-test", created_post.slug
    assert_not created_post.published?
    assert_redirected_to post_url(created_post)
  end

  test "owner can publish an existing draft" do
    sign_in @user

    patch post_url(@draft_post), params: {
      post: {
        title: @draft_post.title,
        body: "Updated body",
        published: "1"
      }
    }

    assert_redirected_to post_url(@draft_post)
    assert @draft_post.reload.published?
  end

  test "non owners cannot edit another users draft" do
    sign_in @user

    get edit_post_url(@other_users_draft)

    assert_response :not_found
  end
end
