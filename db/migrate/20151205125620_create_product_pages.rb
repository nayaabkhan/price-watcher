class CreateProductPages < ActiveRecord::Migration
  def change
    create_table :product_pages do |t|
      t.string :url
      t.references :product, index: true, foreign_key: true
      t.references :site, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
