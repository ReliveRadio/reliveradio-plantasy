require "spec_helper"

describe PodcastsController do
  describe "routing" do

    it "routes to #index" do
      get("/podcasts").should route_to("podcasts#index")
    end

    it "routes to #new" do
      get("/podcasts/new").should route_to("podcasts#new")
    end

    it "routes to #show" do
      get("/podcasts/1").should route_to("podcasts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/podcasts/1/edit").should route_to("podcasts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/podcasts").should route_to("podcasts#create")
    end

    it "routes to #update" do
      put("/podcasts/1").should route_to("podcasts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/podcasts/1").should route_to("podcasts#destroy", :id => "1")
    end

  end
end
