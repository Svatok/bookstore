Author::HABTM_Products.create!([
  {author_id: 1, product_id: 5},
  {author_id: 2, product_id: 5}
])
Product::HABTM_Authors.create!([
  {author_id: 1, product_id: 5},
  {author_id: 2, product_id: 5}
])
User.create!([
  {email: "user@user.com", encrypted_password: "$2a$11$IQ8MyY8wcAygVUMqe9t.A.UOTtzKWEdE3UNewybERRVjmkhIk3JA6", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 3, current_sign_in_at: "2017-01-22 23:14:02", last_sign_in_at: "2017-01-22 23:12:09", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", role: "none"},
  {email: "admin@admin.com", encrypted_password: "$2a$11$8ARMjeMPfcsp76DRJvAbMuNLjxVPsPzUZdq/o385uzbukv.MCPfTW", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 9, current_sign_in_at: "2017-02-12 15:09:28", last_sign_in_at: "2017-02-12 14:54:41", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", role: "admin"}
])
Author.create!([
  {first_name: "Author", last_name: "1", description: "About author 1"},
  {first_name: "Author", last_name: "2", description: "About author 2"}
])
Category.create!([
  {name: "Category1"}
])
Characteristic.create!([
  {product_id: 1, property_id: 1, value: "10\""},
  {product_id: 1, property_id: 2, value: "5\""},
  {product_id: 1, property_id: 3, value: "2\""}
])
Picture.create!([
  {image_path: "/pictures/products/SmashingBook5ResponsiveWebDesign.jpg", imageable_type: "Product", imageable_id: 5}
])
Price.create!([
  {value: 28.5, date_start: "2017-02-11", priceable_type: "Product", priceable_id: 5},
  {value: 30.0, date_start: "2017-02-12", priceable_type: "Product", priceable_id: 5}
])
Product.create!([
  {title: "Book1", description: "About book1", category_id: 1},
  {title: "Book2", description: "About book2", category_id: 1},
  {title: "Book3", description: "About book3", category_id: 1}
])
Property.create!([
  {name: "Height"},
  {name: "Width"},
  {name: "Depth"}
])
Stock.create!([
  {product_id: 5, value: 25, date_start: "2017-02-12"},
  {product_id: 5, value: 23, date_start: "2017-02-13"},
  {product_id: 4, value: 11, date_start: "2017-02-12"},
  {product_id: 4, value: 1, date_start: "2017-02-13"}
])
