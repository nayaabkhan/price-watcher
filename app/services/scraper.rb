require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Scraper
  def self.fetch(product_page)
    case product_page.site.name
    when 'Amazon'
      from_amazon(product_page)
    when 'Snapdeal'
      from_snapdeal(product_page)
    end
  end

  def self.safe_open(url)
    open(
      url,
      "User-Agent" => "Ruby/#{RUBY_VERSION}",
      "From" => "khannayaab@gmail.com",
      "Referer" => "http://www.ruby-lang.org/"
    )
  end

  def self.from_amazon(product_page)
    document = Nokogiri::HTML(self.safe_open(product_page.url))

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

  def self.from_snapdeal(product_page)
    document = Nokogiri::HTML(self.safe_open(product_page.url))

    latest = product_page.latest_price
    price_tag = document.at_css('input#productPrice')
    sold_out_tag = document.at_css('input#soldOut')

    if sold_out_tag && sold_out_tag[:value] == 'true'
      product_page.in_stock = false
      product_page.save
    elsif price_tag
      price = price_tag[:value].to_i
      if !latest || latest.price != price
        PriceHistory.create({ :product_page => product_page, :price => price })

        product_page.in_stock = true
        product_page.save

        if latest
          AlertMailer.price_change_email(product_page, latest.price, price).deliver_now
        end
      end
    else
      puts 'warning: block not found or block content bad'
    end
  end
end
