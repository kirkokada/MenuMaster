class IngredientsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_admin, except: [:show, :index]

	before_filter(:only => :index) do |controller|
   controller.send(:is_admin) unless controller.request.format.html?
 	end

	def new
		@ingredient = Ingredient.new
	end

	def create
		@ingredient = Ingredient.new(ingredient_params)
		if @ingredient.save
			flash[:success] = "Ingredient created."
			redirect_to ingredients_path
		else
			render 'new'
		end
	end

	def show
		@ingredient = Ingredient.find(params[:id])
	end

	def index
		@ingredients = Ingredient.order(:name).paginate(page: params[:page], 
																										per_page: 30)
		respond_to do |format|
			format.html
			format.csv { render text: Ingredient.to_csv }
			format.xls
		end
	end

	def edit
		@ingredient = Ingredient.find(params[:id])
	end

	def update
		@ingredient = Ingredient.find(params[:id])
		if @ingredient.update_attributes(ingredient_params)
			flash[:success] = "Ingredient updated."
			redirect_to ingredients_path
		else
			render 'edit'
		end
	end

	def destroy
		Ingredient.find(params[:id]).destroy
		flash[:succes] = "Ingredient deleted."
		redirect_to ingredients_path
	end

	private

		def ingredient_params
			params.require(:ingredient).permit(:name, :carbs, :fat, :protein, :calories)
		end
end
