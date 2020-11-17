FactoryBot.define do
  factory :message do
    body { "MyText" }
    twilio_response { {} }
    recipient

    trait :inbound do
      message_type { 'inbound' }
    end

    trait :outbound do
      message_type { 'outbound' }
    end
  end
end
