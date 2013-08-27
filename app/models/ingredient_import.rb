class IngredientImport
	extend ActiveModel::Model
	include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_ingredients.map(&:valid?).all?
      imported_ingredients.each(&:save!)
      true
    else
      imported_ingredients.each_with_index do |ingredient, index|
        ingredient.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_ingredients
    @imported_ingredients ||= load_imported_ingredients
  end

  def load_imported_ingredients
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ingredient = Ingredient.find_by_id(row["id"]) || Ingredient.new
      ingredient.attributes = row.to_hash.slice(*Ingredient.accessible_attributes)
      ingredient
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end