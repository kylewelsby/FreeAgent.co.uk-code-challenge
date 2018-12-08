require 'money'
require_relative 'money/bank/european_central_bank'
require 'logger'

# ExchangeRate is a wrapepr for Money::Bank::HistoricalBank which allows
# easy switching of data sources.
#
module ExchangeRate
  class << self
    attr_writer :logger, :bank

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = name
      end
    end

    def bank
      @bank ||= if Money.default_bank.is_a? Money::Bank::HistoricalBank
                  Money.default_bank
                else
                  logger.warn "`Money.default_bank` isn't a HistoricalBank "\
                              'and doesnt support exchange histories. '\
                              'Using an new HistoricalBank'
                  Money::Bank::HistoricalBank.new
                end
    end

    def at(date, origin_iso, destination_iso)
      bank.get_rate date, origin_iso, destination_iso
    end
  end
end
