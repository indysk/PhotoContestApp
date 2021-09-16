class Photo < ApplicationRecord
  belongs_to :contest
  belongs_to :user
  has_many :votes, dependent: :destroy
  mount_uploader :image, ImageUploader
  DEFAULT_FILE_NAME = 'cat_S.jpg'

  #投票結果表示で使う
  attr_accessor :vote_points
  attr_accessor :vote_rank

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
