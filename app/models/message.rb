class Message < ApplicationRecord
  belongs_to :recipient
  validates :message_type, :body, :recipient_id, presence: true

  enum message_type: {
    outbound: 'outbound',
    inbound: 'inbound'
  }

  class << self
    def create_outbound(recipient_number, body, twilio_response)
      recipient = Recipient.find_or_create_by(number: recipient_number)

      self.create!(
        message_type: :outbound,
        body: body,
        recipient: recipient,
        twilio_response: twilio_response
      )
    end

    def create_inbound(recipient_number, body, twilio_response)
      recipient = Recipient.find_or_create_by(number: recipient_number)

      self.create!(
        message_type: :inbound,
        body: body,
        recipient: recipient,
        twilio_response: twilio_response
      )
    end
  end
end
