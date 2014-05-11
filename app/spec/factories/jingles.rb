# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :jingle do
    title Faker::Lorem.paragraph(1)
    audio Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/audio.mp3')))
  end
end
