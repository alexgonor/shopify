class Product < ApplicationRecord
  belongs_to :shop
  has_many :variants, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
end
