## Converts CSV file contents to a Dictionary
class_name CSVConverter extends RefCounted

## Converts CSV file contents into usable Dictionary for Godot.[br]
## The CSV contents structure must be the same as provided in the test PDF file.[br] 
## [b]ID,JOBNAME,DESCRIPTION,SKILLS[/b][br]
## [b]int,string,string,string;[/b]
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
		
		# Get the ID first
		var id = int(values[0])
		
		# Create dictionary using headers as keys, skip ID column
		for i in range(1, min(headers.size(), values.size())):
			# Special handling for SKILLS column
			if headers[i] == "SKILLS":
				# Split skills by semicolon and clean up the array
				var skills = Array(values[i].split(";"))
				# Remove empty entries
				skills = skills.filter(func(x): return not x.is_empty())
				row_dict[headers[i]] = skills
			else:
				row_dict[headers[i]] = values[i]
		
		# Store in result dictionary using ID as key
		result_dict[id] = row_dict
	
	return result_dict
