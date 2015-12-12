class ProductPage < ActiveRecord::Base
  belongs_to :product
  belongs_to :site

  has_many :price_histories
end
