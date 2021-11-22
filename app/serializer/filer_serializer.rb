class FilerSerializer < ActiveModel::Serializer
  attributes :id, :ein, :name, :address, :city, :state, :zip_code

  has_many :awards
end
