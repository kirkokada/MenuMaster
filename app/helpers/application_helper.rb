module ApplicationHelper
	def full_title(page_title)
		base_title = "MenuMaster"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}".html_safe
		end
	end

	def sortable(object_model, column, title = nil)
		title ||= column.titleize
		direction = (column == sort_column(object_model) && sort_direction == "asc") ? "desc" : "asc"
		link_to title, params.merge(sort: column, direction: direction, page: nil)
	end

	def sort_column(object_model)
		object_model.column_names.include?(params[:sort]) ? params[:sort] : "name"
	end

	def sort_direction
		%w[asc, desc].include?(params[:direction]) ? params[:direction] : "asc"
	end

	def order_args(object_model)
		if sort_column(object_model) == "name"
			"lower(#{sort_column(object_model)}) #{sort_direction}"
		else
		  "#{sort_column(object_model)} #{sort_direction}"
		end
	end

	# takes a searchable array of records as an argument, returns sorted & paginated collection
	def table_items(collection) 
		collection.search(params[:search]).order(order_args(collection)).paginate(page: params[:page], 
																										                       per_page: 10)
	end

	def collection_type
		%w[Recipe Food Ingredient]
	end
end
