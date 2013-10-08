class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.timestamps
    end

    add_index :recipes, :user_id
    add_index :recipes, :name
  end
end
