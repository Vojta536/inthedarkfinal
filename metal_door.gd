extends StaticBody3D

var open = false
var disable = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _keepOpen():
		open = true
		disable = true
		self.rotation.y = deg_to_rad(120)



func _openClose():
	if disable == false:
		$AudioStreamPlayer3D.playing = true
		if open == false:
			open = true
			self.rotation.y = deg_to_rad(120)
		else:
			open = false
			self.rotation.y = 0
		
