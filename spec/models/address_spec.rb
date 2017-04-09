require 'rails_helper'

RSpec.describe Address, type: :model do
  subject { build :billing_address }

  context 'associations' do
    it { should belong_to :addressable }
    it { should belong_to :country }
  end
end
