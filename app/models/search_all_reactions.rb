def search_all_reactions(search_item)

  return Reaction.where "reactive_ingredient LIKE ? OR reactive_substances LIKE ?", "%#{search_item}%", "%#{search_item}%"

end