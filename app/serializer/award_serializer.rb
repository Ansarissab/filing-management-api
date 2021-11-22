class AwardSerializer < ActiveModel::Serializer
  attributes :id, :cash_amount_usd, :cash_amount_gbp, :purpose, :receiver_id

  def cash_amount_usd
    "$#{object.cash_amount}"
  end

  def cash_amount_gbp
    "£#{(object.cash_amount * AwardSerializer.unit_price_from_usd_to_gbp).round(2)}"
  end

  private
    def self.unit_price_from_usd_to_gbp
      @unit_price_from_usd_to_gbp ||= CurrencyConverterRate.new.unit_rate
    end
end
