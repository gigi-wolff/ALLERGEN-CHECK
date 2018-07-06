def search_all_reactions(search_item)

  return Reaction.where "reactive_ingredient ILIKE ? OR reactive_substances ILIKE ?", "%#{search_item}%", "%#{search_item}%"

end