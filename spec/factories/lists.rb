FactoryBot.define do
  factory :list do
    title { Faker::Name.first_name }
  end
end
