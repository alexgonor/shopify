module ShopApi
  module Entities
    class Product < Grape::Entity
      expose :id
      expose :handle
      expose :title
    end
  end
end
