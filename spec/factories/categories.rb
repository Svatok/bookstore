FactoryGirl.define do
  factory :category do
    name { FFaker::Book.genre }
  end
end