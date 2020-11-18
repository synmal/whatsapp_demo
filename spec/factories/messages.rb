FactoryBot.define do
  factory :message do
    body { "MyText" }
    sid { "sid" }
    twilio_response { {} }
    recipient

    trait :inbound do
      message_type { 'inbound' }
    end

    trait :outbound do
      message_type { 'outbound' }
    end

    trait :real_inbound do
      message_type { 'inbound' }
      recipient factory: :recipient, number: 'whatsapp:+60145586061'
    end
  end
end
