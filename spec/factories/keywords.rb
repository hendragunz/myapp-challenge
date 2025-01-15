FactoryBot.define do
  factory :keyword do
    name { FFaker::Food.ingredient }
    association :user
  end
end
