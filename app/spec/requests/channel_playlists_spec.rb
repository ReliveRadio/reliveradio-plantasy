require 'spec_helper'

describe "ChannelPlaylists" do
  describe "GET /channel_playlists" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get channel_playlists_path
      response.status.should be(200)
    end
  end
end
