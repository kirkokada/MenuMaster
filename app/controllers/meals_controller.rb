class MealsController < ApplicationController
	def new
		@meal = current_user.meals.build
	end

	def create
		@meal = current_user.meals.build(meal_params)
		if @meal.save
			# stuff
		else
			render 'new'
		end
	end

	private
		def meal_params
			params.require(:meal).permit(:eaten_at)
		end
end
