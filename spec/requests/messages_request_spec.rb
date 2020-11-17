require 'rails_helper'

RSpec.describe "Messages", type: :request do
  it 'should list all messages by number' do
    get '/messages', params: {number: 'whatsapp:+60145586061'}
    expect(response).to have_http_status(:ok)
  end

  it 'return all messages if number if not supplied' do
    get '/messages'
    expect(response).to have_http_status(:ok)
  end

  it 'able to create outbound message' do
    message = create(:message, :real_inbound)
    request_params = {
      message: {
        to: 'whatsapp:+60145586061', 
        body: 'Hi'
      }
    }
    post '/messages', params: request_params
    expect(response).to have_http_status(:created)
  end

  it 'should able to send template message' do
    request_params = {
      message: {
        to: 'whatsapp:+0145586061',
        template_name: 'code',
        template_params: ['verification', '1234']
      }
    }

    post '/messages/send_template', params: request_params
    expect(response).to have_http_status(:created)
  end

  it 'should raise error when attempt to send message outside 24 hour window' do
    request_params = {
      message: {
        to: 'whatsapp:+60145586061', 
        body: 'Hi'
      }
    }
    post '/messages', params: request_params
    expect(response).to have_http_status(:bad_request)
  end
end
