class MealsController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user

  def new
  	@meal = current_user.meals.build(eaten_at: Date.today)
  end

  def create
  	@meal = current_user.meals.build(meal_params)
  	if @meal.save
  		flash[:success] = "Meal recorded."
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  private

  	def meal_params
  		params.require(:meal).permit(:eaten_at, :recipe_id)
  	end

  	def correct_user
  	  @user = User.find_by_username(params[:user_id])
  	  redirect_to root_path unless current_user?(@user)
  	end
end
