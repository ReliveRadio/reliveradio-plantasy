require 'spec_helper'

describe "episodes/new" do
  before(:each) do
    assign(:episode, stub_model(Episode,
      :title => "MyString",
      :link => "MyString",
      :guid => "MyString",
      :subtitle => "MyString",
      :content => "MyText",
      :duration => 1,
      :flattr_url => "MyString",
      :tags => "MyString",
      :icon_url => "MyString",
      :audio_file_url => "MyString",
      :cached => false,
      :local_path => "MyString"
    ).as_new_record)
  end

  it "renders new episode form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", episodes_path, "post" do
      assert_select "input#episode_title[name=?]", "episode[title]"
      assert_select "input#episode_link[name=?]", "episode[link]"
      assert_select "input#episode_guid[name=?]", "episode[guid]"
      assert_select "input#episode_subtitle[name=?]", "episode[subtitle]"
      assert_select "textarea#episode_content[name=?]", "episode[content]"
      assert_select "input#episode_duration[name=?]", "episode[duration]"
      assert_select "input#episode_flattr_url[name=?]", "episode[flattr_url]"
      assert_select "input#episode_tags[name=?]", "episode[tags]"
      assert_select "input#episode_icon_url[name=?]", "episode[icon_url]"
      assert_select "input#episode_audio_file_url[name=?]", "episode[audio_file_url]"
      assert_select "input#episode_cached[name=?]", "episode[cached]"
      assert_select "input#episode_local_path[name=?]", "episode[local_path]"
    end
  end
end
