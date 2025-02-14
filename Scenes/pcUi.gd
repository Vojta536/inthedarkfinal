extends Node2D

var searchQuery = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		searchQuery = $LineEdit.text
		if searchQuery.to_lower() in "michael riddings" and searchQuery.length() > 4:
			$RichTextLabel.text = "Michael Riddings.\nAge 31 years old.\nRace - Slavic.\nBorn 10.4.1973.\nPosition Audio System Engineer. \nFormer robbery convict, indications of lack of empathy."
		else:
			$RichTextLabel.text = "A match was not found. Please try to make your search query more specific."
		$LineEdit.text = ""
