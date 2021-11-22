class CurrencyConverterRate
  API_URL = 'https://free.currconv.com/api/v7/convert'

  def initialize from_currency = 'USD', to_currency = 'GBP'
    @currency_query = [from_currency, to_currency].join('_')
  end

  def unit_rate
    response = Faraday.get API_URL, { q: @currency_query, apiKey: ENV['CURRENCY_CONVERTER_API_KEY'] , compact: :ultra }
    raise StandardError.new 'Something went wrong please check server logs for CURRENCY_CONVERTER_API' if response.status != 200

    return JSON.parse(response.body).dig(@currency_query)
  end

  private
    def unit_price
      response = Faraday.get API_URL, { q: @currency_query, apiKey: ENV['CURRENCY_CONVERTER_API_KEY'], compact: :ultra }
      raise StandardError.new 'Something went wrong please check server logs for CURRENCY_CONVERTER_API' if response.status != 200

      return JSON.parse(response.body).dig(@currency_query)
    end
end
