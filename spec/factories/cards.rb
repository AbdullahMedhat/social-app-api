FactoryBot.define do
  factory :card do
    title       { Faker::Name.first_name }
    description { Faker::Lorem.paragraph }
  end
end
