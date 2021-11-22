namespace :filings do
  desc 'Populate xml data to database'
  task populate_filing_xml_data: :environment do
    PopulateFilings.call
  end
end

class PopulateFilings
  FILER_DATA_URL = [
    'http://s3.amazonaws.com/irs-form-990/201132069349300318_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201612429349300846_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201921719349301032_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201641949349301259_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201521819349301247_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201831309349303578_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201823309349300127_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201401839349300020_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201522139349100402_public.xml',
    'http://s3.amazonaws.com/irs-form-990/201831359349101003_public.xml',
  ]

  def initialize(url)
    puts "Populating xml data from this url #{url}"
    response = Faraday.get url
    @hash_data = Ox.load(response.body, mode: :hash_no_attrs)
  end

  def self.call
    FILER_DATA_URL.each do |url|
      new(url).call
    end
  end

  def call
    @filer = create_filer
    create_receiver
  end

  private
    def create_receiver
      receivers_data = @hash_data.dig(:Return, :ReturnData, :IRS990ScheduleI, :RecipientTable)
      return unless receivers_data

      receivers_data.each do |receiver_data|
        receiver = Receiver.find_or_create_by(format_receiver_params(receiver_data))
        @filer.awards.create(format_award_params(receiver_data, receiver.id))
      end
    end

    def format_award_params data, receiver_id
      res = { receiver_id: receiver_id }
      res[:purpose] = data[:PurposeOfGrant] || data[:PurposeOfGrantTxt]
      res[:cash_amount] = data[:CashGrantAmt] || data[:AmountOfCashGrant]
      res
    end

    def format_receiver_params(data)
      res = {}
      res[:ein] = data.dig(:EINOfRecipient) || data.dig(:RecipientEIN)
      res[:name] = data.dig(:RecipientNameBusiness, :BusinessNameLine1) || data.dig(:RecipientBusinessName, :BusinessNameLine1Txt) || data.dig(:RecipientBusinessName, :BusinessNameLine1)
      address = data.dig(:AddressUS) || data.dig(:USAddress)
      res[:address] = address.dig(:AddressLine1) || address.dig(:AddressLine1Txt)
      res[:city] = address.dig(:City) || address.dig(:CityNm)
      res[:state] = address.dig(:State) || address.dig(:StateAbbreviationCd)
      res[:zip_code] = address.dig(:ZIPCode) || address.dig(:ZIPCd)
      res
    end

    def create_filer
      Filer.find_or_create_by(format_filer_attributes)
    end

    def format_filer_attributes
      data = @hash_data.dig(:Return, :ReturnHeader, :Filer)

       res = {}
       res[:ein] = data.dig(:EIN)
       res[:name] = data.dig(:Name, :BusinessNameLine1) || data.dig(:BusinessName, :BusinessNameLine1) || data.dig(:BusinessName, :BusinessNameLine1Txt)
       address = data.dig(:USAddress)
       res[:address] = address.dig(:AddressLine1) || address.dig(:AddressLine1Txt)
       res[:city] = address.dig(:City) || address.dig(:CityNm)
       res[:state] = address.dig(:State) || address.dig(:StateAbbreviationCd)
       res[:zip_code] = address.dig(:ZIPCode) || address.dig(:ZIPCd)
       res
    end
end
