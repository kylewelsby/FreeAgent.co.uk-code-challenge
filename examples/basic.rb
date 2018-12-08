require_relative '../lib/exchange_rate'

Money.locale_backend = nil

ExchangeRate.bank = Money::Bank::EuropeanCentralBank.new
ExchangeRate.bank.fetch_data
ExchangeRate.bank.export_rates(:json, './cache.json')

date = Date.today - 2
puts 'Exchange rate from GBP to USD using EuropeanCentralBank'
p ExchangeRate.at(date, :GBP, :USD)

exchanged = ExchangeRate.bank.exchange_with(
  date,
  Money.new(100, :GBP),
  :USD
)
puts "The exchange of 100 GBP to USD on #{date} is #{exchanged.format}"
