# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :channel_playlist do
    author Faker::Name.name
    name Faker::Lorem.paragraph(1)
    description Faker::Lorem.paragraph(5)
    language "Deutsch"
    stream_url Faker::Internet.url
    mpd_socket_path "/home/vagrant/.mpd/socket/mix"
  end
end
