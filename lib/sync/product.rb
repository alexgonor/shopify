module Sync
  class Product
    attr_accessor :shop, :products_ids, :shopify_product_ids, :webhook

    LIMIT = 3
    FIELDS = ['id', 'handle', 'title', 'variants']

    def initialize(args = {})
      args.each { |k, v| send("#{k}=", v) }
      @shopify_product_ids = []
    end

    def sync_after_install
      activate_session
      update_products
      clear_session
    end

    def sync_after_webhook
      @webhook = OpenStruct.new(webhook)
      update_product(webhook)
    end

    def update_products
      @products_ids = product_shopify_ids
      (ShopifyAPI::Product.count/LIMIT+1).times do |i|
        page = i + 1
        shopify_product_collection(page).each do |shopify_product|
          @shopify_product_ids.push shopify_product.id.to_s
          update_product(shopify_product)
        end
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
      Sync::Variant.new(product: product, shopify_variants_collection: shopify_variant_collection).sync
    end

    def product_shopify_ids
      shop.products.map(&:shopify_id)
    end

    def shopify_product_collection(page)
      ShopifyAPI::Product.find(:all, params: { page: page, limit: LIMIT, fields: FIELDS })
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

    def destroy_product(shopify_id)
      product = shop.products.find_by(shopify_id: shopify_id)
      product.destroy if product
    end
  end
end
