FactoryGirl.define do
  factory :stock do
    value 1
    date_start Date.today
    association :product
  end
end
