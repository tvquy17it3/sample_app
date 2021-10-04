class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :recent_posts, ->{order created_at: :desc}
  scope :user_post, ->(ids){where user_id: ids}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.length.max_250}
  validates :image, content_type: {
    in: Settings.format_img,
    message: :valid_image_format
  }, size: {
    less_than: Settings.less_than_5.megabytes,
    message: :less_than_5mb
  }

  def display_image
    image.variant(resize_to_limit: Settings.img.size_arr_500)
  end
end
