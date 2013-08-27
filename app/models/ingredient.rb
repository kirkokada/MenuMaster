class Ingredient < ActiveRecord::Base
	validates :name,     presence: true, uniqueness: { case_sensitive: false }
	validates :calories, presence: true
	validates :fat,      presence: true
	validates :carbs,    presence: true
	validates :protein,  presence: true

	def self.to_csv(options={}) 
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |ingredient|
				csv << ingredient.attributes.values_at(*column_names)
			end
		end
	end

	def self.accessible_attributes
		["name", "calories", "fat", "carbs", "protein"]
	end
end
