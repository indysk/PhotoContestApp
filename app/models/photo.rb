class Photo < ApplicationRecord
  belongs_to :contest
  belongs_to :user
  has_many :votes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  has_one_attached :image
  before_create :attach_default_image

  # #===nameカラム============================================================
  before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }
  validates :name,  presence: true,
                    length: { maximum: 255, allow_blank: true }
  # #========================================================================

  def attach_default_image
    if !self.image.attached?
      self.image.attach(io: File.open('app/assets/images/cat_S.jpg'), filename: 'cat_S.jpg', content_type: 'image/jpeg')
    end
  end

  def self.model_labels
    {
      image: '写真',
      name: '作品名',
      description: '作品の説明',
      photographer: '撮影者',
      camera: 'カメラ',
      lens: 'レンズ',
      iso: 'ISO',
      aperture: 'F値',
      shutter_speed: 'シャッター速度',
    }
  end
end
