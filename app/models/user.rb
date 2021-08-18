class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  default_scope -> { order(created_at: :desc) }

  has_many :contests, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :votes
end
