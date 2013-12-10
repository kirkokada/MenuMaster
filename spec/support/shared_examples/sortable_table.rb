shared_examples_for "a sortable table" do
  let(:first_row) { ".table_row:nth-of-type(2)" }
  let(:second_row) { ".table_row:nth-of-type(3)" }

  it { should have_selector ".table" }
  it { should have_content object_1.name }
  it { should have_content object_2.name }

  it "should list the items by name in ascending order" do
    expect(page.body.index(object_1.name)).to be < page.body.index(object_2.name)
  end

  describe "after clicking \"Name\"" do
    before { click_link "Name" }

    it "should list the items by name in descending order" do
      expect(page.body.index(object_1.name)).to be > page.body.index(object_2.name)
    end
  end

  %w[Calories Carbs Protein Fat].each do |column_name|
    
    describe "after clicking \"#{column_name}\"" do
      before { click_link column_name }

      it "should list the items by #{column_name} in ascending order" do
        expect(page.body.index(object_1.name)).to be < page.body.index(object_2.name)
      end

      describe "twice" do
        before { click_link column_name }

        it "should list the items by #{column_name} in descending order" do
          expect(page.body.index(object_1.name)).to be > page.body.index(object_2.name)
        end
      end
    end
  end

  describe "search" do

    before do
      fill_in "Search", with: object_1.name
      click_button "Search"
    end

    it { should have_content     object_1.name }
    it { should_not have_content object_2.name }
  end

  describe "sort and search" do
    before do
      click_link "Name"
      click_button "Search"
    end

    it "should apply the sorting to the search" do
      expect(page.body.index(object_1.name)).to be > page.body.index(object_2.name)
    end
  end
end