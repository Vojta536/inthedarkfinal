extends StaticBody3D

var open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _openClose():
	pass









func _on_enemy_open_night_one_door() -> void:
	open = true
	self.rotation.y =  190.5
	$AudioStreamPlayer3D.playing = true


func _on_player_open_night_one_door_pl() -> void:
	open = true
	self.rotation.y =  190.5
	$AudioStreamPlayer3D.playing = true
