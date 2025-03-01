extends Node3D



var alphaSprite = 0.0



func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alphaSprite < 1:
		alphaSprite += 0.001
		$Node2D/Black.modulate = Color(0,0,0,alphaSprite)


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
