require 'money'

class Money
  def exchange_to(other_currency, date = Date.today, &rounding_method)
    other_currency = Currency.wrap(other_currency)
    if currency == other_currency
      self
    else
      @bank.exchange_with(date, self, other_currency, &rounding_method)
    end
  end
end

# end of patch

require_relative '../lib/exchange_rate'

Money.locale_backend = nil

Money.default_bank = Money::Bank::EuropeanCentralBank.new
# We need to set the default_bank as the isolated bank will not work with this
# patched version.
#
# ExchangeRate.bank = Money::Bank::EuropeanCentralBank.new

ExchangeRate.bank.fetch_data

date = Date.today - 2

exchanged = Money.new(100, :GBP).exchange_to(:USD, date)

puts "The exchange of 100 GBP to USD on #{date} is #{exchanged.format}"
