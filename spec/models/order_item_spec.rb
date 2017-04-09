require 'rails_helper'

describe OrderItem, type: :model do
  subject { build :order_item }

  context 'association' do
    it { should belong_to :product }
    it { should belong_to :order }
  end

  context 'validation' do
    it do
      should validate_numericality_of(:quantity).is_greater_than(0)
    end
  end

  it '#total_price' do
    subject.product = create :product
    subject.quantity = 2
    subject.save
    expect(subject.total_price).to eq(20)
  end

  context 'Before validation' do
    let(:coupon) {create :product, :coupon}
    let(:order_item) {create :order_item, product_id: coupon.id}

    it '#set_inactive_for_coupon' do
      order_item
      expect(coupon.reload.status).to eq('inactive')
    end
    it '#set_active_for_coupon' do
      order_item.destroy
      expect(coupon.reload.status).to eq('active')
    end
  end
end
