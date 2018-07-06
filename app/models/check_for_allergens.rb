def check_for_allergens(id_of_product)
  #require "pry"

  # If product exists in Reaction db, delete it so there aren't conflicting
  # results in db
  if Reaction.exists?(product_id: id_of_product)
    Reaction.where("product_id = ?", id_of_product).destroy_all
  end

  ingredients = Product.find(id_of_product).ingredients
  product_ingredients = process_ingredients_string(ingredients)

  # test each ingredient
  product_ingredients.each do |ingredient|
    # look for each ingredient in allergen db
    reactive_allergens = Allergen.where "substances ILIKE ?", "%#{ingredient}%"
    # if ingredient matches allergens in db
    if !reactive_allergens.empty? 
      # check each allergen that the ingredient matches
      reactive_allergens.each do |allergen|
        reactive_substances = ''
        substances = allergen.substances.split(";")
        # check each substance to see if it includes the ingredient 
        substances.each do |substance|      
          if substance.upcase.include?(ingredient.upcase)
            reactive_substances += substance.upcase + ';'
          end
        end
        # add the substances matching substances to the Reaction db
        Reaction.create(product_id: id_of_product, 
          allergen_id: allergen.id, 
          reactive_substances: reactive_substances, 
          reactive_ingredient: ingredient.upcase)
      end
    end
  end
  
end
