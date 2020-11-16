FactoryBot.define do
  factory :message do
    body { "MyText" }
    twilio_response { {} }
    recipient

    trait :inbound do
      type { 'inbound' }
    end

    trait :outbound do
      type { 'outbound' }
    end
  end
end
