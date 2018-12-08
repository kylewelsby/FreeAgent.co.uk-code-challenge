require 'bigdecimal'
require 'open-uri'
require 'date'
require 'nokogiri'
require_relative 'historical_bank'
class Money
  module Bank
    # Class for adding in exchacing money between different currencies on given
    # days from the European Central Bank data source.
    #
    # Exchange rates are stored in memory.
    #
    # @example
    #  bank = Money::Bank::EuropeanCentralBank.new
    #  bank.fetch_data
    #  # Get the rate
    #  bank.get_rate :EUR, :USD
    #
    class EuropeanCentralBank < HistoricalBank
      ECB_90_DAY_URL = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.freeze
      def setup
        @default_currency = Money::Currency.new('EUR')
        super
      end

      def fetch_data
        results = handle_response(raw_response)
        apply_currencies(results)
        apply_base_currency(results)
      end

      private

      def apply_currencies(results)
        results.each do |rate|
          add_rate(
            rate.fetch(:date),
            rate.fetch(:from),
            rate.fetch(:to),
            rate.fetch(:rate)
          )
        end
      end

      def apply_base_currency(results)
        dates = results.collect do |result|
          result.fetch(:date)
        end.uniq

        dates.each do |date|
          add_rate(date, :EUR, :EUR, 1.0)
        end
      end

      def raw_response(url = ECB_90_DAY_URL)
        uri = URI.parse(url)
        uri.read
      end

      def handle_response(data)
        rows = Nokogiri::XML(data).xpath(
          'gesmes:Envelope/xmlns:Cube/xmlns:Cube//xmlns:Cube'
        )
        rows.map do |row|
          handle_response_row(row)
        end
      end

      def handle_response_row(row)
        {
          date: Date.parse(row.parent.xpath('@time').first.value),
          from: :EUR,
          to: row.attribute('currency').value.to_sym,
          rate: BigDecimal(row.attribute('rate').value)
        }
      end
    end
  end
end
