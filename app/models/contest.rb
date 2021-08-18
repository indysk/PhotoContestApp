class Contest < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
end
