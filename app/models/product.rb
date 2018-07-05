class Product < ApplicationRecord
  # dependent: :destroy, rails will destroy all reactions associated with Product when its deleted
  has_many  :reactions, dependent: :destroy
  has_many  :allergens, through: :reactions

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}
  validates :ingredients, presence: true, length: {minimum: 3}

  # After product has been created or update (and saved) check if product contains allergens
  after_save do |product|
    check_for_allergens(product.id)
  end
end

