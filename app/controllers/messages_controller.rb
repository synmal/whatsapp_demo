class MessagesController < ApplicationController
  def index
    if params[:number] && !params[:number].empty?
      recipient = Recipient.find_by(number: params[:number])
      render json: Message.where(recipient: recipient).order(created_at: :desc)
    else
      render json: Message.all.order(created_at: :desc)
    end
  end

  def create
    Message.create_outbound(message_params[:to], message_params[:body])
    head :created
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
    params.require(:message).permit(:to, :body, :template_name, template_params: [])
  end
end
