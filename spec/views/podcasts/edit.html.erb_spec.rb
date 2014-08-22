require 'spec_helper'

describe "podcasts/edit" do
  before(:each) do
    @podcast = assign(:podcast, stub_model(Podcast,
      :title => "MyString",
      :description => "MyText",
      :logo_url => "MyString",
      :website => "MyString",
      :feed => "MyString",
      :tags => "MyString",
      :category => "MyString"
    ))
  end

  it "renders the edit podcast form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", podcast_path(@podcast), "post" do
      assert_select "input#podcast_title[name=?]", "podcast[title]"
      assert_select "textarea#podcast_description[name=?]", "podcast[description]"
      assert_select "input#podcast_logo_url[name=?]", "podcast[logo_url]"
      assert_select "input#podcast_website[name=?]", "podcast[website]"
      assert_select "input#podcast_feed[name=?]", "podcast[feed]"
      assert_select "input#podcast_tags[name=?]", "podcast[tags]"
      assert_select "input#podcast_category[name=?]", "podcast[category]"
    end
  end
end
