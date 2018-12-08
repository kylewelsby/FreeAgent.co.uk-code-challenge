# FreeAgent.co.uk Code Challenge

FreeAgent code challenge completed by [Kyle Welsby](https://mekyle.com).

Here I shall write a library that satisfies the requirements defined in [CHALLENGE.pdf](./CHALLENGE.pdf).

Unfortunately I for this, I did not make many [notes](./NOTES.md) along the development of this due to time constraints.

## ⚡️ System Dependencies

This project depends on [Ruby 2.x](https://www.ruby-lang.org/en/downloads/) on your system.
See their documentation to install the latest stable version.

_At time of writing the latest stable version is Ruby 2.5.3_

## 🎲 Installation

Within this project working directory, the commands explained below

### `bundle install`

Installs the project dependencies

### `rake test`

Runs the unit tests for this project

## 🎯 Usage

This project extends the [`Money`](https://github.com/RubyMoney/money) gem that deals with base money matters.
The Money gem by default doesn't handle actual currency conversion, so this project patches that functionality with `Money::Bank::HistoricalBank`.

Here is some basic usage of how to use this project, there are some more [examples](./examples) too.

### Include the package

```ruby
# require 'exchange_rate' # this will not work, as this is not a ruby gem.
require './lib/exchange_rate'
```

### Define the history bank
```ruby
# isolated mode
ExchangeRate.bank = Money::Bank::EuropeanCentralBank.new

# alternative global mode
Money.default_bank = Money::Bank::EuropeanCentralBank.new
```

### Fetch and cache from internet
```ruby
# Fetch and save the data
ExchangeRate.bank.fetch_data # makes a HTTP call to ECB
ExchangeRate.bank.export_rates(:json, './cache.json')
```

### Get conversion rate
```ruby
ExchangeRate.at(Date.today, :GBP, :USD)
# => 1.276397...
```

### Importing and using from the cache
Make note; the data doesn't automatically get imported.  This example shows how to load the data from the cache.

```ruby
ExchangeRage.bank.import_rates(:json, File.read('./cache.json'))
ExchangeRate.at(Date.today, :GBP, :USD)
# => 1.276397...
```

### Warnings
Because this project is date dependent, the native `Money.new(100,'GBP').exchange_to('USD')` without patching the Money gem.

See [`examples/patched.rb`](./examples/patched.rb) for example of this

## 🎓 License
MIT: https://kylewelsby.mit-license.org
