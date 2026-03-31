require "test_helper"

class PostTagTest < ActiveSupport::TestCase
  test "prevents duplicate tag assignments for one post" do
    duplicate = PostTag.new(post: posts(:published_post), tag: tags(:rails))

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:tag_id], "has already been taken"
  end
end
