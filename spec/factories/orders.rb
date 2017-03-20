FactoryGirl.define do
  factory :order do

    trait :with_items do
      after(:create) do |order|
        create_list(:order_item, 2, order: order)
      end
    end

    trait :with_coupon do
      after(:create) do |order|
        coupon = create(:product, :coupon)
        create(:order_item, order: order, product: coupon)
      end
    end

    trait :with_shipping do
      after(:create) do |order|
        shipping = create(:product, :shipping)
        create(:order_item, order: order, product: shipping)
      end
    end

    trait :with_billing_address do
      after(:create) do |order|
        create(:billing_address, addressable: order)
      end
    end

    trait :with_shipping_address do
      after(:create) do |order|
        create(:shipping_address, addressable: order)
      end
    end

    trait :with_payment do
      after(:create) do |order|
        create(:payment, order: order)
      end
    end

    factory :order_with_payment_state, traits: [:with_items, :with_billing_address, :with_shipping_address, :with_shipping]
    factory :full_order, traits: [:with_items, :with_coupon, :with_billing_address, :with_shipping_address, :with_shipping, :with_payment]

  end
end
