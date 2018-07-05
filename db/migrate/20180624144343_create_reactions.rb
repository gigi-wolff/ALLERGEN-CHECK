class CreateReactions < ActiveRecord::Migration[5.1]
  def change
    create_table :reactions do |t|
      t.integer  :product_id
      t.integer  :allergen_id
      t.text     :reactive_substances
      t.string   :reactive_ingredient
    end
  end
end
