# == Schema Information
#
# Table name: foods
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  calories   :integer
#  protein    :integer
#  fat        :integer
#  carbs      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Food < ActiveRecord::Base
	include Search

	validates :name,     presence: true, uniqueness: { case_sensitive: false }
	validates :calories, presence: true
	validates :fat,      presence: true
	validates :carbs,    presence: true
	validates :protein,  presence: true

	def self.to_csv(options={}) 
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |food|
				csv << food.attributes.values_at(*column_names)
			end
		end
	end

	def self.accessible_attributes
		["name", "calories", "fat", "carbs", "protein"]
	end
end
