module Sync
  class Variant
    attr_accessor :product, :variants_ids, :shopify_variants_ids, :shopify_variants_collection

    def initialize(args = {})
      args.each { |k, v| send("#{k}=", v) }
      @shopify_variants_ids = []
    end

    def sync
      update_variants
    end

    def update_variants
      @variants_ids = variant_shopify_ids
      @shopify_variants_collection.each do |shopify_variant|
        shopify_variant = OpenStruct.new(shopify_variant) if variants_validation(shopify_variant)
        @shopify_variants_ids.push shopify_variant.id.to_s
        update_variant(shopify_variant)
      end
      destroy_old_variants
    end

    def variants_validation(shopify_variant)
      shopify_variant.is_a? Hash
    end

    def update_variant(shopify_variant)
      variant = product.variants.find_or_initialize_by(shopify_id: shopify_variant.id)
      variant.price = shopify_variant.price
      variant.save
    end

    def variant_shopify_ids
      product.variants.map(&:shopify_id)
    end

    def destroy_old_variants
      product.variants.where(shopify_id: old_variant_ids).destroy_all
    end

    def old_variant_ids
      variants_ids - shopify_variants_ids
    end
  end
end
