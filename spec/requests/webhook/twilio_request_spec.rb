require 'rails_helper'

RSpec.describe "Webhook::Twilio", type: :request do
  it 'should be able to create inbound message' do
    post '/webhook/twilio', params: {
      Body: 'Sup',
      From: 'whatsapp:+60145586061'
    }

    expect(response).to have_http_status(:created)
  end
end
