class Recipient < ApplicationRecord
  validates :number, presence: true, uniqueness: true
end
