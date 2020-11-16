require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it{ should validate_presence_of(:type) }
    it{ should validate_presence_of(:body) }
    it{ should validate_presence_of(:twilio_response) }
    it{ should validate_presence_of(:recipient_id) }
  end

  describe 'associations' do
    it{ should belong_to(:recipient) }
  end
end
