class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :authentication_keys => [:user_id]

  default_scope -> { order(created_at: :desc) }

  has_many :contests, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :votes
  # has_one_attached :image
  mount_uploader :image, UserImageUploader
  DEFAULT_FILE_NAME = 'default_user.jpg'

  # before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }

  #===nameカラム============================================================
  validates :name,  presence: true,
                    length: { maximum: 50, allow_blank: true }
  #========================================================================


  #===user_idカラム========================================================
  VALID_EMAIL_REGEX = /\A[0-9a-zA-Z\-_]+\z/
  validates :user_id, presence: true,
                    length: { maximum: 255, allow_blank: true },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  #========================================================================


  # No use email
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
