require 'spec_helper'

describe "jingles/show" do
  before(:each) do
    @jingle = assign(:jingle, stub_model(Jingle,
      :title => "Title",
      :duration => 1,
      :audio_path => "Audio Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/1/)
    rendered.should match(/Audio Path/)
  end
end
