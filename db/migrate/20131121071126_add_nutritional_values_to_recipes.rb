class AddNutritionalValuesToRecipes < ActiveRecord::Migration
  def change
  	add_column :recipes, :calories, :float
    add_column :recipes, :protein, :float
    add_column :recipes, :carbs, :float
    add_column :recipes, :fat, :float
  end
end
