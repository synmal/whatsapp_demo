class Webhook::TwilioController < ApplicationController
  def create
    Message.create_inbound(params[:From], params[:Body], params.as_json(except: [:controller, :action]))
    head :created
  end

  def status_update
    message = Message.find_by(sid: params[:MessageSid])
    head :not_found and return unless message

    message.update!(status: params[:MessageStatus], status_response: params.as_json)
    head :ok
  rescue
    head :internal_server_error
  end

  private
  def twilio_params
    params.permit(:SmsMessageSid, :NumMedia, :SmsSid, :SmsStatus, :Body, :To, :NumSegments, :MessageSid, :AccountSid, :From, :ApiVersion, :MediaUrl0, :MediaContentType0)
  end
end
