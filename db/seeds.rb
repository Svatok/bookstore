Product::HABTM_Authors.create!([
  {author_id: 1, product_id: 5},
  {author_id: 2, product_id: 5}
])
Author::HABTM_Products.create!([
  {author_id: 1, product_id: 5},
  {author_id: 2, product_id: 5}
])
User.create!([
  {email: "user1@user.com", encrypted_password: "$2a$11$Y6UIDRlzLyq27ha08wR7quvYuX9NC89Lm1HDA94qmmiiA7aWUxspa", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 10, current_sign_in_at: "2017-03-04 12:32:32", last_sign_in_at: "2017-03-04 12:31:12", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", role: nil, confirmation_token: nil, confirmed_at: "2017-02-26 11:19:56", confirmation_sent_at: nil},
  {email: "user@user.com", encrypted_password: "$2a$11$IQ8MyY8wcAygVUMqe9t.A.UOTtzKWEdE3UNewybERRVjmkhIk3JA6", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 3, current_sign_in_at: "2017-01-22 23:14:02", last_sign_in_at: "2017-01-22 23:12:09", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", role: "none", confirmation_token: nil, confirmed_at: "2017-02-26 11:19:56", confirmation_sent_at: nil},
  {email: "admin@admin.com", encrypted_password: "$2a$11$8ARMjeMPfcsp76DRJvAbMuNLjxVPsPzUZdq/o385uzbukv.MCPfTW", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 12, current_sign_in_at: "2017-02-25 23:02:12", last_sign_in_at: "2017-02-25 15:49:34", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", role: "admin", confirmation_token: nil, confirmed_at: "2017-02-26 11:19:56", confirmation_sent_at: nil}
])
Order.create!([
  {user_id: nil, total_price: 95.0, state: "cart", prev_state: nil},
  {user_id: nil, total_price: 15.0, state: "cart", prev_state: nil},
  {user_id: nil, total_price: 30.0, state: "cart", prev_state: nil},
  {user_id: nil, total_price: 25.0, state: "address", prev_state: nil},
  {user_id: 3, total_price: 30.0, state: "address", prev_state: "cart"}
])
OrderItem.create!([
  {product_id: 5, order_id: 1, unit_price: -5.0, quantity: 1},
  {product_id: 1, order_id: 1, unit_price: 5.0, quantity: 4},
  {product_id: 4, order_id: 1, unit_price: 30.0, quantity: 1},
  {product_id: 2, order_id: 1, unit_price: 25.0, quantity: 2},
  {product_id: 3, order_id: 2, unit_price: 15.0, quantity: 1},
  {product_id: 4, order_id: 3, unit_price: 30.0, quantity: 1},
  {product_id: 2, order_id: 4, unit_price: 25.0, quantity: 1},
  {product_id: 4, order_id: 5, unit_price: 30.0, quantity: 1}
])
Product.create!([
  {title: "Book1", description: "About book1", category_id: 2, product_type: "product", status: "active"},
  {title: "Book2", description: "About book2", category_id: 1, product_type: "product", status: "active"},
  {title: "Book3", description: "About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3 About book3", category_id: 1, product_type: "product", status: "active"},
  {title: "Book4", description: "About book4", category_id: 2, product_type: "product", status: "active"},
  {title: "1234567890", description: nil, category_id: nil, product_type: "coupon", status: "inactive"}
])
Review.create!([
  {user_id: nil, product_id: 4, rate: 4, status: "approved", reviewer_name: "Svatok", review_text: "Very good book!"},
  {user_id: 3, product_id: 4, rate: 5, status: "approved", reviewer_name: "11111111111S last", review_text: "Super book!"},
  {user_id: 3, product_id: 4, rate: 3, status: "approved", reviewer_name: "Svat last", review_text: "Not impressed :("}
])
Address.create!([
  {first_name: "Svat0", last_name: "Sidelnikov", address: "Laboratornaya", city: "Dnepr", zip: "49010", country_id: 1, phone: "+380684053272", address_type: "billing", addressable_id: 3, addressable_type: "User"},
  {first_name: "Svatok", last_name: "last", address: "3333333333333", city: "444444444444", zip: "555555555555", country_id: 1, phone: "6666666666666", address_type: "shipping", addressable_id: 3, addressable_type: "User"}
])
Author.create!([
  {first_name: "Author", last_name: "1", description: "About author 1"},
  {first_name: "Author", last_name: "2", description: "About author 2"}
])
Category.create!([
  {name: "Category1"},
  {name: "Category2"}
])
Characteristic.create!([
  {product_id: 4, property_id: 1, value: "1"},
  {product_id: 4, property_id: 2, value: "1"},
  {product_id: 4, property_id: 3, value: "1"},
  {product_id: 5, property_id: 1, value: "10"},
  {product_id: 5, property_id: 2, value: "5"},
  {product_id: 5, property_id: 3, value: "2"},
  {product_id: 5, property_id: 4, value: "2017"},
  {product_id: 5, property_id: 5, value: "Hardcove, glossy paper1"}
])
Country.create!([
  {name: "Ukraine", phone_number: "+38"}
])
Picture.create!([
  {image_path: "/pictures/products/SmashingBook5ResponsiveWebDesign.jpg", imageable_type: "Product", imageable_id: 5},
  {image_path: "/pictures/products/SmashingBook5ResponsiveWebDesign.jpg", imageable_type: "User", imageable_id: 3},
  {image_path: "/pictures/products/smashing-book-5-2-large.jpg", imageable_type: "Product", imageable_id: 1}
])
Price.create!([
  {value: 28.5, date_start: "2017-02-11", priceable_type: "Product", priceable_id: 4},
  {value: 30.0, date_start: "2017-02-12", priceable_type: "Product", priceable_id: 4},
  {value: 15.0, date_start: "2017-02-15", priceable_type: "Product", priceable_id: 3},
  {value: 5.0, date_start: "2017-02-13", priceable_type: "Product", priceable_id: 1},
  {value: 25.0, date_start: "2017-02-17", priceable_type: "Product", priceable_id: 2},
  {value: -5.0, date_start: "2017-02-20", priceable_type: "Product", priceable_id: 5}
])
Property.create!([
  {name: "Height"},
  {name: "Width"},
  {name: "Depth"},
  {name: "Year of publication"},
  {name: "Materials"}
])
Stock.create!([
  {product_id: 4, value: 25, date_start: "2017-02-12"},
  {product_id: 4, value: 23, date_start: "2017-02-13"},
  {product_id: 3, value: 11, date_start: "2017-02-12"},
  {product_id: 1, value: 10, date_start: "2017-02-13"},
  {product_id: 2, value: 12, date_start: "2017-02-17"},
  {product_id: 3, value: 1, date_start: "2017-02-13"}
])
