# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :podcast do
    sequence(:title){|n| "Title#{n}@podcast" }
    description Faker::Lorem.paragraph(5)
    logo_url Faker::Internet.url
    website Faker::Internet.url
    feed Faker::Internet.url
    author Faker::Name.name
    subtitle Faker::Lorem.paragraph(1)
    language Faker::Lorem.word
  end
end
