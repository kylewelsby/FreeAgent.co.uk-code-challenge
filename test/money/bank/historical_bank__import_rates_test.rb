require 'test_helper'

require 'money/bank/historical_bank'

describe 'Money::Bank::HistoricalBank' do
  subject do
    Money::Bank::HistoricalBank.new
  end

  describe 'import_rates' do
    it 'writes outputs a JSON serialized string of data' do
      string = JSON.generate(
        '2018-12-06' => {
          'EUR_TO_USD' => 1.1351
        }
      )
      subject.import_rates(:json, string)

      actual = subject.rates.dig('2018-12-06', 'EUR_TO_USD')
      assert_equal(1.1351, actual)
    end

    it 'writes output to Ruby serialized string of data' do
      string = Marshal.dump(
        '2018-12-06' => {
          'EUR_TO_USD' => 1.1351
        }
      )
      subject.import_rates(:ruby, string)

      actual = subject.rates.dig('2018-12-06', 'EUR_TO_USD')
      assert_equal(1.1351, actual)
    end

    it 'raises an error for other formats' do
      assert_raises Money::Bank::UnknownRateFormat do
        subject.import_rates(:xml, '<xml?>')
      end
    end
  end
end
