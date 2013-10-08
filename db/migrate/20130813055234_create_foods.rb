class CreatFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :calories
      t.integer :protein
      t.integer :fat
      t.integer :carbs

      t.timestamps
    end

    add_index :foods, :name
  end
end
