require 'spec_helper'

describe "IngredientPages" do
  subject { page }

  let(:admin) { FactoryGirl.create :admin }
	let(:user) { FactoryGirl.create :user }

  describe "ingredient creation" do
  	let(:create) { "Create ingredient" }

  	before do
  		sign_in admin
  		visit new_ingredient_path
  	end 

		describe "page" do
			it { should have_content create }
			it { should have_title full_title(create) }
		end

		describe "with invalid information" do
			
			it "should not create an ingredient" do
				expect { click_button create }.not_to change(Ingredient, :count)
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

			it "should create an ingredient" do
				expect { click_button create }.to change(Ingredient, :count).by(1)
			end

			describe "after submission" do
				before { click_button create}

				it { should have_title "All ingredients" }
				it { should have_selector "div.alert.alert-success" }
			end
		end
  end

  describe "show page" do
  	let(:ingredient) { FactoryGirl.create :ingredient }
  	
  	before do
  		sign_in user
	  	visit ingredient_path(ingredient)
  	end 

  	it { should have_title full_title(ingredient.name) }
  	it { should have_content ingredient.name }
  	it { should have_content ingredient.carbs.to_s }
  	it { should have_content ingredient.protein.to_s }
  	it { should have_content ingredient.fat.to_s }
  	it { should have_content ingredient.calories.to_s }
  end

  describe "index" do
  	let!(:ingredient) { FactoryGirl.create :ingredient }
		before do
			sign_in user
			visit ingredients_path
		end

  	describe "page" do
  		it { should have_title full_title("All ingredients") }
  		it { should have_content "All ingredients" }
  		it { should have_link ingredient.name, href: ingredient_path(ingredient) }
			it { should_not have_link "Edit" } 		
			it { should_not have_link "Delete" }

			it "should list all ingredients" do
				Ingredient.all.each do |ingredient|
					expect(page).to have_selector "tr#ingredient_#{ingredient.id}"
				end
			end

			describe "pagination" do
				before(:all) do
					30.times { FactoryGirl.create :ingredient }
				end
				after(:all) { Ingredient.delete_all }

				it { should have_selector "div.pagination" }
			end

			describe "as an admin" do
				before do
					click_link "Sign out"
					sign_in admin
					visit ingredients_path
				end

				it { should have_link "+ Add ingredient", href: new_ingredient_path }
				it { should have_link "Show", href: ingredient_path(ingredient) }
				it { should have_link "Edit", href: edit_ingredient_path(ingredient) }
				it { should have_link "Delete", href: ingredient_path(ingredient) }

				describe "delete links" do
					it "should delete the user" do
						expect { click_link "Delete" }.to change(Ingredient, :count).by(-1)
					end
				end
			end
  	end
  end

  describe "edit" do
  	let!(:ingredient) { FactoryGirl.create :ingredient }
  	before do
	  	sign_in admin
	  	visit edit_ingredient_path(ingredient)
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

  		it { should have_title full_title 'All ingredients' }

  		it "should update the information" do
  			expect(ingredient.reload.name).to eq new_name
  		end
  	end
  end
end
