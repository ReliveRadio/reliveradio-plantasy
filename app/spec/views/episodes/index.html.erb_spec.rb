require 'spec_helper'

describe "episodes/index" do
  before(:each) do
    assign(:episodes, [
      stub_model(Episode,
        :title => "Title",
        :link => "Link",
        :guid => "Guid",
        :subtitle => "Subtitle",
        :content => "MyText",
        :duration => 1,
        :flattr_url => "Flattr Url",
        :tags => "Tags",
        :icon_url => "Icon Url",
        :audio_file_url => "Audio File Url",
        :cached => false,
        :local_path => "Local Path"
      ),
      stub_model(Episode,
        :title => "Title",
        :link => "Link",
        :guid => "Guid",
        :subtitle => "Subtitle",
        :content => "MyText",
        :duration => 1,
        :flattr_url => "Flattr Url",
        :tags => "Tags",
        :icon_url => "Icon Url",
        :audio_file_url => "Audio File Url",
        :cached => false,
        :local_path => "Local Path"
      )
    ])
  end

  it "renders a list of episodes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    assert_select "tr>td", :text => "Guid".to_s, :count => 2
    assert_select "tr>td", :text => "Subtitle".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Flattr Url".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
    assert_select "tr>td", :text => "Icon Url".to_s, :count => 2
    assert_select "tr>td", :text => "Audio File Url".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Local Path".to_s, :count => 2
  end
end
