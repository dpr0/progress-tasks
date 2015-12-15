FactoryGirl.define do
  sequence(:email)       { |i| "user#{i}@progress.ru" }
  sequence(:title)       { |i| "Task_title#{i}" }
  sequence(:description) { |i| "Task_description#{i}" }
end
