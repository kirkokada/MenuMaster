# == Schema Information
#
# Table name: selected_recipes
#
#  id         :integer          not null, primary key
#  meal_id    :integer
#  recipe_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class SelectedRecipe < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :meal

	validates :meal_id, presence: true
end
