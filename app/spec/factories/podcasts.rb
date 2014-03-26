# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :podcast do
    title Faker::Lorem.paragraph(1)
    description Faker::Lorem.paragraph(5)
    logo_url Faker::Internet.url
    website Faker::Internet.url
    feed Faker::Internet.url
    tags Faker::Lorem.paragraph(1)
    category Faker::Lorem.paragraph(1)
    author Faker::Name.name
    subtitle Faker::Lorem.paragraph(1)
    language Faker::Lorem.word
  end
end
