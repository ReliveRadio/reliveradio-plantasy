require 'spec_helper'

describe PlaylistManagementController do

  login_admin	

  describe "GET 'index'" do
    it "returns http success" do
      channel_playlist = create(:channel_playlist)
      get 'index', channel_playlist: channel_playlist.id
      response.should be_success
    end
  end

end
