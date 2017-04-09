require 'rails_helper'

RSpec.describe UserAddressForm, type: :model do
  let(:billing_address) { create :billing_address }

   subject do
     attributes = attributes_for(:billing_address)
     UserAddressForm.from_params(attributes)
   end

   context 'validation' do
     %i(first_name last_name address zip phone city).each do |attribute_name|
       it { should validate_presence_of(attribute_name) }
     end

     %i(country_id address_type).each do |attribute_name|
       it { should validate_presence_of(attribute_name) }
     end

     it { should validate_length_of(:zip).is_at_most(10) }

     %i(first_name last_name city).each do |attribute_name|
       it { should validate_length_of(attribute_name).is_at_most(50) }
     end

     context 'phone' do
       it { should validate_length_of(:phone).is_at_most(15) }

       it 'format' do
         subject.phone = '+380AAAAA42342'
         is_expected.not_to be_valid
       end

       it '#wrong_code' do
         country = create :country, phone_number: '+28'
         subject.country_id = country.id
         subject.phone = '+380632863823'
         is_expected.not_to be_valid
       end
     end
   end
 end
