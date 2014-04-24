require 'spec_helper'

describe ScheduleController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      channel_playlist = create(:channel_playlist)
      playlist_entry = create(:playlist_entry_episode, channel_playlist: channel_playlist)
      get 'show', channel_playlist: channel_playlist.id
      response.should be_success
    end
  end

end
