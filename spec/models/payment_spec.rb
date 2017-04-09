require 'rails_helper'

describe Order, type: :model do
  subject { build :payment }

  context 'association' do
    it { should belong_to :order }
  end
end
