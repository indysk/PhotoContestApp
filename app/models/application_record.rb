class ApplicationRecord < ActiveRecord::Base
  before_create :set_id
  self.abstract_class = true

  private
    def set_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.alphanumeric(16)
      end
    end
end
