# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  food_id    :integer
#  recipe_id  :integer
#  amount     :integer
#  created_at :datetime
#  updated_at :datetime
#  calories   :float
#  protein    :float
#  carbs      :float
#  fat        :float
#  name       :string(255)
#

require 'spec_helper'

describe Ingredient do
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { FactoryGirl.create :recipe, user: user }
	let(:food) { FactoryGirl.create :food, calories: 5 }
  let(:ingredient) { recipe.ingredients.build(food_id: food.id, amount: 2) }

  subject { ingredient }

  it { should respond_to :amount }
  it { should respond_to :calories }
  it { should respond_to :carbs }
  it { should respond_to :fat }
  it { should respond_to :food }
  it { should respond_to :food_id }
  it { should respond_to :proportion }
  it { should respond_to :protein }
  it { should respond_to :recipe }
  it { should respond_to :recipe_id }
  it { should respond_to :name }
  its(:food)   { should eq food }
  its(:recipe) { should eq recipe }
  its(:proportion) { should == ingredient.amount / 100.0 }

  describe "nutritional data" do
    
    before { ingredient.save }

    its(:name)     { should eq food.name }
    its(:calories) { should == food.calories * ingredient.proportion }
    its(:carbs)    { should == food.carbs    * ingredient.proportion }
    its(:fat)      { should == food.fat      * ingredient.proportion }
    its(:protein)  { should == food.protein  * ingredient.proportion }
  end

  describe "when food_id is nil" do
  	before { ingredient.food_id = nil }
  	it { should_not be_valid }
  end

  describe "when amount is nil" do
    before { ingredient.amount = nil }
    it { should_not be_valid }
  end

  describe "updating amount" do
    let(:new_amount) { 300 }
    let!(:new_proportion) { 300/100.0 }
    before do
      ingredient.save 
      ingredient.update_attributes(amount: new_amount)
    end
    its(:amount)     { should == new_amount }
    its(:proportion) { should == new_proportion }
    its(:calories)   { should == food.calories * new_proportion }
    its(:fat)        { should == food.fat      * new_proportion }
    its(:carbs)      { should == food.carbs    * new_proportion }
    its(:protein)    { should == food.protein  * new_proportion }
  end
end
