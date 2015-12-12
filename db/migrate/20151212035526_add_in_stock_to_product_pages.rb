class AddInStockToProductPages < ActiveRecord::Migration
  def change
    add_column :product_pages, :in_stock, :boolean
  end
end
