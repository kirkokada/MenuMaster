shared_examples_for "a sortable table" do

  def create_object
    raise "FactoryGirl.create(something)"
  end

  let(:object_1_id) { "#" + object_1.class.to_s.downcase + "_" + object_1.id.to_s }
  let(:object_2_id) { "#" + object_2.class.to_s.downcase + "_" + object_2.id.to_s }

  it { should have_selector ".table" }
  it { should have_selector object_1_id, text: object_1.name }
  it { should have_selector object_2_id, text: object_2.name }

  it "should list the items by name in ascending order" do
    expect(object_1.name).to appear_before object_2.name
  end

  describe "after clicking \"Name\"" do
    before { click_link "Name" }

    it "should list the items by name in descending order" do
      expect(object_2.name).to appear_before object_1.name
    end
  end

  table_headers.each do |column_name|
    
    describe "after clicking \"#{column_name}\"" do
      before { click_link column_name }

      it "should list the items by #{column_name} in ascending order" do
        expect(object_1.name).to appear_before object_2.name
      end

      describe "twice" do
        before { click_link column_name }

        it "should list the items by #{column_name} in descending order" do
          expect(object_2.name).to appear_before object_1.name
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
      expect(object_2.name).to appear_before object_1.name
    end  
  end

  describe "pagniation" do
    before do
      9.times { create_object } 
      visit current_path 
    end

    it { should     have_selector ".pagination" }
    it { should     have_content object_1.name }
    it { should_not have_content object_2.name }
  end
end

def table_headers
  %w[Calories Carbs Protein Fat]
end

RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  end
end