extends Node3D
signal usingcamera
var camplace = false
var whiteSquareSprite
var whiteSquares = []
# Called when the node enters the scene tree for the first time.
func _ready():
	whiteSquareSprite = $ControlPanel/BilyCtverec
	create_grid()
	whiteSquares[5][5].modulate = Color(0, 0, 1, 1)

func create_grid():
	var spacing = 0.15
	var grid_size = 11
	
	for y in range(grid_size):
		var row = []
		for z in range(grid_size):
			var new_square = whiteSquareSprite.duplicate()
			$ControlPanel.add_child(new_square)
			new_square.transform.origin = Vector3(-0.3, 0.8 + z * spacing,-1 + y * spacing)
			row.append(new_square)
		whiteSquares.append(row)
	
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
	$Player/ManagmentSystem.visible = true
	#if $Cam.visible == true:
		#$Cam/Camera3D.make_current()
		#emit_signal("usingcamera")


func _on_player_cam_1():
	$Cam/CamSprite.visible = true
	$Cam/ViewBox.visible = false





func _on_enemy_udelat_bordel(index: int, window_mesh_path: String, barricade_path: String, mess_path: String) -> void:
	if SimpletonScript.stavOken[index] == 0 and get_node(window_mesh_path + "/MeshInstance3D").visible == true:
		get_node(window_mesh_path + "/MeshInstance3D").visible = false
		get_node(window_mesh_path + "/BrokenOkno").visible = true
		get_node(window_mesh_path + "/GlassAudio").playing = true
	elif SimpletonScript.stavBarikad[index] == 0 and get_node(barricade_path).visible == true:
		get_node(mess_path).visible = true
		get_node(barricade_path).visible = false

func _on_enemy_udelat_bordel_1() -> void:
	_on_enemy_udelat_bordel(
		0,
		"OknaMeshes/OknoPredDole",
		"Barikady/WinDown1",
		"BordelNaZemi/Bordel1"
	)

func _on_enemy_udelat_bordel_2() -> void:
	_on_enemy_udelat_bordel(
		1,
		"OknaMeshes/OknoPredDole2",
		"Barikady/WinDown2",
		"BordelNaZemi/Bordel2"
	)

func _on_enemy_udelat_bordel_3() -> void:
	_on_enemy_udelat_bordel(
		2,
		"OknaMeshes/OknoVpravoDole",
		"Barikady/WinDown3",
		"BordelNaZemi/Bordel3"
	)

func _on_enemy_udelat_bordel_4() -> void:
	_on_enemy_udelat_bordel(
		3,
		"OknaMeshes/OknoVzaduDole",
		"Barikady/WinDown4",
		"BordelNaZemi/Bordel4"
	)

func _on_enemy_udelat_bordel_5() -> void:
	_on_enemy_udelat_bordel(
		4,
		"OknaMeshes/OknoVzaduDole2",
		"Barikady/WinDown5",
		"BordelNaZemi/Bordel5"
	)

func _on_enemy_udelat_bordel_6() -> void:
	_on_enemy_udelat_bordel(
		5,
		"OknaMeshes/OknoVlevoDole2",
		"Barikady/WinDown6",
		"BordelNaZemi/Bordel6"
	)

func _on_enemy_udelat_bordel_7() -> void:
	_on_enemy_udelat_bordel(
		6,
		"OknaMeshes/OknoVlevoDole",
		"Barikady/WinDown7",
		"BordelNaZemi/Bordel7"
	)



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

var prevCord = 178917931

func _on_player_refresh_location_label() -> void:
	var xCord = SimpletonScript.MonsterLoc[0]
	var yCord = SimpletonScript.MonsterLoc[1]
	var newCord = xCord*10 + yCord
	if newCord != prevCord:
		prevCord = newCord
		for a in range(11):
			for b in range(11):
				whiteSquares[a][b].modulate = Color(1, 1, 1, 1)
		
		var startXcord = (xCord - 1) - 1 + randi()%3
		var startYcord = (yCord - 1) - 1 + randi()%3
		whiteSquares[xCord][yCord].modulate = Color(1, 1, 0, 1)
		if SimpletonScript.radarRepaired == false:
			for x in range(3):
				for y in range(3):
					if startXcord +x >= 0 and startXcord + x <= 10 and startYcord +y >= 0 and startYcord + y <= 10:
						whiteSquares[startXcord + x][startYcord + y].modulate = Color(0.6, 0, 0, 1)
	if whiteSquares[5][5].modulate == Color(0.6, 0, 0, 1) or  whiteSquares[5][5].modulate == Color(1, 0, 0.3, 1) or  whiteSquares[5][5].modulate == Color(1, 1, 0, 1):
		whiteSquares[5][5].modulate = Color(1, 0, 0.3, 1)
	else:
		whiteSquares[5][5].modulate = Color(0, 0, 1, 1)
func _on_player_set_window_models() -> void:
	if SimpletonScript.generatorFull == true:
		$Benzin.visible = false
	if SimpletonScript.lureFixed == true:
		$ObnoveniZvuku/PcPropGreen.visible = true
		$ObnoveniZvuku/PcPropRed.visible = false
	if SimpletonScript.alarmFixed == true:
		$NavigationRegion3D/Props/Stul7/ObnoveniDetekce/PcPropGreen.visible = true
		$NavigationRegion3D/Props/Stul7/ObnoveniDetekce/PcPropRed.visible = false
	if SimpletonScript.radarRepaired == true:
		$AccRadarPuzzle/PcPropGreen.visible = true
		$AccRadarPuzzle/PcPropRed.visible = true
	if SimpletonScript.stavOken[0] == 0:
		$OknaMeshes/OknoPredDole/MeshInstance3D.visible = false
		$OknaMeshes/OknoPredDole/BrokenOkno.visible = true
	if SimpletonScript.stavOken[1] == 0:
		$OknaMeshes/OknoPredDole2/MeshInstance3D.visible = false
		$OknaMeshes/OknoPredDole2/BrokenOkno.visible = true
	if SimpletonScript.stavOken[2] == 0:
		$OknaMeshes/OknoVpravoDole/MeshInstance3D.visible = false
		$OknaMeshes/OknoVpravoDole/BrokenOkno.visible = true
	if SimpletonScript.stavOken[3] == 0:
		$OknaMeshes/OknoVzaduDole/MeshInstance3D.visible = false
		$OknaMeshes/OknoVzaduDole/BrokenOkno.visible = true
	if SimpletonScript.stavOken[4] == 0:
		$OknaMeshes/OknoVzaduDole2/MeshInstance3D.visible = false
		$OknaMeshes/OknoVzaduDole2/BrokenOkno.visible = true
	if SimpletonScript.stavOken[5] == 0:
		$OknaMeshes/OknoVlevoDole2/MeshInstance3D.visible = false
		$OknaMeshes/OknoVlevoDole2/BrokenOkno.visible = true
	if SimpletonScript.stavOken[6] == 0:
		$OknaMeshes/OknoVlevoDole/MeshInstance3D.visible = false
		$OknaMeshes/OknoVlevoDole/BrokenOkno.visible = true


func _on_sudoku_puzzle_sudoku_solved() -> void:
	$AccRadarPuzzle/PcPropRed.visible = false
	$AccRadarPuzzle/PcPropGreen.visible = true


func _on_player_open_lab_door() -> void:
	$LabLightGreen.visible = true
	$LabLightRed.visible = false
