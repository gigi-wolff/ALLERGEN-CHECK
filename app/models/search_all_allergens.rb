def search_all_allergens(search_item)

  return Allergen.where "category ILIKE ? OR substances ILIKE ?", "%#{search_item}%", "%#{search_item}%"

end