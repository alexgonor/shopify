class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :shopify_id
      t.string :handle
      t.string :title
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
