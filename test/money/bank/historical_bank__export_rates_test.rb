require 'test_helper'

require 'money/bank/historical_bank'

describe 'Money::Bank::HistoricalBank' do
  subject do
    Money::Bank::HistoricalBank.new
  end

  describe 'export_rates' do
    before :each do
      subject.rates['2018-12-06'] = {
        'EUR_TO_USD' => 1.1351
      }
    end

    it 'writes output to YAML serialized string of data' do
      actual = subject.export_rates(:yaml)
      expected = YAML.dump(
        '2018-12-06' => {
          'EUR_TO_USD' => 1.1351
        }
      )
      assert_equal(expected, actual)
    end

    it 'writes output to Ruby serialized string of data' do
      actual = subject.export_rates(:ruby)
      expected = Marshal.dump(
        '2018-12-06' => {
          'EUR_TO_USD' => 1.1351
        }
      )
      assert_equal(expected, actual)
    end

    it 'raises an error for other formats' do
      assert_raises Money::Bank::UnknownRateFormat do
        subject.export_rates(:xml)
      end
    end
  end
end
