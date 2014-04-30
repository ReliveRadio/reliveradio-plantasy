# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do

  factory :episode do
    title Faker::Lorem.paragraph(1)
    link Faker::Internet.url
    pub_date Faker::Business.credit_card_expiry_date
    sequence(:guid){|n| "guid_episode_#{n}"}
    subtitle Faker::Lorem.paragraph(1)
    content Faker::Lorem.paragraph(5)
    duration Faker::Number.number(6)
    flattr_url Faker::Internet.url
    tags Faker::Lorem.paragraph(1)
    icon_url Faker::Internet.url
    audio_file_url Faker::Internet.url
    cached false
    local_path ""
    filesize Faker::Number.number(6)
    podcast
  end

  factory :episode_cached, class: Episode do
    title Faker::Lorem.paragraph(1)
    link Faker::Internet.url
    pub_date Faker::Business.credit_card_expiry_date
    sequence(:guid){|n| "guid_episode_cached_#{n}"}
    subtitle Faker::Lorem.paragraph(1)
    content Faker::Lorem.paragraph(5)
    duration Faker::Number.number(6)
    flattr_url Faker::Internet.url
    tags Faker::Lorem.paragraph(1)
    icon_url Faker::Internet.url
    audio_file_url Faker::Internet.url
    cached true
    local_path File.join(Rails.root, '/spec/fixtures/audio.mp3')
    filesize Faker::Number.number(6)
    podcast
  end
end
