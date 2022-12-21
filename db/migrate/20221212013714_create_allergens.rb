class CreateAllergens < ActiveRecord::Migration[7.0]
  def change
    create_table :allergens do |t|
      t.string "category"
      t.text "substances"
      t.timestamps
    end
  end
end
