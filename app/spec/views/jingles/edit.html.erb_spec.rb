require 'spec_helper'

describe "jingles/edit" do
  before(:each) do
    @jingle = assign(:jingle, stub_model(Jingle,
      :title => "MyString",
      :duration => 1,
      :audio_path => "MyString"
    ))
  end

  it "renders the edit jingle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", jingle_path(@jingle), "post" do
      assert_select "input#jingle_title[name=?]", "jingle[title]"
      assert_select "input#jingle_duration[name=?]", "jingle[duration]"
      assert_select "input#jingle_audio_path[name=?]", "jingle[audio_path]"
    end
  end
end
