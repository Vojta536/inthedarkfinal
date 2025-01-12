extends CharacterBody3D

var enemyInView = false

const SPEED = 2.5
const JUMP_VELOCITY = 4.5
var itemarr = [0,0,0,0]
var itemsel = 0
var camuse = false
var placecam = false
var collider
signal viewcam
signal cam1
signal cam2
signal cam3
signal camhand
signal placecamtrue
signal placecamfalse
signal camvisible
signal caminvisible

signal setWin1Visible
signal setWin2Visible
signal setWin3Visible
signal setWin4Visible
signal setWin5Visible
signal setWin6Visible
signal setWin7Visible

signal refreshLocationLabel

var FlashCharged = true
var LightVisible = true

var energy = 100.0

signal flashEnemy
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func get_ray_location():
	return $Camera3D/RayCast3D.get_collision_point().x

func _unhandled_input(event):
	if event is InputEventMouseMotion and camuse == false:
		self.rotate_y(-event.relative.x * 0.01)
		if $Camera3D.rotation.x > 1.5 and -event.relative.y < 0 :
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		if $Camera3D.rotation.x < -1.5 and -event.relative.y > 0 :
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		if $Camera3D.rotation.x <= 1.5 and $Camera3D.rotation.x >= -1.5:
			$Camera3D.rotate_x(-event.relative.y * 0.005)
		get_viewport().warp_mouse(get_viewport().size / 2.0)
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_1:
			if itemsel == 1:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 1
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.5)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_2:
			if itemsel == 2:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 2
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.5)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
		if event.pressed and event.keycode == KEY_3:
			if itemsel == 3:
				itemsel = 0
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.25)
			else:
				itemsel = 3
				$Camera3D/Control/ItemBox1.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox2.modulate = Color(1,1,1,0.25)
				$Camera3D/Control/ItemBox3.modulate = Color(1,1,1,0.5)


func update_items():
	match itemsel:
		1:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")
		2:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS2".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS2".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")
		3:
			if itemarr[itemsel] == 0:
				$"Camera3D/Control/Item1-AnS3".play("empty")
			if itemarr[itemsel] == 1:
				$"Camera3D/Control/Item1-AnS3".play("cam")
			if itemarr[itemsel] == 2:
				$"Camera3D/Control/Item1-AnS".play("baricade")



