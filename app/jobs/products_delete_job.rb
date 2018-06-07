class ProductsDeleteJob < ApplicationJob
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    Sync::Product.new(shop: shop).destroy_product(webhook['id'])
  end
end
