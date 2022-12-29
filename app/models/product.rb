class Product < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Product when its deleted
  has_many  :reactions, dependent: :destroy
  # A has_many :through association is often used to set up a many-to-many connection 
  # with another model (Reaction). This association indicates that the declaring model (Product) can be 
  # matched with zero or more instances of another model (Allergen) by proceeding through a third model (Reaction).
  has_many  :allergens, through: :reactions


  validates :ingredients, presence: true
  #validates :ingredients, format:  {with: /\w+,\s/, :message => 
  #  "must be seperated by a ', '"}
  validates :ingredients, format:  {with: /\w+,\s|\n/, :message => 
    "must be seperated by a comma (,) followed by space ' ' or a newline (return)"}

  validates :ingredients, format: { without: /;/, :message => 
    "contains a ';' which is not a valid character" }


  # The model should be able to answer the question "Can user x do y to this object?"
  # When you write regular methods in the model those methods are all instance methods.  
  # In other words def some_method will be a method available on each retrieved product record
 
  def get_ingredients
    
    # split ingredients using ', ' or newline or '/' so abc/def is abc def
    ingredient_array = ingredients.split(/\, |\n|\//)
    
    # get rid of all duplicate whitespaces and characters that are not: a-z A-Z 0-9 - [] () ' 
    ingredient_array.map! do |ingredient|
      unless ingredient.empty?
        ingredient.split(" ").join(" ").gsub(%r{[^a-zA-Z0-9\-\[\]\,\'\(\)\s]}, '')
      end
    end
    
    # ingredient array shouldn't have any nill or all whitespace entries
    clean_array = ingredient_array.delete_if { |ingredient| ingredient.blank?}

    #x=1/0
    return clean_array
  end

  def causes_reaction
    if Reaction.exists?(product_id: self.id)
      return Reaction.where("product_id = ?", self.id)
    else
      return []
    end
  end

  def check_for_allergens
    allergens = Allergen.all
    # test each ingredient in product
    self.get_ingredients.each do |ingredient|
      reactive_substances = []
      # against each allergen category
      allergens.find_each do |allergen|
        # check for substances that match this ingredient in this categor
        reactive_substances = allergen.matching_substances_to(ingredient)
        #x=1/0
        if reactive_substances.any? # add information to the Reaction db
          # Create a new entry in Reaction db for this product
          Reaction.create(product_id: self.id, 
          allergen_id: allergen.id,
          reactive_substances: reactive_substances.join(', '),
          reactive_ingredient: ingredient.upcase)
        end
      end
    end
    #x=1/0
  end

  before_create do
    #Start with an empty db, there will never be more than 1 product in db
    Product.destroy_all
  end

  after_save do
    # Start with an empty Reaction DB, 
    # then check and save reactions after saving product
    Reaction.destroy_all
    check_for_allergens
  end

end

