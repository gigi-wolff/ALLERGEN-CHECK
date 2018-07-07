def search_all_reactions(search_item)
  # LIKE is the SQL standard while ILIKE is a useful extension made by PostgreSQL.
  # use ILIKE in production and LIKE in development
  return Reaction.where "reactive_ingredient ILIKE ? OR reactive_substances ILIKE ?", "%#{search_item}%", "%#{search_item}%"
  #return Reaction.where "reactive_ingredient LIKE ? OR reactive_substances LIKE ?", "%#{search_item}%", "%#{search_item}%"

end