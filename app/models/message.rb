class Message < ApplicationRecord
  attr_accessor :template

  belongs_to :recipient
  validates :message_type, :body, :recipient_id, presence: true
  validate :freeform_sendable, if: Proc.new{ |message| message.outbound? && !message.template }

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
    def create_outbound(recipient_number, body, template: false)
      recipient = Recipient.find_or_create_by(number: recipient_number)

      message = new(
        message_type: :outbound,
        body: body,
        recipient: recipient,
        template: template
      )

      message.save!

      if Rails.env.production? || Rails.env.development?
        response = TWILIO_CLIENT.messages.create(
          from: Rails.application.credentials.twilio[:phone],
          to: recipient_number,
          body: body
        )

        twilio_response = {
          body: response.body,
          num_segments: response.num_segments,
          direction: response.direction,
          from: response.from,
          to: response.to,
          date_updated: response.date_updated,
          price: response.price,
          error_message: response.error_message,
          uri: response.uri,
          account_sid: response.account_sid,
          num_media: response.num_media,
          status: response.status,
          messaging_service_sid: response.messaging_service_sid,
          sid: response.sid,
          date_sent: response.date_sent,
          date_created: response.date_created,
          error_code: response.error_code,
          price_unit: response.price_unit,
          api_version: response.api_version,
          subresource_uris: response.subresource_uris
        }
      end

      message.update!(twilio_response: twilio_response)

      message
    end

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
