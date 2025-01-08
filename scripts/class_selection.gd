extends Control

# Node references
@onready var job_dropdown: OptionButton = $OptionButton
@onready var job_name_label: Label = $JobName
@onready var job_description_label: Label = $JobDescription
@onready var skills_container: VBoxContainer = $SkillsContainer

# Constant
const PATH_TO_CLASS_CSV: String = "res://resource/class.csv"

# Store job data
var jobs_data: Dictionary = {}
var csv_converter = CSVConverter.new()

# Label Theme
var label_theme = preload("res://assets/styles/label_style.tres")

func _ready() -> void:
	# Load job data from CSV
	jobs_data = csv_converter.csv_to_dict(PATH_TO_CLASS_CSV)
	
	# Setup dropdown options
	setup_job_dropdown()
	
	# Set initial selection
	if job_dropdown.item_count > 0:
		# Connect the dropdown signal
		job_dropdown.item_selected.connect(_on_job_selected)
		
		_on_job_selected(0)

func setup_job_dropdown() -> void:
	# Clear existing items
	job_dropdown.clear()
	
	# Add jobs to dropdown
	for job_id in jobs_data:
		var job = jobs_data[job_id]
		job_dropdown.add_item(job["JOBNAME"], job_id)

func _on_job_selected(index: int) -> void:
	# Get the job ID from the selected item
	var selected_id = job_dropdown.get_item_id(index)
	
	# Get the job data
	var job = jobs_data[selected_id]
	
	# Update labels
	job_name_label.text = job["JOBNAME"]
	job_description_label.text = job["DESCRIPTION"]
	
	# Update skills
	update_skills_display(job["SKILLS"])

func update_skills_display(skills: Array) -> void:
	# Clear existing skills
	for child in skills_container.get_children():
		child.queue_free()
	
	# Add new skill labels
	for skill in skills:
		var skill_label = Label.new()
		skill_label.label_settings = LabelSettings.new()
		skill_label.label_settings.font_size = 20
		skill_label.add_theme_stylebox_override("normal", label_theme)
		skill_label.text = "• " + skill
		skills_container.add_child(skill_label)
