module Moneybox
  class Money
    attr_reader :amount_cents, :currency

    def initialize(amount, currency)
      @amount_cents = (amount * 100).to_i
      @currency = currency
    end

    def self.conversion_rates
      @@conversion_rates ||= Hash.new({})
    end

    def self.set_conversion_rates(base_currency, rates={})
      conversion_rates.merge!(base_currency => rates)
    end

    def self.get_conversion_rates_for(base_currency)
      conversion_rates[base_currency] || {}
    end

    def inspect
      [amount, currency].join(' ')
    end

    def amount
      amount_cents / 100.00
    end
  end
end
