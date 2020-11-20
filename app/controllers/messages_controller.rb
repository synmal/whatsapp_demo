class MessagesController < ApplicationController
  def index
    if params[:number] && !params[:number].empty?
      recipient = Recipient.find_by(number: params[:number])
      messages = Message.where(recipient: recipient).order(created_at: :desc).map do |message|
        message_json = message.as_json
        message_json['attachments'] = message.attachment_urls
        message_json
      end
      
      render json: messages
    else
      messages = Message.all.order(created_at: :desc).map do |message|
        message_json = message.as_json
        message_json['attachments'] = message.attachment_urls
        message_json
      end
      render json: messages
    end
  end

  def create
    Message.create_outbound(message_params[:to], message_params[:body], media: message_params[:attachments])
    head :created
  rescue ActiveRecord::RecordInvalid
    head :bad_request
  end

  def send_template
    message = Message.create_outbound_with_template(
      message_params[:to],
      message_params[:template_name].to_sym,
      template_params: message_params[:template_params]
    )

    head :created
  end

  private
  def message_params
    params.require(:message).permit(:to, :body, :template_name, template_params: [], attachments: [])
  end
end
