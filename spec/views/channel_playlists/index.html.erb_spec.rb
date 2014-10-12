require 'spec_helper'

describe "channel_playlists/index" do
  before(:each) do
    assign(:channel_playlists, [
      stub_model(ChannelPlaylist,
        :author => "Author",
        :name => "Name",
        :description => "MyText",
        :language => "Language"
      ),
      stub_model(ChannelPlaylist,
        :author => "Author",
        :name => "Name",
        :description => "MyText",
        :language => "Language"
      )
    ])
  end

  it "renders a list of channel_playlists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Language".to_s, :count => 2
  end
end
