## Converts CSV file contents to a Dictionary where each key is a unique identifier.
class_name CSVConverter extends RefCounted

## Parameters:[br]
## - file_path: String path to the CSV file[br]
## - id_column: String name of the column to use as Dictionary keys (default: first column)[br]
## Returns: Dictionary where keys are from id_column and values are row dictionaries.
func csv_to_dict(file_path: String) -> Dictionary:
	var result_dict = {}
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		push_error("Failed to open file: " + file_path)
		return result_dict
	
	# Read headers
	var headers = file.get_csv_line()
	
	# Read data rows
	while not file.eof_reached():
		var values = file.get_csv_line()
		if values.size() == 0:
			continue
			
		var row_dict = {}
		
		# Create dictionary using headers as keys
		for i in range(min(headers.size(), values.size())):
			# Special handling for SKILLS column
			if headers[i] == "SKILLS":
				# Split skills by semicolon and clean up the array
				var skills = Array(values[i].split(";"))
				# Remove empty entries
				skills = skills.filter(func(x): return not x.is_empty())
				row_dict[headers[i]] = skills
			else:
				row_dict[headers[i]] = _convert_value(values[i])
		
		# Use the ID as the dictionary key
		var id_value = row_dict["ID"]
		result_dict[id_value] = row_dict
	
	return result_dict

# Helper function to convert string values to appropriate types
func _convert_value(value: String) -> Variant:
	# Try converting to integer
	if value.is_valid_int():
		return value.to_int()
		
	# Return as string for all other values
	return value
