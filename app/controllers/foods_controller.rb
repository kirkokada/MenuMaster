class FoodsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_admin, except: [:show, :index]

	before_filter(:only => :index) do |controller|
   controller.send(:is_admin) unless controller.request.format.html?
 	end

	def new
		@food = Food.new
	end

	def create
		@food = Food.new(food_params)
		if @food.save
			flash[:success] = "Food created."
			redirect_to foods_path
		else
			render 'new'
		end
	end

	def show
		@food = Food.find(params[:id])
	end

	def index
		@foods = Food.order(:name).paginate(page: params[:page], 
																										per_page: 30)
		respond_to do |format|
			format.html
			format.csv { render text: Food.to_csv }
			format.xls
		end
	end

	def edit
		@food = Food.find(params[:id])
	end

	def update
		@food = Food.find(params[:id])
		if @food.update_attributes(food_params)
			flash[:success] = "Food updated."
			redirect_to foods_path
		else
			render 'edit'
		end
	end

	def destroy
		Food.find(params[:id]).destroy
		flash[:succes] = "Food deleted."
		redirect_to foods_path
	end

	private

		def food_params
			params.require(:food).permit(:name, :carbs, :fat, :protein, :calories)
		end
end
