# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :podcast do
    title "MyString"
    description "MyText"
    logo_url "MyString"
    website "MyString"
    feed "MyString"
    tags "MyString"
    category "MyString"
  end
end
