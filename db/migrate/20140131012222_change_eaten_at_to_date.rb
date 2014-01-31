class ChangeEatenAtToDate < ActiveRecord::Migration
	def up
		change_column :meals, :eaten_at, :date
		add_index :meals, [:eaten_at, :user_id], unique: true
	end

	def down
		change_column :meals, :eaten_at, :datetime
		remove_index :meals, [:eaten_at, :user_id]
	end
end
