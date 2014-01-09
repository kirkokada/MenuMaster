class IngredientsController < ApplicationController
	before_filter :signed_in_user
	before_filter :current_user_recipe

	def new
		@foods = table_items(Food)
		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		@ingredient = @recipe.ingredients.build(ingredient_params)
		if @ingredient.save
			respond_to do |format|
				format.html do
					@foods = Food.paginate(page: params[:page])
					render :new
				end
				format.js
			end
		else
			respond_to do |format|
				format.html
				format.js { render action: 'add_ingredient' }
			end
		end
	end

	def destroy
		@ingredient = @recipe.ingredients.find(params[:id])
		@food = @ingredient.food
		@ingredient.destroy
		respond_to do |format|
			format.html { redirect_to @recipe }
			format.js
		end
	end

	def edit
		@ingredient = @recipe.ingredients.find(params[:id])
		respond_to do |format|
			format.html
			format.js 
		end
	end

	def update
		@ingredient = @recipe.ingredients.find(params[:id])
		if @ingredient.update_attributes(ingredient_params)
			respond_to do |format|
				format.html { redirect_to new_recipe_ingredient_path(@recipe) }
				format.js
			end
		else
			respond_to do |format|
				format.html
				format.js { render :edit, id: @ingredient.id, recipe_id: @recipe.id, format: :js }
			end
		end
	end

	private

		def current_user_recipe
			@recipe = current_user.recipes.friendly.find(params[:recipe_id])
		rescue
			redirect_to root_path
		end

		def ingredient_params
			params.require(:ingredient).permit(:food_id, :amount)
		end
end
