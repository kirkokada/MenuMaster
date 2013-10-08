class RecipesController < ApplicationController
	before_action :signed_in_user, except: :show
	before_action :current_user_recipe, only: [:edit, :update, :destroy]

	def new
		@recipe = current_user.recipes.build
	end

	def create
		@recipe = current_user.recipes.build(recipe_params)
		if @recipe.save
			flash[:success] = "Recipe created"
			redirect_to @recipe
		else
			render :new
		end
	end

	def edit
		respond_to do |format|
			format.html
			format.js
		end
	end

	def update
		if @recipe.update_attributes(recipe_params)
			respond_to do |format|
				format.html do 
					flash[:success] = "Recipe updated."
					redirect_to @recipe
				end
				format.js
			end
		else
			render :edit, id: @recipe.id, format: :js
		end
	end

	def show
		@recipe = Recipe.find(params[:id])
		@ingredients = @recipe.ingredients.paginate(page: params[:page])
		@title = "#{@recipe.name} by #{@recipe.user.username}"
		respond_to do |format|
			format.html
			format.js
		end
	end

	def index
		@recipes = current_user.recipes.paginate(page: params[:page])
	end

	def destroy
		@recipe.destroy
		redirect_to recipes_path
	end

	private
		def recipe_params
			params.require(:recipe).permit(:name, :description)
		end

		def current_user_recipe
			@recipe = current_user.recipes.find_by(id: params[:id])
			redirect_to root_path if @recipe.nil? 
		end
end
