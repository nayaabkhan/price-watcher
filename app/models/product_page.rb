class ProductPage < ActiveRecord::Base
  belongs_to :product
  belongs_to :site

  has_many :price_histories, :dependent => :destroy

  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }
  validates :product, presence: true
  validates :site, presence: true

  def latest_price
    PriceHistory.where(product_page: self).order('created_at desc').take
  end

  def costliest
    PriceHistory.where(product_page: self).maximum('price')
  end

  def cheapest
    PriceHistory.where(product_page: self).minimum('price')
  end
end
