require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "normalizes case and whitespace before validation" do
    tag = Tag.create!(name: "  Alpine  ")

    assert_equal "alpine", tag.name
  end

  test "enforces case-insensitive uniqueness" do
    Tag.create!(name: "turbo")
    duplicate = Tag.new(name: "TURBO")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
