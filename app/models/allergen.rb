class Allergen < ApplicationRecord
  #The model should be able to answer the question "Can user x do y to this object?"
  #When you write regular methods in the model those methods are all instance methods.  
  #In other words def some_method will be a method available on each retrieved record

# dependent: :destroy, rails will destroy all reactions associated with Allergen when its deleted
  has_many  :reactions, dependent: :destroy
  # A has_many :through association is often used to set up a many-to-many connection 
  # with another model (Reaction). This association indicates that the declaring model (Allergen) can be 
  # matched with zero or more instances of another model (Product) by proceeding through a third model (Reaction).
  has_many  :products, through: :reactions

  validates :category, presence: true
  #to validate more than one column (or more), you can add that to the scope
  validates :substances, presence: true, length: {minimum: 2}
  #Match any characters as few as possible until a ";" is found, without counting the ";".
  #validates :substances, format: { with: /.+?(?=;)/, :message => "must end with or be seperated by a ';'" }
  #validates :substances, format: { with: /.+?(?=;)/, :message => "must end with or be seperated by a ';'" }
  #validates_format_of :substances, :with => /.+?(?=;)/ ,
  #  :message => "must end with or be seperated by a ';'"
  #validates_format_of :substances, :with => /.+?(?=;)|\n/ ,
  #  :message => "must end with or be seperated by a ';' or a newline (return)"
  validates_format_of :substances, {:with =>  /.+?(?=;)|.+?(?=\n)/ ,
    :message => "must end with or be seperated by a ';' or a newline (return)"}


  #process user input substance string such that substances are seperated by ";"
  def substances=(value)
    processed_substance_str = process_new_allergen_entry(value)
    write_attribute(:substances, processed_substance_str)
  end

  def get_substances
    substances_array = self.substances.split(";")
    return substances_array
  end

  def process_new_allergen_entry(substances)

    substance_str = substances

    # if valid input
    if substances.include?(";") || substances.include?("\n")

      # seperate substances string into array elements using ";" and "newline"
      substances_array = substances.split(/;|\n/)

      # if only 1 substance in array add a an ";" to the end
      if substances_array.length == 1 
        substance_str = substances_array[0] + ";"
      else
        # delete any nill or all whitespace entries from array
        # and create a new string where ";" seperates each substance
        substance_str = substances_array.delete_if { |substance| substance.blank?}.join(";")
      end
    end

    return substance_str
  end

  # array of substances match the ingredient
  def matching_substances_to(ingredient)
    matching_substances = []
    # does ingredient match any substance in this allergen category 
    matching_substances = self.get_substances.select {|substance| 
        (ingredient.upcase.include?(substance.upcase) || substance.upcase.include?(ingredient.upcase))
      } 

    # matching substances should not inclue any matching whitespaces
    matching_substances = matching_substances.delete_if { |substance| substance.blank?}

    return matching_substances
  end

end