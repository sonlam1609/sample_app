class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  MICROPOST_PARAMS = [:content, :image].freeze
  scope :by_created_at, -> { order created_at: :desc }
  scope :by_user, -> ids { where user_id: ids }
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content}
  validates :image, content_type: { in: Settings.img_type,
                                    message: I18n.t("img.content") },
                                    size: { less_than: Settings.img_size.megabytes, message: I18n.t("img.size") }

  def display_image
    image.variant resize: Settings.resize_to_limit
  end
end
