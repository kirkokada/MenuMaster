# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  calories    :float
#  protein     :float
#  carbs       :float
#  fat         :float
#

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
  it { should respond_to :slug }

  describe "when name is not present" do
  	before { recipe.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is nil" do
  	before { recipe.name = nil }
  	it { should_not be_valid }
  end

  describe "when slug is created" do
    before { recipe.save }
    its(:slug) { should eq "#{recipe.name.downcase}-by-#{recipe.user.username}"}
  end

  describe "when two recipes with same name are created" do
    let!(:recipe_2) { recipe.dup }
    before do
      recipe.save
      recipe_2.save
    end

    its(:slug) { should eq "#{recipe.name.downcase}-by-#{recipe.user.username}"}
    its(:slug) { should_not eq recipe_2.slug }
  end
end
