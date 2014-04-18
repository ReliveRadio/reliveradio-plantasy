require 'spec_helper'

describe "podcasts/index" do
  before(:each) do
    assign(:podcasts, [
      stub_model(Podcast,
        :title => "Title",
        :description => "MyText",
        :logo_url => "Logo Url",
        :website => "Website",
        :feed => "Feed",
        :tags => "Tags",
        :category => "Category"
      ),
      stub_model(Podcast,
        :title => "Title",
        :description => "MyText",
        :logo_url => "Logo Url",
        :website => "Website",
        :feed => "Feed",
        :tags => "Tags",
        :category => "Category"
      )
    ])
  end

  it "renders a list of podcasts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Logo Url".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Feed".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
