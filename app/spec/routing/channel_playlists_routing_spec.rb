require "spec_helper"

describe ChannelPlaylistsController do
  describe "routing" do

    it "routes to #index" do
      get("/channel_playlists").should route_to("channel_playlists#index")
    end

    it "routes to #new" do
      get("/channel_playlists/new").should route_to("channel_playlists#new")
    end

    it "routes to #show" do
      get("/channel_playlists/1").should route_to("channel_playlists#show", :id => "1")
    end

    it "routes to #edit" do
      get("/channel_playlists/1/edit").should route_to("channel_playlists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/channel_playlists").should route_to("channel_playlists#create")
    end

    it "routes to #update" do
      put("/channel_playlists/1").should route_to("channel_playlists#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/channel_playlists/1").should route_to("channel_playlists#destroy", :id => "1")
    end

  end
end
