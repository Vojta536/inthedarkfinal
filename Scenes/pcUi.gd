extends Node2D

var searchQuery = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		searchQuery = $LineEdit.text
		if searchQuery == "Mike":
			$RichTextLabel.text = "Age 31 years old. Race - Slavic. Born 1973."
		else:
			$RichTextLabel.text = "Please enter a full name."
		$LineEdit.text = ""
