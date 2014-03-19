require 'spec_helper'

describe "podcasts/show" do
  before(:each) do
    @podcast = assign(:podcast, stub_model(Podcast,
      :title => "Title",
      :description => "MyText",
      :logo_url => "Logo Url",
      :website => "Website",
      :feed => "Feed",
      :tags => "Tags",
      :category => "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Logo Url/)
    rendered.should match(/Website/)
    rendered.should match(/Feed/)
    rendered.should match(/Tags/)
    rendered.should match(/Category/)
  end
end
