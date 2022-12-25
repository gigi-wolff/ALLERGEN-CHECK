class Product < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Product when its deleted
  has_many  :reactions, dependent: :destroy
  # A has_many :through association is often used to set up a many-to-many connection 
  # with another model (Reaction). This association indicates that the declaring model (Product) can be 
  # matched with zero or more instances of another model (Allergen) by proceeding through a third model (Reaction).
  has_many  :allergens, through: :reactions


  validates :ingredients, presence: true
  validates :ingredients, format:  {with: /\w+,\s/, :message => 'must be seperated by or end with a comma followed by a space' }
  validates :ingredients, format: { without: /;/, :message => "contains a ';' which is not a valid character" }


  # The model should be able to answer the question "Can user x do y to this object?"
  # When you write regular methods in the model those methods are all instance methods.  
  # In other words def some_method will be a method available on each retrieved product record
  def get_ingredients 
    
    # get rid of all characters that are not: a-z A-Z 0-9 - [] () ' / , blank;
    clean_ingredients = ingredients.gsub(%r{[^a-zA-Z0-9\-\[\]\,\'\(\)\/\s]}, '')

    #ingredients abc/def should be turned into "abc, def"
    clean_ingredients = clean_ingredients.gsub(%r{\/}, ', ')

    return clean_ingredients.split(', ').each { |ingredient| ingredient.strip! }
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
        if reactive_substances.any? # add information to the Reaction db
          # Create a new entry in Reaction db for this product
          Reaction.create(product_id: self.id, 
          allergen_id: allergen.id,
          reactive_substances: reactive_substances.join(', '),
          reactive_ingredient: ingredient.upcase)
        end
      end
    end
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

