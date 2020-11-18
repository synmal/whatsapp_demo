class Message < ApplicationRecord
  attr_accessor :template

  belongs_to :recipient
  validates :message_type, :recipient_id, presence: true
  validate :freeform_sendable, on: :create, if: Proc.new{ |message| message.outbound? && !message.template && message.recipient.platform != 'sms' }

  enum message_type: {
    outbound: 'outbound',
    inbound: 'inbound'
  }

  # Sandbox templates
  TEMPLATES = {
    code: 'Your {{1}} code is {{2}}',
    appointment_reminder: 'Your appointment is coming up on {{1}} at {{2}}',
    order_updates: 'Your {{1}} order of {{2}} has shipped and should be delivered on {{3}}. Details: {{4}}'
  }

  class << self
    # recipient number should be in the form of 'whatsapp:+601...'
    # body should be a string
    # The boolean template variable is to skip freeform_sendable validation
    # Media is an array of of media URL
    def create_outbound(recipient_number, body = nil, template: false, media: [])
      recipient = Recipient.find_or_create_by(number: recipient_number)

      message = new(
        message_type: :outbound,
        body: body,
        recipient: recipient,
        template: template
      )

      message.save!

      if Rails.env.production? || Rails.env.development?
        SendWhatsappMessageWorker.perform_async(message.id, body, media)
      end

      # If multiple media exists, its a good idea to send it as an individual message
      if !media.nil? && !media.empty? && !media[1..].nil? && !media[1..].empty?
        create_outbound(recipient_number, nil, media: media[1..])
      end

      message
    end

    # recipient number should be in the form of 'whatsapp:+601...'
    # template_name should be a symbol according to the TEMPLATE constant
    # template_params is an array which replaces message template variables
    def create_outbound_with_template(recipient_number, template_name, template_params: [])
      template = self::TEMPLATES[template_name]

      template_params.each_with_index do |params, index|
        template.gsub!(/\{\{#{index + 1}\}\}/, params)
      end

      create_outbound(recipient_number, template, template: true)
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
    unless recipient.able_to_send_freeform_text?
      errors.add(:base, 'Unable to send freeform message. Last inbound message is more than 24 hours.')
    end
  end
end
