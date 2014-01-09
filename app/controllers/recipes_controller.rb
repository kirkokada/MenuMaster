class RecipesController < ApplicationController
	before_action :signed_in_user, except: [:show, :user]
	before_action :correct_recipe, only: [:edit, :update, :destroy]

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
		@recipe = Recipe.friendly.find(params[:id])
		@ingredients = table_items(@recipe.ingredients)
		@title = "#{@recipe.name} by #{@recipe.user.username}"
		respond_to do |format|
			format.html do
				if request.path != recipe_path(@recipe)
					redirect_to @recipe
				end
			end
			format.js
		end
	end

	def index
		@title = "My Recipes"
		@recipes = table_items(current_user.recipes)
		respond_to do |format|
			format.html
			format.js { render :table }
		end
	end

	def destroy
		@recipe.destroy
		redirect_to recipes_path
	end

	def browse
		@title = "Browse Recipes"
		@recipes = table_items(Recipe)
		respond_to do |format|
			format.html { render :index }
			format.js   { render :table }
		end
	end

	def user
		@user = User.find_by_username(params[:id])		
		@recipes = table_items(@user.recipes)
		@title = @user.username + "'s Recipes"
		respond_to do |format|
			format.html { render :index }
			format.js   { render :table }
		end
	end

	private
		def recipe_params
			params.require(:recipe).permit(:name, :description)
		end

		def correct_recipe
			@recipe = current_user.recipes.friendly.find(params[:id])
		rescue
			redirect_to root_path
		end
end
