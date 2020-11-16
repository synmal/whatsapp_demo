if Rails.env.production? || Rails.env.development?
  TWILIO_CLIENT = Twilio::REST::Client.new(
    Rails.application.credentials.twilio[:account_sid],
    Rails.application.credentials.twilio[:auth_token]
  )
end