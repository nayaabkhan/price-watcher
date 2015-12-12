class Product < ActiveRecord::Base
  has_many :product_pages, :dependent => :destroy

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
