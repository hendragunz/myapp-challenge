FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    first_name  { FFaker::Name.first_name }
    last_name   { FFaker::Name.last_name }
    password    { '123123123' }
    password_confirmation    { '123123123' }
  end
end
