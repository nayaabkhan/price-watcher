ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Products" do
          table_for ProductPage.all do
            column "Title" do |product_page|
              product_page.product.title
            end

            column "Site" do |product_page|
              product_page.site.name
            end

            column "In Stock?" do |product_page|
              if product_page.in_stock == true
                'Yes'
              elsif product_page.in_stock == false
                'No'
              else
                'Not Checked'
              end
            end

            column "Current Price" do |product_page|
              price = product_page.latest_price
              '₹' + price.price.to_s if price
            end
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
