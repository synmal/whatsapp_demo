FactoryBot.define do
  factory :recipient do
    number { "whatsapp:#{Faker::PhoneNumber.cell_phone_in_e164}" }
  end
end
