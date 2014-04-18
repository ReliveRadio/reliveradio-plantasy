require 'spec_helper'

describe "Jingles" do
  describe "GET /jingles" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get jingles_path
      response.status.should be(200)
    end
  end
end
