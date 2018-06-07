module ShopApi
  class Base < Grape::API
    mount ShopApi::V1::Products
  end
end
