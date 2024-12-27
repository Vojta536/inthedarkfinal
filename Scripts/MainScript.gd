extends Node3D
signal usingcamera
var camplace = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	get_tree().call_group("enemies","update_player_location",$Player.global_position)
	print($Player/Camera3D/RayCast3D.get_collision_point().x)
	if(camplace):
		$Cam.position = $Player/Camera3D/RayCast3D.get_collision_point()
		$Cam.position.y += 1.5
		print("Je ray pickable")
		print($Cam.input_ray_pickable)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_placecamtrue():
	camplace = true
	$Cam/CollisionShape3D.disabled = true

func _on_player_placecamfalse():
	camplace = false
	$Cam/CollisionShape3D.disabled = false


func _on_player_camvisible():
	$Cam.visible = true


func _on_player_caminvisible():
	$Cam.visible = false


func _on_player_viewcam():
	if $Cam.visible == true:
		$Cam/Camera3D.make_current()
		emit_signal("usingcamera")


func _on_player_cam_1():
	$Cam/CamSprite.visible = true
	$Cam/ViewBox.visible = false
