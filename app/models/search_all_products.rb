def search_all_products(search_item)

  return Product.where "name LIKE ? OR ingredients LIKE ?", "%#{search_item}%", "%#{search_item}%"
 
end