FactoryGirl.define do
  factory :user do
    after(:create, &:confirm)
    email { FFaker::Internet.email }
    password 'TestPassword2017'

    trait :with_billing_address do
      after(:create) do |user|
        create(:billing_address, addressable: user)
      end
    end

    trait :with_shipping_address do
      after(:create) do |user|
        create(:shipping_address, addressable: user)
      end
    end

    trait :not_confirmed do
      after(:create) do |user|
        user.confirmed_at = nil
        user.save
      end
    end

    trait :admin do
      role 'admin'
    end

    factory :user_with_addresses, traits: [:with_billing_address, :with_shipping_address]
  end
end
