module Shopify
  class AfterAuthenticateJob < ApplicationJob
    def perform(shop_domain:)
      shop = Shop.find_by(shopify_domain: shop_domain)
      Sync::Product.new(shop: shop).sync_after_install if shop
    end
  end
end
