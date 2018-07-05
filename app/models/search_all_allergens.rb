def search_all_allergens(search_item)

  return Allergen.where "category LIKE ? OR substances LIKE ?", "%#{search_item}%", "%#{search_item}%"

end