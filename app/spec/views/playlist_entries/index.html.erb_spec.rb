require 'spec_helper'

describe "playlist_entries/index" do
  before(:each) do
    assign(:playlist_entries, [
      stub_model(PlaylistEntry,
        :premiere => false
      ),
      stub_model(PlaylistEntry,
        :premiere => false
      )
    ])
  end

  it "renders a list of playlist_entries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
