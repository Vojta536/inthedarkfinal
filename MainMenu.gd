extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_back_pressed() -> void:
	$BaseUI.visible = true
	$CreditsScreen.visible = false
	$HowToPlay.visible = false


func _on_credits_pressed() -> void:
	$BaseUI.visible = false
	$CreditsScreen.visible = true


func _on_how_to_play_pressed() -> void:
	$BaseUI.visible = false
	$HowToPlay.visible = true