func _physics_process(delta):
	if Input.is_action_just_pressed("q") and energy > 80:
		if enemyInView == true:
			emit_signal("flashEnemy")
		if SimpletonScript.playernoise < 100:
			SimpletonScript.playernoise += 30
			if SimpletonScript.playernoise > 100:
				SimpletonScript.playernoise = 100
		$ReloadFlashlight.start()
		$Camera3D/SpotLight3D.light_energy = 4
		$FLash.playing = true
		energy = energy - 80
		if energy < 0:
			energy = 0
			LightVisible = false
	
	if $Camera3D/SpotLight3D.light_energy > 1:
		$Camera3D/SpotLight3D.light_energy -= 0.05 
	
	if Input.is_action_pressed("c"):
		LightVisible = false
		$Camera3D/SpotLight3D.light_energy = 0
		if energy < 100:
			if SimpletonScript.playernoise < 50:
				SimpletonScript.playernoise += 0.4
			energy = energy + 0.5
			if $HandCrank.playing == false:
				$HandCrank.playing = true
	elif $HandCrank.playing == true:
		$HandCrank.playing = false
	if LightVisible == true and energy > 0:
		energy = energy - 0.02
	
	$Camera3D/Control/Energy.text = str(round(energy)) + "%"
	
	if Input.is_action_just_pressed("r"):
		if LightVisible == true:
			LightVisible = false
			$Camera3D/SpotLight3D.light_energy = 0
		else:
			LightVisible = true
			$Camera3D/SpotLight3D.light_energy = 1
			
	if energy <= 0:
		LightVisible = false
		$Camera3D/SpotLight3D.light_energy = 0
	
	if itemarr[itemsel] == 1:
		if placecam == false:
			placecam = true
			emit_signal("camvisible")
			emit_signal("placecamtrue")
	if itemarr[itemsel] != 1:
		if placecam == true:
			placecam = false
			emit_signal("caminvisible")
			emit_signal("placecamfalse")
	
	if placecam == true and Input.is_action_pressed("e"):
		placecam = false
		emit_signal("placecamfalse")
		itemarr[itemsel] = 0
		update_items()
	 
	collider = $Camera3D/RayCast3D.get_collider()
	$Camera3D/Control/Point.modulate = Color(1,1,1,0.3)
	if $Camera3D/RayCast3D.is_colliding():
		if collider.name == "Cam":
			#print("Cam")
			pass
		if collider.name == "WinDown1":
			#print("WinDown1")
			pass

	if $Camera3D/RayCast3D.is_colliding():
		if collider.is_in_group("metal_doors") and Input.is_action_just_pressed("lclick"):
			collider._openClose()
			
	if $Camera3D/RayCast3D.is_colliding():
		if collider.name == "ButtonMonsterRefresh" and Input.is_action_just_pressed("lclick"):
			emit_signal("refreshLocationLabel")

		if collider.name == "Cam" and placecam == false:
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					if itemsel !=0:
						itemarr[itemsel] = 1
					update_items()

		if collider.name == "PickUpBar":
			if collider.visible == true:
				$Camera3D/Control/Point.modulate = Color(1,1,1,1)
				if Input.is_action_pressed("lclick"):
					if itemsel !=0:
						itemarr[itemsel] = 2
						collider.visible = false
					update_items()
					

		match(collider.name):
			"Bordel1":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[0] = 1
						emit_signal("setWin1Visible")
			"Bordel2":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[1] = 1
						emit_signal("setWin2Visible")
			"Bordel3":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[2] = 1
						emit_signal("setWin3Visible")
			"Bordel4":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[3] = 1
						emit_signal("setWin4Visible")
			"Bordel5":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[4] = 1
						emit_signal("setWin5Visible")
			"Bordel6":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[5] = 1
						emit_signal("setWin6Visible")
			"Bordel7":
				if collider.visible == true:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						collider.visible = false
						SimpletonScript.barikadyOken[6] = 1
						emit_signal("setWin7Visible")

		match(collider.name):
			"WinDown1":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[0] = 1
							update_items()
			"WinDown2":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[1] = 1
							update_items()
			"WinDown3":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[2] = 1
							update_items()
			"WinDown4":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[3] = 1
							update_items()
			"WinDown5":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[4] = 1
							update_items()
			"WinDown6":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[5] = 1
							update_items()
			"WinDown7":
				if collider.visible == false:
					$Camera3D/Control/Point.modulate = Color(1,1,1,1)
					if Input.is_action_pressed("lclick"):
						if itemarr[itemsel] == 2:
							itemarr[itemsel] = 0
							collider.visible = true
							SimpletonScript.barikadyOken[6] = 1
							update_items()





		if collider.name == "ViewCam":
			if Input.is_action_pressed("lclick"):
				emit_signal("viewcam")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_key_pressed(KEY_ESCAPE):
		camuse = false
		$Camera3D.make_current()
		$Camera3D/Control/EscapeLabel.visible = false
		$Camera3D/Control/Bila.visible = false
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and camuse == false:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")

	if input_dir != Vector2(0,0) and $step1.playing == false and $step2.playing == false and $step3.playing == false:
		$step1.playing = true

	if SimpletonScript.playernoise > 0:
		SimpletonScript.playernoise -= 0.1
	if input_dir != Vector2(0,0) and SimpletonScript.playernoise < 20:
		SimpletonScript.playernoise += 0.2
	if camuse == false:
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	else:
		velocity.x = 0
		velocity.z = 0
	$Camera3D/Control/Noise.text = str(round(SimpletonScript.playernoise))
	move_and_slide()











	


func _on_node_3d_usingcamera():
	camuse = true
	$Camera3D/Control/EscapeLabel.visible = true
	$Camera3D/Control/Bila.visible = true


func _on_enemy_detector_area_entered(area):
	if area.name == "EnemyArea":
		enemyInView = true
		print("enemakSpatren")


func _on_enemy_area_area_exited(area):
	if area.name == "EnemyArea":
		enemyInView = false
		print("enemakOdesel")


func _on_reload_flashlight_timeout():
	pass


func _on_audio_stream_player_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step3.playing = true
		else:
			$step2.playing = true


func _on_audio_stream_player_2_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step1.playing = true
		else:
			$step3.playing = true


func _on_audio_stream_player_3_finished() -> void:
	if Input.get_vector("a", "d", "w", "s") != Vector2(0,0):
		if randi() % 2 == 0:
			$step2.playing = true
		else:
			$step1.playing = true
