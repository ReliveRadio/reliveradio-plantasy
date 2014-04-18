require 'spec_helper'

describe "jingles/index" do
  before(:each) do
    assign(:jingles, [
      stub_model(Jingle,
        :title => "Title",
        :duration => 1,
        :audio_path => "Audio Path"
      ),
      stub_model(Jingle,
        :title => "Title",
        :duration => 1,
        :audio_path => "Audio Path"
      )
    ])
  end

  it "renders a list of jingles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Audio Path".to_s, :count => 2
  end
end
