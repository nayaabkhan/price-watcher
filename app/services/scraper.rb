require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Scraper
  def self.fetch(product_page)
    document = Nokogiri::HTML(open(
      product_page.url,
      "User-Agent" => "Ruby/#{RUBY_VERSION}",
      "From" => "khannayaab@gmail.com",
      "Referer" => "http://www.ruby-lang.org/"
    ))

    latest = product_page.latest_price

    price_block = document.at_css('#olp_feature_div .a-color-price')

    # did we find the block?
    if price_block && price_block.text
      price = price_block.text.strip.delete('  ,').to_i
      if !latest || latest.price != price
        PriceHistory.create({ :product_page => product_page, :price => price })

        product_page.in_stock = true
        product_page.save

        if latest
          AlertMailer.price_change_email(product_page, latest.price, price).deliver_now
        end
      end
    elsif document.at_css('#outOfStock')
      # mark as out of stock
      product_page.in_stock = false
      product_page.save
    else
      # send a warning mail with product and page details
      puts 'warning: block not found or block content bad'
    end
  end
end
