class ProductsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    p '------------------'
    p pure_webhook = webhook.values_at('webhook')
    p '------------------'
  end
end
