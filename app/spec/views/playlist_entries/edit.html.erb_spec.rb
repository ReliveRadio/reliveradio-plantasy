require 'spec_helper'

describe "playlist_entries/edit" do
  before(:each) do
    @playlist_entry = assign(:playlist_entry, stub_model(PlaylistEntry,
      :premiere => false
    ))
  end

  it "renders the edit playlist_entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", playlist_entry_path(@playlist_entry), "post" do
      assert_select "input#playlist_entry_premiere[name=?]", "playlist_entry[premiere]"
    end
  end
end
