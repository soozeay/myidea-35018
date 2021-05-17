FactoryBot.define do
  factory :category_idea do
    category_name { Faker::Lorem.characters(number: 10) }
    body          { Faker::Lorem.characters(number: 20) }
  end
end
