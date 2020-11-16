FactoryBot.define do
  factory :message do
    type { "" }
    body { "MyText" }
    twilio_response { "" }
    recipient { nil }
  end
end
