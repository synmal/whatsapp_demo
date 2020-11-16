class Webhook::TwilioController < ApplicationController
  def create
    Message.create_inbound(twilio_params[:From], twilio_params[:Body], twilio_params.as_json)
    render json: {message: 'Successfully created message'}, status: :created
  end

  private
  def twilio_params
    params.permit(:SmsMessageSid, :NumMedia, :SmsSid, :SmsStatus, :Body, :To, :NumSegments, :MessageSid, :AccountSid, :From, :ApiVersion)
  end
end
