class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :trackable

  default_scope -> { order(created_at: :desc) }

  has_many :contests, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :votes


  validates :name,  presence: true,
                    length: { maximum: 50, allow_blank: true }

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255, allow_blank: true },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # has_secure_password
  # validates :password,  length: { minimum: 6 },
  #                       allow_nil: true,
  #                       presence: true

  # validates :password,  length: { minimum: 6 },
  #                       allow_nil: true,
  #                       presence: true
end
