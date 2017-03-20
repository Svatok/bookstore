FactoryGirl.define do
  factory :price do
    value 10.0
    date_start Date.today
    priceable factory: :product
  end
end
