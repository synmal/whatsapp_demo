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
    request_params = {
      message: {
        to: 'whatsapp:+60145586061', 
        body: 'Hi'
      }
    }
    post '/messages', params: request_params
    expect(response).to have_http_status(:created)
  end
end
