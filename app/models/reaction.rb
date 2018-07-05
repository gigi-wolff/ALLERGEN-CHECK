class Reaction < ApplicationRecord
  belongs_to :allergen
  belongs_to :product
end