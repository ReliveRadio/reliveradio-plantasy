require "spec_helper"

describe PlaylistEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/playlist_entries").should route_to("playlist_entries#index")
    end

    it "routes to #new" do
      get("/playlist_entries/new").should route_to("playlist_entries#new")
    end

    it "routes to #show" do
      get("/playlist_entries/1").should route_to("playlist_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/playlist_entries/1/edit").should route_to("playlist_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/playlist_entries").should route_to("playlist_entries#create")
    end

    it "routes to #update" do
      put("/playlist_entries/1").should route_to("playlist_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/playlist_entries/1").should route_to("playlist_entries#destroy", :id => "1")
    end

  end
end
