def search_all_allergens(search_item)
  # LIKE is the SQL standard while ILIKE is a useful extension made by PostgreSQL.
  # use ILIKE in production and LIKE in development
  #return Allergen.where "category ILIKE ? OR substances ILIKE ?", "%#{search_item}%", "%#{search_item}%"
  return Allergen.where "category LIKE ? OR substances LIKE ?", "%#{search_item}%", "%#{search_item}%"

end