require 'spec_helper'

describe "episodes/show" do
  before(:each) do
    @episode = assign(:episode, stub_model(Episode,attributes_for(:episode)
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Link/)
    rendered.should match(/Guid/)
    rendered.should match(/Subtitle/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/Flattr Url/)
    rendered.should match(/Tags/)
    rendered.should match(/Icon Url/)
    rendered.should match(/Audio File Url/)
    rendered.should match(/false/)
    rendered.should match(/Local Path/)
  end
end
