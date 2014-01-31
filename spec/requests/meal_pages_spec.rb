require 'spec_helper'

describe "MealsPages" do
	subject { page }
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { FactoryGirl.create :recipe, user: user }

  describe "meal creation" do
  end
end
