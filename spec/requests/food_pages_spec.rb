require 'spec_helper'

describe "FoodPages" do
  subject { page }

  let(:admin) { FactoryGirl.create :admin }
	let(:user) { FactoryGirl.create :user }

  describe "food creation" do
  	let(:create) { "Create food" }

  	before do
  		sign_in admin
  		visit new_food_path
  	end 

		describe "page" do
			it { should have_content create }
			it { should have_title full_title(create) }
		end

		describe "with invalid information" do
			
			it "should not create an food" do
				expect { click_button create }.not_to change(Food, :count)
			end

			describe "after submission" do
				before { click_button create }
				it { should have_selector 'div.alert.alert-error' }
			end
		end

		describe "with valid information" do
			let(:name) { "Food" }
			before do
			  fill_in "Name",     with: name
			  fill_in "Carbs",    with: "100"
			  fill_in "Fat",      with: "100"
			  fill_in "Protein",  with: "100"
			  fill_in "Calories", with: "1700"
			end

			it "should create an food" do
				expect { click_button create }.to change(Food, :count).by(1)
			end

			describe "after submission" do
				before { click_button create}

				it { should have_title "All foods" }
				it { should have_selector "div.alert.alert-success" }
			end
		end
  end

  describe "show page" do
  	let(:food) { FactoryGirl.create :food }
  	
  	before do
  		sign_in user
	  	visit food_path(food)
  	end 

  	it { should have_title full_title(food.name) }
  	it { should have_content food.name }
  	it { should have_content food.carbs.to_s }
  	it { should have_content food.protein.to_s }
  	it { should have_content food.fat.to_s }
  	it { should have_content food.calories.to_s }
  end

  describe "index" do
  	let!(:food) { FactoryGirl.create :food }
		before do
			sign_in user
			visit foods_path
		end

  	describe "page" do
  		it { should have_title full_title("All foods") }
  		it { should have_content "All foods" }
  		it { should have_link food.name, href: food_path(food) }
			it { should_not have_link "Edit" } 		
			it { should_not have_link "Delete" }

			it "should list all foods" do
				Food.all.each do |food|
					expect(page).to have_selector "tr#food_#{food.id}"
				end
			end

			describe "pagination" do
				before(:all) do
					30.times { FactoryGirl.create :food }
				end
				after(:all) { Food.delete_all }

				it { should have_selector "div.pagination" }
			end

			describe "as an admin" do
				before do
					click_link "Sign out"
					sign_in admin
					visit foods_path
				end

				it { should have_link "+ Add food", href: new_food_path }
				it { should have_link "Show", href: food_path(food) }
				it { should have_link "Edit", href: edit_food_path(food) }
				it { should have_link "Delete", href: food_path(food) }

				describe "delete links" do
					it "should delete the user" do
						expect { click_link "Delete" }.to change(Food, :count).by(-1)
					end
				end
			end
  	end
  end

  describe "edit" do
  	let!(:food) { FactoryGirl.create :food }
  	before do
	  	sign_in admin
	  	visit edit_food_path(food)
  	end 

  	describe "with invalid information" do
  		before do 
  			fill_in "Name", with: " "
  			click_button "Update"
  		end
  		it { should have_selector "div.alert.alert-error" }
  	end

  	describe "with valid information" do
  		let(:new_name) { "Chicken" }
  		before do
  		  fill_in "Name", with: new_name
  		  click_button "Update"
  		end

  		it { should have_title full_title 'All foods' }

  		it "should update the information" do
  			expect(food.reload.name).to eq new_name
  		end
  	end
  end
end
