require 'test_helper'

require 'money/bank/european_central_bank'

describe 'Money::Bank::EuropeanCentralBank' do
  before :each do
    fixture = File.new(
      File.expand_path('../../fixtures/european_central_bank.xml', __dir__)
    )
    stub_request(:get, 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml')
      .to_return(
        body: fixture
      )
  end

  subject do
    Money::Bank::EuropeanCentralBank.new
  end

  describe '.fetch_data' do
    it 'returns a HTTP response and populates rates' do
      subject.fetch_data
      actual = subject.rates['2018-12-06']['EUR_TO_USD']
      assert_equal(1.1351, actual)
      actual = subject.rates['2018-12-06']['EUR_TO_EUR']
      assert_equal(1.0, actual)
    end
  end
end
