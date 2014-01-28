# == Schema Information
#
# Table name: foods
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  calories   :integer
#  protein    :integer
#  fat        :integer
#  carbs      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Food do
	let(:food) { Food.new(name: "Soylent Green", carbs: 30, protein: 30, fat: 30, calories: 510) }
  subject { food }

  it { should respond_to :name }
  it { should respond_to :carbs }
  it { should respond_to :protein }
  it { should respond_to :calories }

  describe "when name" do

  	describe "is not present" do
	  	before { food.name = " " }
	  	it { should_not be_valid }
	  end

	  describe "is nil" do
	  	before { food.name = nil }
	  	it { should_not be_valid }
	  end

	  describe "is not unique" do
	  	before do
	  	  food_with_same_name = food.dup
	  	  food_with_same_name.name = food_with_same_name.name.upcase
	  	  food_with_same_name.save
	  	end

	  	it { should_not be_valid }
	  end
  end

  describe "when name is nil" do
  	before { food.name = nil }
  	it { should_not be_valid }
  end

  describe "when carbs value is nil" do
  	before { food.carbs = nil }
  	it { should_not be_valid }
  end

  describe "when protein value is nil" do
  	before { food.protein = nil }
  	it { should_not be_valid }
  end

  describe "when fat value is nil" do
  	before { food.fat = nil }
  	it { should_not be_valid }
  end

  describe "when calories value is nil" do
  	before { food.calories = nil }
  	it { should_not be_valid }
  end
end
