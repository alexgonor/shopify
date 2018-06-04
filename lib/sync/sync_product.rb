module Sync
  class SyncProduct
    attr :shop, :products_ids, :shopify_product_ids

    def initialize(shop)
      @shop = shop
      @shopify_product_ids = []
    end

    def sync
      activate_session
      update_products
      clear_session
    end

    def update_products
      @products_ids = product_shopify_ids
      shopify_product_collection.each do |shopify_product|
        @shopify_product_ids.push shopify_product.id.to_s
        update_product(shopify_product)
      end
      destroy_old_products
    end

    def update_product(shopify_product)
      product = shop.products.find_or_initialize_by(shopify_id: shopify_product.id)
      product.title = shopify_product.title
      product.handle = shopify_product.handle
      product.save
      update_variants(product, shopify_product.variants)
    end

    def update_variants(product, shopify_variant_collection)
      Sync::SyncVariant.new(product, shopify_variant_collection).sync
    end

    def product_shopify_ids
      shop.products.map(&:shopify_id)
    end

    def shopify_product_collection
      ShopifyAPI::Product.find(:all, params: {fields: ['id', 'handle', 'title', 'variants']})
    end

    def destroy_old_products
      shop.products.where(shopify_id: old_product_ids).destroy_all
    end

    def old_product_ids
      products_ids - shopify_product_ids
    end

    def activate_session
      shop.activate_session
    end

    def clear_session
      ShopifyAPI::Base.clear_session
    end
  end
end
