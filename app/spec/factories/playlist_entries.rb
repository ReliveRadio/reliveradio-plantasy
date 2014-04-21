# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :playlist_entry_episode, class: PlaylistEntry do
    start_time Faker::Business.credit_card_expiry_date
    episode
    premiere false
    channel_playlist

    before(:create) do |entry|
      entry.end_time = entry.start_time + entry.episode.duration
    end
  end

  factory :playlist_entry_jingle, class: PlaylistEntry do
    start_time Faker::Business.credit_card_expiry_date
    jingle
    premiere false
    channel_playlist

    before(:create) do |entry|
      entry.end_time = entry.start_time + entry.jingle.duration
    end
  end
end
