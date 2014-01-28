class CreateSelectedRecipes < ActiveRecord::Migration
  def change
    create_table :selected_recipes do |t|
      t.integer :meal_id
      t.integer :recipe_id

      t.timestamps
    end

    add_index :selected_recipes, :meal_id
    add_index :selected_recipes, :recipe_id
    add_index :selected_recipes, [:meal_id, :recipe_id], unique: true
  end
end
