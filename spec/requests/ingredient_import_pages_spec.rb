require 'spec_helper'

describe "IngredientImportPages" do
	subject { page }

	let(:admin) { FactoryGirl.create :admin }

	before { sign_in admin }

	describe "import" do
		before { visit new_ingredient_import_path }

		describe "page" do
			it { should have_title full_title "Ingredient Import" }
			it { should have_content "Ingredient Import" }
		end

		describe "with valid filetype and invalid data" do
			before do
			  attach_file "File", Rails.root.join('spec/fixtures/files/test_file_invalid.xlsx')
			  click_button "Import"
			end

			it { should have_selector 'div.alert.alert-error' }
		end

		describe "with no file" do
			before { click_button "Import" }

			it { should have_selector 'div.alert.alert-error' }
		end

		describe "with valid filetype and data" do
			before do
			  attach_file "File", Rails.root.join('spec/fixtures/files/test_file_valid.xlsx')
			  click_button "Import"
			end

			it { should have_selector 'div.alert.alert-success' }
		end
	end
end
