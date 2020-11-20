class SendMessageWorker
  include Sidekiq::Worker

  def perform(message_id, media = nil)
    message = Message.find(message_id)
    recipient = message.recipient

    twilio_params = {
      # should be :sms, :whatsapp or :messenger
      from: Rails.application.credentials.twilio[recipient.platform.to_sym],
      to: recipient.number,
      body: message.body
    }

    if message.attachments.attached?
      media_url = Rails.application.routes.url_helpers.rails_blob_url(message.attachments.last, host: Rails.application.credentials.tunnel)
      twilio_params[:media_url] = media_url
    end

    if recipient.platform == 'sms'
      status_callback = Rails.application.routes.url_helpers.webhook_twilio_status_url(host: Rails.application.credentials.tunnel)
      twilio_params[:status_callback] = status_callback
    end

    response = TWILIO_CLIENT.messages.create(twilio_params)

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

    message.sid = response.sid
    message.twilio_response = twilio_response
    message.save!
  end
end
