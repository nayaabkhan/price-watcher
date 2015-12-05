ActiveAdmin.register ProductPage do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
permit_params :product_id, :site_id, :url

index do
  selectable_column
  column "Product" do |product_page|
    link_to product_page.product.title, admin_product_path(product_page.product)
  end
  column "Site" do |product_page|
    link_to product_page.site.name, admin_site_path(product_page.site)
  end
end

end
