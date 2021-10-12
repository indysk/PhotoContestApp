class Photo < ApplicationRecord
  belongs_to :contest
  belongs_to :user
  has_many :votes, dependent: :destroy
  mount_uploader :image, ImageUploader
  DEFAULT_FILE_NAME = 'cat_S.jpg'

  #投票結果表示で使う
  attr_accessor :vote_points
  attr_accessor :vote_rank

  scope :public_all, -> (time = Time.current){ left_joins(:contest).after_vote.where('`contests`.`visible_range_show` <= 0 OR `contests`.`visible_range_result` <= 0') }
  scope :after_vote, -> (time = Time.current){ left_joins(:contest).where('`contests`.`vote_end_at` <= ?', time) }

  # #===nameカラム===========================================================
  before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }
  validates :name,  presence: true,
                    length: { maximum: 255, allow_blank: true }
  # #========================================================================
  # #===descriptionカラム====================================================
  before_save { self.description = '' if self.description.nil? }
  validates :description, presence: false,
                          length: { maximum: 10000 }
  # #========================================================================
  # #===camera, lens, iso, aperture, shutter_speedカラム=====================
  with_options presence: true, length: {maximum: 255} do
    validates :camera
    validates :lens
    validates :iso
    validates :aperture
    validates :shutter_speed
  end
  # #========================================================================
  # #===descriptionカラム====================================================
  validates :image, presence: true
  # #========================================================================


  def excerpt_name(i = 15)
    name = self.name
    name.length > i ? name[0..i-1] + '...' : name
  end

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
