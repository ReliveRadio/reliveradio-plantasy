# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :episode do
    title "MyString"
    link "MyString"
    pub_date "2014-03-19 15:22:41"
    guid "MyString"
    subtitle "MyString"
    content "MyText"
    duration 1
    flattr_url "MyString"
    tags "MyString"
    icon_url "MyString"
    audio_file_url "MyString"
    cached false
    local_path "MyString"
  end
end
