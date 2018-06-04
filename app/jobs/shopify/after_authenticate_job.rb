module Shopify
 class AfterAuthenticateJob < ActiveJob::Base
   def perform(shop_domain:)
     shop = Shop.find_by(shopify_domain: shop_domain)
     Sync::SyncProduct.new(shop).sync if shop
   end
 end
end
