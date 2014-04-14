require 'spec_helper'

describe "channel_playlists/show" do
  before(:each) do
    @channel_playlist = assign(:channel_playlist, stub_model(ChannelPlaylist,
      :author => "Author",
      :name => "Name",
      :description => "MyText",
      :language => "Language"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Author/)
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Language/)
  end
end
