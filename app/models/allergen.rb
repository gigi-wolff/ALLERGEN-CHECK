class Allergen < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Allergen when its deleted
  has_many  :reactions, dependent: :destroy
  has_many  :products, through: :reactions

  validates :category, presence: true, uniqueness: true, length: {minimum: 3}
  validates :substances, presence: true, length: {minimum: 3}

  # After allergen has been created or update (and saved) check all products for
  # this allergen
  after_save do |allergen|
    if Product.any?
      Product.pluck(:id).each {|product_id| check_for_allergens(product_id)}
    end
  end 

end