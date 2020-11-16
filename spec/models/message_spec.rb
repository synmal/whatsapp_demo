require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it{ should validate_presence_of(:message_type) }
    it{ should validate_presence_of(:body) }
    it{ should validate_presence_of(:recipient_id) }
    it{
      should define_enum_for(:message_type).
        with_values(
          outbound: 'outbound',
          inbound: 'inbound'
        ).
        backed_by_column_of_type(:string)
    }
  end

  describe 'associations' do
    it{ should belong_to(:recipient) }
  end

  describe 'class methods' do
    it 'should create outbound messages' do
      message = Message.create_outbound(
        'whatsapp:+6014556061',
        'Sup'
      )

      expect(message).to be_an_instance_of(Message)
    end

    it 'should create inbound messages' do
      message = Message.create_inbound(
        'whatsapp:+6014556061',
        'Sup',
        {}
      )

      expect(message).to be_an_instance_of(Message)
    end
  end
end
