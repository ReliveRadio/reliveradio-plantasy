require 'spec_helper'

describe DirectoryController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show_podcast'" do
    it "returns http success" do
      podcast = create(:podcast)
      get 'show_podcast', id: podcast.id
      response.should be_success
    end
  end

  describe "GET 'show_episode'" do
    it "returns http success" do
      episode = create(:episode)
      get 'show_podcast', id: episode.id
      response.should be_success
    end
  end

end
