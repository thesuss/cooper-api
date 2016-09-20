FactoryGirl.define do
  factory :user do
    email "my@email.com"
    password "password"
    password_confirmation "password"
  end
end
