require 'open-uri'

class MessageAttachmentWorker
  include Sidekiq::Worker

  def perform(message_id, url, content_type, count)
    message = Message.find(message_id)
    file = URI.open(url)
    message.attachments.attach(io: file, filename: "attachment_#{message.id}_#{count}", content_type: content_type)
  end
end
