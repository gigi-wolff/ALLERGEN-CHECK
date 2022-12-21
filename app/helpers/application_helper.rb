module ApplicationHelper
  
  def search_all_reactions(search_item)
    # postgres uses ILIKE, sqlite3 uses LIKE:
    #return Reaction.where "reactive_ingredient LIKE ? OR reactive_substances LIKE ?", "#{search_item}", "#{search_item}"
    return Reaction.where "reactive_ingredient ILIKE ? OR reactive_substances ILIKE ?", "#{search_item}", "#{search_item}"
  end
  
end

