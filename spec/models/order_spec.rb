require 'rails_helper'

describe Order, type: :model do
  subject { create :full_order }

  context 'associations' do
    it { should belong_to :user }
    it { should have_many :order_items }
    it { should have_many :addresses }
    it { should have_many :payments }
  end

  context 'aasm state' do
    it 'cart, confirm -> address' do
      expect(subject).to transition_from(:cart, :confirm).to(:address)
        .on_event(:address_step)
    end
    it 'address, confirm -> delivery' do
      expect(subject).to transition_from(:address, :confirm).to(:delivery)
        .on_event(:delivery_step)
    end
    it 'delivery, confirm -> payment' do
      expect(subject).to transition_from(:delivery, :confirm).to(:payment)
        .on_event(:payment_step)
    end
    it 'address, delivery, payment -> confirm' do
      expect(subject).to transition_from(:address, :delivery, :payment).to(:confirm)
        .on_event(:confirm_step)
    end
    it 'confirm -> complete' do
      expect(subject).to transition_from(:confirm).to(:complete)
        .on_event(:complete_step)
    end
    it 'complete -> in_waiting' do
      expect(subject).to transition_from(:complete).to(:in_waiting)
        .on_event(:in_waiting_step)
    end
    it 'in_waiting -> in_progress' do
      expect(subject).to transition_from(:in_waiting).to(:in_progress)
        .on_event(:in_progress_step)
    end
    it 'in_progress -> in_delivery' do
      expect(subject).to transition_from(:in_progress).to(:in_delivery)
        .on_event(:in_delivery_step)
    end
    it 'in_delivery -> delivered' do
      expect(subject).to transition_from(:in_delivery).to(:delivered)
        .on_event(:delivered_step)
    end
    it 'all steps -> canceled' do
      expect(subject).to transition_from(:cart, :address, :delivery, :payment, :confirm, :complete,
      :in_waiting, :in_progress, :in_delivery, :delivered).to(:canceled)
        .on_event(:canceled_step)
    end
  end
end
