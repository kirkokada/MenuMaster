class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :food_id
      t.integer :recipe_id
      t.integer :amount

      t.timestamps
    end

    add_index :ingredients, :food_id
    add_index :ingredients, :recipe_id
    add_index :ingredients, [:food_id, :recipe_id], unique: true
  end
end
