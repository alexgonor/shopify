class ProductsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    Sync::Product.new(webhook: webhook, shop: shop).sync_after_webhook
  end
end
