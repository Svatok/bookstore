FactoryGirl.define do
  factory :payment do
    card_number '1234123412341234'
    name_on_card 'Test User'
    mm_yy '12/22'
    cvv '122'
    association :order
  end
end
