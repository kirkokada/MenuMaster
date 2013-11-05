class Recipe < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: [:slugged, :history]
	belongs_to :user
	validates :name, presence: true
	validates :slug, presence: true, uniqueness: { case_sensitive: false }
	has_many :ingredients, dependent: :destroy

	def should_generate_new_friendly_id?
		name_changed?
	end

	def calories
		self.ingredients.sum(:calories)
	end

	def carbs
		self.ingredients.sum(:carbs)
	end

	def protein
		self.ingredients.sum(:protein)
	end

	def fat
		self.ingredients.sum(:fat)
	end

	def slug_candidates
		[
			"#{name} by #{user.username}",
			"#{name} by #{user.username} #{Time.now.to_s}"
		]
	end
end
