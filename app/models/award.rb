class Award < ApplicationRecord
  belongs_to :filer
  belongs_to :receiver
end
