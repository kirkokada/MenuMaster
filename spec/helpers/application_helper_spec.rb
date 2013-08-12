require 'spec_helper'

describe ApplicationHelper do
	
	describe "full title" do
		it "should include full title" do
			expect(full_title('foo')).to match(/foo/)
		end

		it "should include base title" do
			expect(full_title('foo')).to match(/^MenuMaster/)
		end

		it "should not include a bar (|) for the home page" do
			expect(full_title('')).not_to match(/\|/)
		end
	end
end