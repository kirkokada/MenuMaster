class RenameIngredientToFood < ActiveRecord::Migration
	def self.up
		rename_table :ingredients, :foods
	end
	def self.down
		rename_table :foods, :ingredients
	end
end
