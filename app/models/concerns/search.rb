module Search
	extend ActiveSupport::Concern

	module ClassMethods
		def search(search)
			if search
				where("name LIKE ?", "%#{search}%")
			else
				all
			end
		end
	end
end