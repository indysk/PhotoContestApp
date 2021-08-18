class Vote < ApplicationRecord
  belongs_to :contest
  belongs_to :photo
  belongs_to :user
end
