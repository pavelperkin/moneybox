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

    def convert_to(new_currency)
      return self if new_currency == currency
      rate = Money.get_conversion_rates_for(currency)[new_currency]
      if rate
        Money.new((amount_cents * rate) / 100.00, new_currency )
      else
        raise ArgumentError, "Currency rate does not exist: #{currency} to #{new_currency}"
      end
    end
  end
end
