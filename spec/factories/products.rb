FactoryGirl.define do
  factory :product do
    initialize_with { new.decorate }
    title { FFaker::Book.title }
    description { FFaker::Book.description }
    product_type 'product'
    status 'active'
    after(:create) do |product|
      create(:price, priceable: product)
      create(:stock, product: product)
      create(:picture, imageable: product)
      create(:characteristic, product: product, property: create(:property, name: 'Height'), value: '10')
      create(:characteristic, product: product, property: create(:property, name: 'Width'), value: '8')
      create(:characteristic, product: product, property: create(:property, name: 'Depth'), value: '2')
      create(:characteristic, product: product, property: create(:property, name: 'Year of publication'), value: '2016')
      create(:characteristic, product: product, property: create(:property, name: 'Materials'), value: 'Paper')
    end

    trait :coupon do
      title { '123456789' }
      product_type 'coupon'
      description ''
      after(:create) do |product|
        create :price, priceable: product, value: -10.0
      end
    end

    trait :shipping do
      title 'shipping'
      product_type 'shipping'
      description '3 to 5 days'
      after(:create) do |product|
        create :price, priceable: product, value: 11.0
      end
    end

    trait :with_authors do
      authors { create_list :author, 2 }
    end

    trait :with_reviews do
      reviews { create_list :review, 4, :approved }
    end

    trait :with_orders do
      after(:create) do |product|
        create(:order_item, product: product)
      end
    end

    factory :full_product, traits: [:with_authors, :with_reviews]
  end
end
