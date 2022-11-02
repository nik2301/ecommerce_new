FactoryGirl.define do
  factory :review do
    user nil
    reviewable_id 1
    reviewable_type "MyString"
    content "MyString"
  end
end
