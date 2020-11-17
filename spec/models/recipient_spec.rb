require 'rails_helper'

RSpec.describe Recipient, type: :model do
  describe 'validations' do
    it{ should validate_presence_of(:number) }
    it{ should validate_uniqueness_of(:number) }
  end
  
  describe 'associations' do
    it{ should have_many(:messages) }
  end

  it 'should be able to send freeform text if last message is less than 24 hours' do
    message = create(:message, :inbound)
    expect(message.recipient.able_to_send_freeform_text?).to be true
  end

  it 'should not be able to send freeform text if last message is less than 24 hours' do
    message = create(:message, :inbound)
    message.update!(created_at: 2.days.ago)
    expect(message.recipient.able_to_send_freeform_text?).to be false
  end
end
