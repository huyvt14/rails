# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.post.image.variant.resize_to_limit
  end

  validates :content, presence: Settings.post.content.presence,
                      length: { maximum: Settings.post.content.length.maximum }
  validates :image, content_type: { in: Settings.post.image.content_type.in,
                                    message: Settings.post.image.content_type.message },
                    size: { less_than: Settings.post.image.size.less_than, message: Settings.post.image.size.message }

  scope :recent_posts, -> { order created_at: :desc }
  scope :relate_post, ->(user_ids) { where(user_id: user_ids) }
end
