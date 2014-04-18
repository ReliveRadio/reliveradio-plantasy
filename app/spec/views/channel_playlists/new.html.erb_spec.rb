require 'spec_helper'

describe "channel_playlists/new" do
  before(:each) do
    assign(:channel_playlist, stub_model(ChannelPlaylist,
      :author => "MyString",
      :name => "MyString",
      :description => "MyText",
      :language => "MyString"
    ).as_new_record)
  end

  it "renders new channel_playlist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", channel_playlists_path, "post" do
      assert_select "input#channel_playlist_author[name=?]", "channel_playlist[author]"
      assert_select "input#channel_playlist_name[name=?]", "channel_playlist[name]"
      assert_select "textarea#channel_playlist_description[name=?]", "channel_playlist[description]"
      assert_select "input#channel_playlist_language[name=?]", "channel_playlist[language]"
    end
  end
end
