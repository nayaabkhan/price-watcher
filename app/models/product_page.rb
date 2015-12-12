class ProductPage < ActiveRecord::Base
  belongs_to :product
  belongs_to :site

  has_many :price_histories, :dependent => :destroy

  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }
  validates :product, presence: true
  validates :site, presence: true
end
