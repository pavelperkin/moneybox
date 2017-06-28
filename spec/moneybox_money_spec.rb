require 'spec_helper'

describe Moneybox::Money do
  context 'class methods' do
    describe 'conversion_rates' do
      before do
        described_class.set_conversion_rates('EUR', { 'USD' => 1.1, 'BTC' => 0.0047 })
      end

      subject { described_class.get_conversion_rates_for('EUR') }

      it { is_expected.to be_instance_of Hash }
      it { is_expected.to eq({ 'USD' => 1.1, 'BTC' => 0.0047 }) }
    end
  end

  context 'instance methods' do
    let(:money) { described_class.new(50, 'EUR') }

    describe 'amount' do
      subject { money.amount }
      it { is_expected.to be_instance_of Float}
      it { is_expected.to eq 50.00 }
    end

    describe 'amount_cents' do
      subject { money.amount_cents }
      it { is_expected.to be_instance_of Fixnum}
      it { is_expected.to eq 5000 }
    end

    describe 'currency' do
      subject { money.currency }
      it { is_expected.to be_instance_of String}
      it { is_expected.to match 'EUR' }
    end

    describe 'inspect' do
      subject { money.inspect }
      it { is_expected.to be_instance_of String}
      it { is_expected.to match '50.0 EUR' }
    end
  end
end
