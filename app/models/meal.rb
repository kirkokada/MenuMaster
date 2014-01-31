class Meal < ActiveRecord::Base
	belongs_to :user
	has_one :recipe

	validates_presence_of :eaten_at
	validates_presence_of :user_id
	validates_presence_of :recipe_id

	validate :eaten_at_cannot_be_in_the_future

	private 

		def eaten_at_cannot_be_in_the_future
			if eaten_at && eaten_at > Date.today
				errors.add(:eaten_at, "cannot be in the future")
			end
		end
end
