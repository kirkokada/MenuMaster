class FoodImportsController < ApplicationController
	before_filter :is_admin
	before_filter :no_file, only: :create

	def new
		@food_import = FoodImport.new
	end

	def create
		@food_import = FoodImport.new(params[:food_import])
		if @food_import.save
			flash[:success] = "Foods successfully imported."
			redirect_to foods_path
		else
			render 'new'
		end
	end

	private 

		def no_file
			if params[:food_import].nil?
				flash[:error] = "No file selected"
				redirect_to new_food_import_path
			end
		end
end