require 'spec_helper'

describe Ingredient do
	let(:ingredient) { Ingredient.new(name: "Soylent Green", carbs: 30, protein: 30, fat: 30, calories: 510) }
  subject { ingredient }

  it { should respond_to :name }
  it { should respond_to :carbs }
  it { should respond_to :protein }
  it { should respond_to :calories }

  describe "when name" do

  	describe "is not present" do
	  	before { ingredient.name = " " }
	  	it { should_not be_valid }
	  end

	  describe "is nil" do
	  	before { ingredient.name = nil }
	  	it { should_not be_valid }
	  end

	  describe "is not unique" do
	  	before do
	  	  ingredient_with_same_name = ingredient.dup
	  	  ingredient_with_same_name.name = ingredient_with_same_name.name.upcase
	  	  ingredient_with_same_name.save
	  	end

	  	it { should_not be_valid }
	  end
  end

  describe "when name is nil" do
  	before { ingredient.name = nil }
  	it { should_not be_valid }
  end

  describe "when carbs value is nil" do
  	before { ingredient.carbs = nil }
  	it { should_not be_valid }
  end

  describe "when protein value is nil" do
  	before { ingredient.protein = nil }
  	it { should_not be_valid }
  end

  describe "when fat value is nil" do
  	before { ingredient.fat = nil }
  	it { should_not be_valid }
  end

  describe "when calories value is nil" do
  	before { ingredient.calories = nil }
  	it { should_not be_valid }
  end
end
