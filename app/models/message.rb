class Message < ApplicationRecord
  belongs_to :recipient
  validates :message_type, :body, :recipient_id, presence: true
  validate :freeform_sendable, if: Proc.new{ |message| message.outbound? }

  enum message_type: {
    outbound: 'outbound',
    inbound: 'inbound'
  }

  class << self
    def create_outbound(recipient_number, body)
      recipient = Recipient.find_or_create_by(number: recipient_number)
      
      self.create!(
        message_type: :outbound,
        body: body,
        recipient: recipient,
        twilio_response: twilio_response ||= {To: recipient_number, Body: body}
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

  private
  def freeform_sendable
    # byebug
    unless recipient.able_to_send_freeform_text?
      errors.add(:base, 'Unable to send freeform message. Last inbound message is more than 24 hours.')
    end
  end
end
