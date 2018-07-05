class CreateAllergens < ActiveRecord::Migration[5.1]
  def change
    create_table :allergens do |t|
      t.string  :category
      t.text    :substances
    end
  end
end
