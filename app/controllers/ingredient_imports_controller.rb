class IngredientImportsController < ApplicationController
	before_filter :is_admin
	before_filter :no_file, only: :create

	def new
		@ingredient_import = IngredientImport.new
	end

	def create
		@ingredient_import = IngredientImport.new(params[:ingredient_import])
		if @ingredient_import.save
			flash[:success] = "Ingredients successfully imported."
			redirect_to ingredients_path
		else
			render 'new'
		end
	end

	private 

		def no_file
			if params[:ingredient_import].nil?
				flash[:error] = "No file selected"
				redirect_to new_ingredient_import_path
			end
		end
end