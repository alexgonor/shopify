class Product < ApplicationRecord
  belongs_to :shop
  has_many :variants, dependent: :destroy
end
