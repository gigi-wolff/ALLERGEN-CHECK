class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.text "reactive_substances"
      t.string "reactive_ingredient"
      t.timestamps
    end
  end
end
