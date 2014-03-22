require 'spec_helper'

describe "playlist_entries/new" do
  before(:each) do
    assign(:playlist_entry, stub_model(PlaylistEntry,
      :premiere => false
    ).as_new_record)
  end

  it "renders new playlist_entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", playlist_entries_path, "post" do
      assert_select "input#playlist_entry_premiere[name=?]", "playlist_entry[premiere]"
    end
  end
end
