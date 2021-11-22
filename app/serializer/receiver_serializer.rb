class ReceiverSerializer < ActiveModel::Serializer
  attributes :id, :ein, :name, :address, :city, :state, :zip_code
end
