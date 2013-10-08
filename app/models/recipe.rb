class Recipe < ActiveRecord::Base
	belongs_to :user
	validates :name, presence: true
	has_many :ingredients, dependent: :destroy

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
end
