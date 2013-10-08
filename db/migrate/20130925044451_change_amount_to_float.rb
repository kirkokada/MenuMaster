class ChangeAmountToFloat < ActiveRecord::Migration
  def change
  	def self.up
  		change_column :ingredients, :amount, :float
  	end

  	def self.down
  		change_column :ingredients, :amount, :integer
  	end
  end
end
