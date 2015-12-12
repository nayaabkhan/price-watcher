class PriceHistory < ActiveRecord::Base
  belongs_to :product_page

  validates :price, presence: true
  validates :product_page, presence: true
end
