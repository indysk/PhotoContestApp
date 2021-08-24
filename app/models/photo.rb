class Photo < ApplicationRecord
  belongs_to :contest
  belongs_to :user
  has_many :votes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  has_one_attached :image
  before_create :attach_default_image




  def attach_default_image
    if !self.image.attached?
      self.image.attach(io: File.open('app/assets/images/cat_S.jpg'), filename: 'cat_S.jpg', content_type: 'image/jpeg')
    end
  end
end
