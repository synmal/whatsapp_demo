class Recipient < ApplicationRecord
  has_many :messages
  validates :number, presence: true, uniqueness: true

  def able_to_send_freeform_text?
    last_inbound_message = messages.inbound.last
    return false unless last_inbound_message

    last_inbound_message.created_at + 24.hours >= Time.zone.now
  end

  def platform
    case number
    when /whatsapp/
      'whatsapp'
    when /messenger/
      'messenger'
    else
      'sms'
    end
  end
end
