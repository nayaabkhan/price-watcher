class CreatePriceHistories < ActiveRecord::Migration
  def change
    create_table :price_histories do |t|
      t.integer :price
      t.references :product_page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
