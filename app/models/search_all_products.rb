def search_all_products(search_item)

  return Product.where "name ILIKE ? OR ingredients ILIKE ?", "%#{search_item}%", "%#{search_item}%"
 
end