FactoryGirl.define do
  factory :picture do
    image_path 'noimage.jpg'
    imageable factory: :product
  end
end
