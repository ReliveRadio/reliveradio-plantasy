# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :playlist_entry_episode, class: PlaylistEntry do
    start_time Faker::Business.credit_card_expiry_date
    episode
    end_time {start_time + episode.duration}
    premiere false
    channel_playlist
  end

  factory :playlist_entry_jingle, class: PlaylistEntry do
    start_time Faker::Business.credit_card_expiry_date
    jingle
    end_time {start_time + jingle.duration}
    premiere false
    channel_playlist
  end
end
