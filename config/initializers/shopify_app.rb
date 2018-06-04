ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = '9b531f1a44e31b6940a4a4a6f856c415'
  config.secret = '300842df70c898aea644638ea565e193'
  config.scope = "read_orders, read_products"
  config.embedded_app = true
  config.after_authenticate_job = { job: Shopify::AfterAuthenticateJob, inline: false }
  config.session_repository = Shop
  config.webhooks = [
    {topic: 'products/create', address: 'https://user53.mocstage.com/webhooks/products_create', format: 'json'},
    {topic: 'products/update', address: 'https://user53.mocstage.com/webhooks/products_update', format: 'json'},
    {topic: 'products/delete', address: 'https://user53.mocstage.com/webhooks/products_delete', format: 'json'}
  ]
end
