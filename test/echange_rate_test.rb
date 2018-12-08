require 'test_helper'

require 'exchange_rate'
require 'date'

describe 'ExchangeRate' do
  # it 'has a version number' do
  #   value(::ExchangeRate::VERSION).wont_be_nil
  # end

  before :each do
    ExchangeRate.bank = Money::Bank::HistoricalBank.new
    ExchangeRate.bank.default_currency = :EUR
  end

  describe '.at' do
    it 'returns the exchange rate for the given day from "GBP" to "USD"' do
      date = Date.new(2018, 12, 6)
      ::ExchangeRate.bank.add_rate(date, :EUR, :GBP, 0.8893)
      ::ExchangeRate.bank.add_rate(date, :EUR, :USD, 1.1351)
# p ExchangeRate.bank.rates
      actual = ::ExchangeRate.at(date, :GBP, :USD)
      assert_equal(1.2763971663105815, actual)
    end
  end
end
