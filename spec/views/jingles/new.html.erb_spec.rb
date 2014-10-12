require 'spec_helper'

describe "jingles/new" do
  before(:each) do
    assign(:jingle, stub_model(Jingle,
      :title => "MyString",
      :duration => 1,
      :audio_path => "MyString"
    ).as_new_record)
  end

  it "renders new jingle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", jingles_path, "post" do
      assert_select "input#jingle_title[name=?]", "jingle[title]"
      assert_select "input#jingle_duration[name=?]", "jingle[duration]"
      assert_select "input#jingle_audio_path[name=?]", "jingle[audio_path]"
    end
  end
end
