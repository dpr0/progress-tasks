FactoryGirl.define do
  factory :user do
    confirmed_at Time.zone.now
    email
    password '11111111'
    password_confirmation '11111111'
  end
end
