class AddFoodDataToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :calories, :float
    add_column :ingredients, :protein, :float
    add_column :ingredients, :carbs, :float
    add_column :ingredients, :fat, :float
  end
end
