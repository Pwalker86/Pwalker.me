class Post < ApplicationRecord
  belongs_to :user

  has_rich_text :body

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :recent_first, -> { order(created_at: :desc) }

  before_validation :assign_slug

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :body_presence

  def to_param
    slug
  end

  def unpublished?
    !published?
  end

  private

  def assign_slug
    return if title.blank?
    return unless slug.blank? || should_regenerate_slug?

    self.slug = unique_slug_for(title)
  end

  def should_regenerate_slug?
    will_save_change_to_title? && unpublished?
  end

  def unique_slug_for(value)
    base_slug = value.to_s.parameterize.presence || "post"
    candidate = base_slug
    suffix = 2

    while self.class.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base_slug}-#{suffix}"
      suffix += 1
    end

    candidate
  end

  def body_presence
    errors.add(:body, "can't be blank") if body.blank?
  end
end
