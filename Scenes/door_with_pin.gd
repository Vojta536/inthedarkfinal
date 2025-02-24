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


func _on_control_passcode_entered() -> void:
	open = true
	self.rotation.y =  190.5
	$AudioStreamPlayer3D.playing = true
