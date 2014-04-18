require "spec_helper"

describe JinglesController do
  describe "routing" do

    it "routes to #index" do
      get("/jingles").should route_to("jingles#index")
    end

    it "routes to #new" do
      get("/jingles/new").should route_to("jingles#new")
    end

    it "routes to #show" do
      get("/jingles/1").should route_to("jingles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/jingles/1/edit").should route_to("jingles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/jingles").should route_to("jingles#create")
    end

    it "routes to #update" do
      put("/jingles/1").should route_to("jingles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/jingles/1").should route_to("jingles#destroy", :id => "1")
    end

  end
end
