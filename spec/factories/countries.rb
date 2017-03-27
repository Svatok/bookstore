FactoryGirl.define do
  factory :country do
    name { FFaker::Address.country }
    phone_number {'+38'}
  end
end
