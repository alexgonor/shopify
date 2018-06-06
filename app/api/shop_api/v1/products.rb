module ShopApi
  module V1
    class Products < Grape::API

      version 'v1', using: :path
      format :json
      prefix :api
      resource :products do
        desc 'Return list of products'
        get do
          products = Product.all
          p products
          present products, with: ShopApi::Entities::Product
        end

        desc 'Return a product'
        params do
          requires :id, type: String, desc: 'ID of the product'
        end
        get ':id', root: 'product' do
          product = Product.where(id: params[:id]).first
          if !product
            puts error!("product can't be found")
          else
            present product, with: ShopApi::Entities::Product
          end
        end

        desc 'Create a product'
        params do
          requires :handle, type: String
          requires :title, type: String
          requires :shop_id, type: Integer
        end
        put do
          product = Product.create({handle:params[:handle], title:params[:title], shop_id:params[:shop_id]})
          if product.save
            present product, with: ShopApi::Entities::Product
          else
            puts error!("product can't be saved")
          end
        end

        desc 'Update a product'
        params do
          requires :id, type: String
          requires :handle, type: String
          requires :title, type: String
        end
        post ':id' do
          product = Product.find_by(id: params[:id])
          if product
            product.update({handle:params[:handle], title:params[:title]})
            if product.update({handle:params[:handle], title:params[:title]})
              present product, with: ShopApi::Entities::Product
            else
              puts error!("product was not updated")
            end
          else
            puts error!("product can't be found")
          end
        end

        desc 'Delete a product'
        params do
          requires :id, type: String
        end
        delete ':id' do
          product = Product.find_by(id: params[:id])
          if product
            product.destroy
          else
            puts error!("product can't be found")
          end
          present product, with: ShopApi::Entities::Product
        end
      end
    end
  end
end
