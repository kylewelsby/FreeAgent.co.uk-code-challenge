require 'money'
require 'json'
require 'yaml'
class Money
  module Bank
    # Thrown when an unknown rate format is requested.
    class UnknownRateFormat < StandardError; end

    # Class for adding in exchacing money between different currencies on given
    # days from the European Central Bank data source.
    #
    # Exchange rates are stored in memory.
    #
    # @example
    #  bank = Money::Bank::HistoricalBank.new
    #  # Set the rate
    #  bank.add_rate Date.today, :EUR, :USD, 1.1351
    #  # Get the rate
    #  bank.get_rate Date.today, :EUR, :USD
    #
    class HistoricalBank < Base
      attr_accessor :default_currency
      attr_reader :rates
      RATE_FORMATS = %i[json ruby yaml].freeze
      FORMAT_SERIALIZERS = { json: JSON, ruby: Marshal, yaml: YAML }.freeze

      def setup
        @rates = {}
        @mutex = Mutex.new
        @default_currency ||= Money.default_currency
        self
      end

      def add_rate(date, from, to, rate)
        @mutex.synchronize do
          assign_rate(date, from, to, rate)
        end
      end
      alias set_rate add_rate

      def get_rate(date, from, to)
        @mutex.synchronize do
          rate = fetch_rate(date, from, to)
          rate || calculate_rate(date, from, to)
        end
      end

      def exchange_with(date, from, to_currency, &block)
        to_currency = Money::Currency.wrap(to_currency)
        if from.currency == to_currency
          from
        else
          rate = get_rate(date, from.currency, to_currency)
          if rate
            fractional = calculate_fractional(from, to_currency)
            from.class.new(
              exchange(fractional, rate, &block), to_currency
            )
          else
            raise UnknownRate, 'No conversion rate known for' \
            "#{from.currency.iso_code} -> #{to_currency}"
          end
        end
      end

      def calculate_fractional(from, to_currency)
        BigDecimal(from.fractional.to_s) / (
          BigDecimal(from.currency.subunit_to_unit.to_s) /
          BigDecimal(to_currency.subunit_to_unit.to_s)
        )
      end

      def exchange(fractional, rate)
        ex = fractional * BigDecimal(rate.to_s)
        if block_given?
          yield ex
        elsif @rounding_method
          @rounding_method.call(ex)
        else
          ex
        end
      end

      def fetch_data
        # noop
      end

      def import_rates(format, string)
        raise Money::Bank::UnknownRateFormat unless
          RATE_FORMATS.include? format

        @mutex.synchronize do
          @rates = FORMAT_SERIALIZERS[format].load(string)
        end
      end

      def export_rates(format, file = nil)
        raise Money::Bank::UnknownRateFormat unless
          RATE_FORMATS.include? format

        @mutex.synchronize do
          string = FORMAT_SERIALIZERS[format].dump(rates)
          File.open(file, 'w').write(string) unless file.nil?
          string
        end
      end

      private

      def rate_key_for(from, to)
        [
          Money::Currency.wrap(from).iso_code,
          Money::Currency.wrap(to).iso_code
        ].join('_TO_').upcase
      end

      def assign_rate(date, from, to, rate)
        Money::Currency.find(from)
        Money::Currency.find(to)
        rates = @rates[date.to_s] ||= {}
        rates[rate_key_for(from, to)] = rate
      end

      def fetch_rate(date, from, to)
        @rates.dig(date.to_s, rate_key_for(from, to))
      end

      def calculate_rate(date, from, to)
        origin_rate      = fetch_rate(date, default_currency, from)
        destination_rate = fetch_rate(date, default_currency, to)

        (1 / origin_rate) * destination_rate if origin_rate && destination_rate
      end
    end
  end
end
