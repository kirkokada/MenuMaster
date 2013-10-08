require 'spec_helper'

describe Recipe do
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { user.recipes.build(name: "Recipe", description:"It's good") }

	subject { recipe }

	it { should respond_to :ingredients }
  it { should respond_to :calories }
  it { should respond_to :fat }
  it { should respond_to :protein }
  it { should respond_to :carbs }
  it { should respond_to :name }
  it { should respond_to :user }
  it { should respond_to :user_id }
  it { should respond_to :description }

  describe "when name is not present" do
  	before { recipe.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is nil" do
  	before { recipe.name = nil }
  	it { should_not be_valid }
  end

end
