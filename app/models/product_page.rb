class ProductPage < ActiveRecord::Base
  belongs_to :product
  belongs_to :site
end
