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
      Message.create_inbound(
        'whatsapp:+6014556061',
        'Sup',
        {}
      )

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

  it 'should not be able to create message if never converse before or last inbound more than 24 hours' do
    expect{
      Message.create_outbound(
        'whatsapp:+6014556061',
        'Sup'
      )
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should be able to create message based on the templates' do
    # Update if added more templates or template changes
    number = 'whatsapp:+60145586061'
    message = Message.create_outbound_with_template(number, :code, template_params: ['verification', '1234'])
    expect(message.body).to eq('Your verification code is 1234')

    message = Message.create_outbound_with_template(number, :appointment_reminder, template_params: ['Tuesday', '12:30AM'])
    expect(message.body).to eq('Your appointment is coming up on Tuesday at 12:30AM')

    message = Message.create_outbound_with_template(number, :order_updates, template_params: ['3', 'stuffs', 'Monday next week', 'Shipping: ASD123456'])
    expect(message.body).to eq('Your 3 order of stuffs has shipped and should be delivered on Monday next week. Details: Shipping: ASD123456')
  end
end
