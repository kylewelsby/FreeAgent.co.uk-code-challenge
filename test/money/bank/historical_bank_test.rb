require 'test_helper'

require 'money/bank/historical_bank'

describe 'Money::Bank::HistoricalBank' do
  subject do
    Money::Bank::HistoricalBank.new
  end
  describe '.add_rate' do
    it 'assigns a rate to the rates' do
      subject.add_rate(Date.new(2018, 12, 6), :EUR, :USD, 1.1351)
      actual = subject.rates.dig('2018-12-06', 'EUR_TO_USD')
      assert_equal(1.1351, actual)
    end
  end

  describe '.get_rate' do
    it 'returns the stored value from rates' do
      subject.rates['2018-12-06'] = {
        'EUR_TO_USD' => 1.1351
      }

      actual = subject.get_rate(Date.new(2018, 12, 6), 'EUR', 'USD')
      assert_equal(1.1351, actual)
    end
  end
end
