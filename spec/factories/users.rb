FactoryBot.define do
  factory :member, class: User do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
    
  factory :admin, class: User do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    admin { true }
  end
end
