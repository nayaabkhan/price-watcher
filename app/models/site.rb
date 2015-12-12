class Site < ActiveRecord::Base
  has_many :product_pages, :dependent => :destroy

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
