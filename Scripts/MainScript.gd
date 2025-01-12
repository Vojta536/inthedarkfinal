extends Node3D
signal usingcamera
var camplace = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	get_tree().call_group("enemies","update_player_location",$Player.global_position)
	#print($Player/Camera3D/RayCast3D.get_collision_point().x)
	if(camplace):
		$Cam.position = $Player/Camera3D/RayCast3D.get_collision_point()
		$Cam.position.y += 1.5
		#print("Je ray pickable")
		#print($Cam.input_ray_pickable)
	
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


func _on_enemy_udelat_bordel_1() -> void:
	$BordelNaZemi/Bordel1.visible = true
	$Barikady/WinDown1.visible = false


func _on_enemy_udelat_bordel_2() -> void:
	$BordelNaZemi/Bordel2.visible = true
	$Barikady/WinDown2.visible = false


func _on_enemy_udelat_bordel_3() -> void:
	$BordelNaZemi/Bordel3.visible = true
	$Barikady/WinDown3.visible = false


func _on_enemy_udelat_bordel_4() -> void:
	$BordelNaZemi/Bordel4.visible = true
	$Barikady/WinDown4.visible = false


func _on_enemy_udelat_bordel_5() -> void:
	$BordelNaZemi/Bordel5.visible = true
	$Barikady/WinDown5.visible = false


func _on_enemy_udelat_bordel_6() -> void:
	$BordelNaZemi/Bordel6.visible = true
	$Barikady/WinDown6.visible = false


func _on_enemy_udelat_bordel_7() -> void:
	$BordelNaZemi/Bordel7.visible = true
	$Barikady/WinDown7.visible = false


func _on_player_set_win_1_visible() -> void:
	$Barikady/WinDown1.visible = true


func _on_player_set_win_2_visible() -> void:
	$Barikady/WinDown2.visible = true


func _on_player_set_win_3_visible() -> void:
	$Barikady/WinDown3.visible = true


func _on_player_set_win_4_visible() -> void:
	$Barikady/WinDown4.visible = true


func _on_player_set_win_5_visible() -> void:
	$Barikady/WinDown5.visible = true


func _on_player_set_win_6_visible() -> void:
	$Barikady/WinDown6.visible = true


func _on_player_set_win_7_visible() -> void:
	$Barikady/WinDown7.visible = true


func _on_player_refresh_location_label() -> void:
	$ControlPanel/MonsterLocationLabel.text = str(SimpletonScript.MonsterLoc[0]) +":"+ str(SimpletonScript.MonsterLoc[1])
