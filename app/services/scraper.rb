require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Scraper
  def self.fetch(product_page)
    case product_page.site.name
    when 'Amazon'
      result = from_amazon(product_page)
    when 'Snapdeal'
      result = from_snapdeal(product_page)
    end

    if result > 0
      latest = product_page.latest_price
      if !latest || latest.price != result
        PriceHistory.create({ :product_page => product_page, :price => result })

        product_page.in_stock = true
        product_page.save

        if latest
          AlertMailer.price_change_email(product_page, latest.price, result).deliver_now
        end
      end
    elsif result == 0
      product_page.in_stock = false
      product_page.save
    else
      raise 'Warning: block not found or block content bad'
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
    price_block = document.at_css('#olp_feature_div .a-color-price')

    if price_block && price_block.text
      return price_block.text.strip.delete('  ,').to_i
    elsif document.at_css('#outOfStock')
      return 0
    else
      return -1
    end
  end

  def self.from_snapdeal(product_page)
    document = Nokogiri::HTML(self.safe_open(product_page.url))

    price_tag = document.at_css('input#productPrice')
    sold_out_tag = document.at_css('input#soldOut')

    if sold_out_tag && sold_out_tag[:value] == 'true'
      return 0
    elsif price_tag
      return price_tag[:value].to_i
    else
      return -1
    end
  end
end
