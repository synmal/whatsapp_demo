require 'open-uri'

class MessageAttachmentWorker
  include Sidekiq::Worker

  # Will take some time due URL passed by Twilio is not a direct link to attachment
  def perform(message_id, url, content_type, count)
    message = Message.find(message_id)
    file = URI.open(url)
    message.attachments.attach(io: file, filename: "attachment_#{message.id}_#{count}", content_type: content_type)
  end
end
