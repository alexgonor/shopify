class Shop < ActiveRecord::Base
  has_many :products

  include ShopifyApp::SessionStorage

  def session
   @session ||= self.class.session(self.shopify_domain, self.shopify_token)
  end

  def activate_session
   ShopifyAPI::Base.activate_session(self.session)
  end

  def self.session(domain, token)
   ShopifyAPI::Session.new(domain, token)
  end
end
