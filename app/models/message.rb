class Message < ApplicationRecord
  belongs_to :recipient
  validates :type, :body, :twilio_response, :recipient_id, presence: true
end
