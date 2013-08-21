class Ingredient < ActiveRecord::Base
	validates :name,     presence: true, uniqueness: { case_sensitive: false }
	validates :calories, presence: true
	validates :fat,      presence: true
	validates :carbs,    presence: true
	validates :protein,  presence: true
end
