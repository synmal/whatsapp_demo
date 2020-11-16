class Recipient < ApplicationRecord
  has_many :messages
  validates :number, presence: true, uniqueness: true
end
