class AlertMailer < ApplicationMailer
  default from: 'notifications@pricealert.com'

  def price_change_email(product_page, prev_price, new_price)
    @product_page = product_page
    @prev_price = prev_price
    @new_price = new_price
    @increased = @new_price > @prev_price

    mail(to: 'khannayaab@gmail.com', subject: "Price change for #{product_page.product.title}" )
  end
end
