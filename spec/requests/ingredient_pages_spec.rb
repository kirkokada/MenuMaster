require 'spec_helper'

describe "IngredientPages" do
  let!(:user) { FactoryGirl.create :user }
  let!(:food_1) { FactoryGirl.create :food }
  let!(:food_2) { FactoryGirl.create :food }
  let!(:recipe) { FactoryGirl.create :recipe, user: user }
  
  subject { page }

  describe "Add ingredient" do
		before do 
			sign_in user
			visit new_recipe_ingredient_path(recipe)
		end

  	describe "page" do

  		it { should have_title "Add ingredient" }
      it { should have_link "Return", href: recipe_path(recipe) }

      describe "table" do
        
        it_should_behave_like "a sortable table" do
          let!(:object_1) { food_1 }
          let!(:object_2) { food_2 }
        end
      end
  	end

  	describe "add ingredient button" do
      let(:amount) { "20" }
      let(:ingredient) { "#food_#{food_1.id}" }
      before do
        within ingredient do
          fill_in "Amount", with: amount
        end 
      end
  		
  		it "should increment the ingredient count" do
  			expect do
          within ingredient do
            click_button "Add"
          end 
        end.to change(Ingredient, :count).by(1)
  		end

  		describe "after clicking the button", js: true do
  			before do 
          within ingredient do 
            click_button "Add" 
          end
        end
  			it { should have_content amount }
        it "should be removed" do
          expect(page.find(ingredient)).not_to have_button "Add"
        end
  		end
  	end
  end
end
