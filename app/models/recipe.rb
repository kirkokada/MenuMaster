class Recipe < ActiveRecord::Base
	extend FriendlyId
	include Search
	friendly_id :slug_candidates, use: [:slugged, :history]
	belongs_to :user
	validates :name, presence: true
	validates :slug, presence: true, uniqueness: { case_sensitive: false }
	has_many :ingredients, dependent: :destroy


	def should_generate_new_friendly_id?
		name_changed?
	end

	def slug_candidates
		[
			"#{name} by #{user.username}",
			"#{name} by #{user.username} #{Time.now.to_s}"
		]
	end

	def set_nutritional_values
		self.update_attributes(calories: ingredients.sum(:calories),
			                     carbs: ingredients.sum(:carbs),
			                     protein: ingredients.sum(:protein),
			                     fat: ingredients.sum(:fat))
	end
end
