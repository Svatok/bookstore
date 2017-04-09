FactoryGirl.define do
  factory :characteristic do
    association :product
    association :property
  end
end
