class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.datetime :eaten_at
    end

    add_index :eaten_at
  end
end