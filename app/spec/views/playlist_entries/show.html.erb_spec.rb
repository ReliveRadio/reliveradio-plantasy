require 'spec_helper'

describe "playlist_entries/show" do
  before(:each) do
    @playlist_entry = assign(:playlist_entry, stub_model(PlaylistEntry,
      :premiere => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
