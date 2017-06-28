module Moneybox
  class Money
    attr_reader :amount_cents, :currency
    def initialize(amount, currency)
      @amount_cents = (amount * 100).to_i
      @currency = currency
    end

    def inspect
      [amount, currency].join(' ')
    end

    def amount
      amount_cents / 100.00
    end
  end
end
