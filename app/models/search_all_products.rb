def search_all_products(search_item)
  # LIKE is the SQL standard while ILIKE is a useful extension made by PostgreSQL.
  # use ILIKE in production and LIKE in development

  return Product.where "name ILIKE ? OR ingredients ILIKE ?", "%#{search_item}%", "%#{search_item}%"
  #return Product.where "name LIKE ? OR ingredients LIKE ?", "%#{search_item}%", "%#{search_item}%"

end