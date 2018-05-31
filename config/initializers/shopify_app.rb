ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "9b531f1a44e31b6940a4a4a6f856c415"
  config.secret = "300842df70c898aea644638ea565e193"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
