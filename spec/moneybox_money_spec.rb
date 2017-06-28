require 'spec_helper'

describe Moneybox::Money do
  shared_examples_for 'operation with undefined rate' do
    it 'Raises ArgumentError with message'do
      expect{ subject }.to raise_error(ArgumentError, /Currency rate does not exist:/)
    end
  end

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
      it { is_expected.to be_instance_of Float }
      it { is_expected.to eq 50.00 }
    end

    describe 'amount_cents' do
      subject { money.amount_cents }
      it { is_expected.to be_instance_of Fixnum }
      it { is_expected.to eq 5000 }
    end

    describe 'currency' do
      subject { money.currency }
      it { is_expected.to be_instance_of String }
      it { is_expected.to match 'EUR' }
    end

    describe 'inspect' do
      subject { money.inspect }
      it { is_expected.to be_instance_of String }
      it { is_expected.to match '50.0 EUR' }
    end

    describe 'convert_to' do
      before do
        described_class.set_conversion_rates('EUR', { 'USD' => 1.11 })
      end

      subject { money.convert_to(new_currency) }

      context 'exchange rate exists' do
        let(:new_currency) { 'USD' }
        it { is_expected.to be_instance_of described_class }
        its(:amount) { is_expected.to eq 55.50 }
        its(:currency) { is_expected.to eq 'USD' }
      end

      context 'exchange rate does not exist' do
        let(:new_currency) { 'UAH' }
        it_behaves_like 'operation with undefined rate'
      end
    end

    describe 'Sum' do
      before do
        described_class.set_conversion_rates('USD', { 'EUR' => 0.5 })
      end

      subject { money + another_money }

      context 'work with same currency' do
        let(:another_money) { described_class.new(20.41, 'EUR')}

        it { is_expected.to be_instance_of described_class }
        its(:amount) { is_expected.to eq 70.41 }
        its(:currency) { is_expected.to eq 'EUR' }
      end

      context 'exchange rate exists' do
        let(:another_money) { described_class.new(22.22, 'USD')}

        it { is_expected.to be_instance_of described_class }
        its(:amount) { is_expected.to eq 61.11 }
        its(:currency) { is_expected.to eq 'EUR' }
      end

      context 'exchange rate does not exist' do
        let(:another_money) { described_class.new(6.11, 'UAH') }
        it_behaves_like 'operation with undefined rate'
      end
    end

    describe 'Difference' do
      before do
        described_class.set_conversion_rates('USD', { 'EUR' => 0.5 })
      end

      subject { money - another_money }

      context 'work with same currency' do
        let(:another_money) { described_class.new(20.41, 'EUR')}

        it { is_expected.to be_instance_of described_class }
        its(:amount) { is_expected.to eq 29.59 }
        its(:currency) { is_expected.to eq 'EUR' }
      end

      context 'exchange rate exists' do
        let(:another_money) { described_class.new(22.22, 'USD')}

        it { is_expected.to be_instance_of described_class }
        its(:amount) { is_expected.to eq 38.89 }
        its(:currency) { is_expected.to eq 'EUR' }
      end

      context 'exchange rate does not exist' do
        let(:another_money) { described_class.new(6.11, 'UAH') }
        it_behaves_like 'operation with undefined rate'
      end
    end

    describe 'Multiply' do
      subject { money * 2 }

      it { is_expected.to be_instance_of described_class }
      its(:amount) { is_expected.to eq 100.00 }
      its(:currency) { is_expected.to eq 'EUR' }
    end

    describe 'Divide' do
      subject { money / 2 }

      it { is_expected.to be_instance_of described_class }
      its(:amount) { is_expected.to eq 25.00 }
      its(:currency) { is_expected.to eq 'EUR' }
    end

    describe 'Equal' do
      before do
        described_class.set_conversion_rates('USD', { 'EUR' => 0.5 })
      end

      subject { money == another_money }

      context 'work with same currency' do
        context 'amounts are equal' do
          let(:another_money) { described_class.new(50, 'EUR')}
          it { is_expected.to be_truthy }
        end
        context 'amounts are different' do
          let(:another_money) { described_class.new(60, 'EUR')}
          it { is_expected.to be_falsey }
        end
      end

      context 'exchange rate exists' do
        context 'amounts are equal' do
          let(:another_money) { described_class.new(100, 'USD')}
          it { is_expected.to be_truthy }
        end
        context 'amounts are different' do
          let(:another_money) { described_class.new(80, 'USD')}
          it { is_expected.to be_falsey }
        end
      end

      context 'exchange rate does not exist' do
        let(:another_money) { described_class.new(6.11, 'UAH') }
        it_behaves_like 'operation with undefined rate'
      end
    end

    describe 'Greater' do
      before do
        described_class.set_conversion_rates('USD', { 'EUR' => 0.5 })
      end

      subject { money > another_money }

      context 'work with same currency' do
        context 'argument equals' do
          let(:another_money) { described_class.new(50, 'EUR')}
          it { is_expected.to be_falsey }
        end
        context 'argument greater' do
          let(:another_money) { described_class.new(60, 'EUR')}
          it { is_expected.to be_falsey }
        end
        context 'argument less' do
          let(:another_money) { described_class.new(40, 'EUR')}
          it { is_expected.to be_truthy }
        end
      end

      context 'exchange rate exists' do
        context 'argument equals' do
          let(:another_money) { described_class.new(100, 'USD')}
          it { is_expected.to be_falsey }
        end
        context 'argument greater' do
          let(:another_money) { described_class.new(120, 'USD')}
          it { is_expected.to be_falsey }
        end
        context 'argument less' do
          let(:another_money) { described_class.new(80, 'USD')}
          it { is_expected.to be_truthy }
        end
      end

      context 'exchange rate does not exist' do
        let(:another_money) { described_class.new(6.11, 'UAH') }
        it_behaves_like 'operation with undefined rate'
      end
    end

    describe 'Less' do
      before do
        described_class.set_conversion_rates('USD', { 'EUR' => 0.5 })
      end

      subject { money < another_money }

      context 'work with same currency' do
        context 'argument equals' do
          let(:another_money) { described_class.new(50, 'EUR')}
          it { is_expected.to be_falsey }
        end
        context 'argument greater' do
          let(:another_money) { described_class.new(60, 'EUR')}
          it { is_expected.to be_truthy }
        end
        context 'argument less' do
          let(:another_money) { described_class.new(40, 'EUR')}
          it { is_expected.to be_falsey }
        end
      end

      context 'exchange rate exists' do
        context 'argument equals' do
          let(:another_money) { described_class.new(100, 'USD')}
          it { is_expected.to be_falsey }
        end
        context 'argument greater' do
          let(:another_money) { described_class.new(120, 'USD')}
          it { is_expected.to be_truthy }
        end
        context 'argument less' do
          let(:another_money) { described_class.new(80, 'USD')}
          it { is_expected.to be_falsey }
        end
      end

      context 'exchange rate does not exist' do
        let(:another_money) { described_class.new(6.11, 'UAH') }
        it_behaves_like 'operation with undefined rate'
      end
    end
  end
end
