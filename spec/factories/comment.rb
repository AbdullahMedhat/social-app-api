FactoryBot.define do
  factory :comment do
    content { Faker::Name.first_name }
  end
end
