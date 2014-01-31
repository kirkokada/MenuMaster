class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.date :eaten_at
      t.integer :recipe_id
      t.integer :user_id
    end
  end
end
