FactoryGirl.define do
  factory :task do
    title
    description
    state 'new'
    user
  end
end
