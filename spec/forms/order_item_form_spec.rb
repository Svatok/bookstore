require 'rails_helper'

RSpec.describe OrderItemForm, type: :model do
  let(:order_item) { create :order_item }

   subject do
     attributes = attributes_for(:order_item)
     OrderItemForm.from_params(attributes)
   end

   %i(product_id quantity).each do |attribute_name|
     it { should validate_presence_of(attribute_name) }
   end
 end
