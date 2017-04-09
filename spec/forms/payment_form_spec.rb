require 'rails_helper'

RSpec.describe PaymentForm, type: :model do
  context 'validation' do
    subject { PaymentForm.from_model(build(:payment)) }

    %i(name_on_card card_number cvv).each do |attribute_name|
      it { should validate_presence_of(attribute_name) }
    end

    it { should validate_length_of(:name_on_card).is_at_most(50) }
    it { should validate_length_of(:cvv).is_at_least(3).is_at_most(4) }
  end
end
