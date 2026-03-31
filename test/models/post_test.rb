require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "is invalid without a title" do
    post = users(:one).posts.build(body: "Body copy")

    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "is invalid without body content" do
    post = users(:one).posts.build(title: "Empty body")

    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "generates a slug from the title" do
    post = users(:one).posts.create!(title: "A Fresh Start", body: "Body copy")

    assert_equal "a-fresh-start", post.slug
    assert_equal "a-fresh-start", post.to_param
  end

  test "keeps published slugs stable when the title changes" do
    post = posts(:published_post)

    post.update!(title: "A Renamed Published Post")

    assert_equal "building-with-turbo-frames", post.slug
  end

  test "regenerates draft slugs when the title changes" do
    post = posts(:draft_post)

    post.update!(title: "Refined Draft Notes")

    assert_equal "refined-draft-notes", post.slug
  end

  test "adds a suffix when a slug is already taken" do
    post = users(:one).posts.create!(title: posts(:published_post).title, body: "Another post")

    assert_equal "building-with-turbo-frames-2", post.slug
  end

  test "parses and normalizes tag list" do
    tags = Post.parse_tag_list(" Rails, hotwire, rails, , Design ")

    assert_equal [ "rails", "hotwire", "design" ], tags
  end

  test "updates tags from comma-separated list" do
    post = posts(:draft_post)

    post.update_tags_from_list("Rails, turbo,  rails, ")

    assert_equal [ "rails", "turbo" ], post.tags.order(:name).pluck(:name)
  end
end
