FactoryBot.define do
  factory :keyword do
    sequence(:name) { |n| "#{FFaker::Food.ingredient}-#{n}" }
    association :user
  end
end
